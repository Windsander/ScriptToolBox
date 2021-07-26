#!/bin/bash
chmod +x auto_nat_port_mapping.sh

function auto() {
  echo "-- auto_nat_port_mapping::happen ---"

  # 关键参数定义
  IF0="eth0"                                 #映射网卡（有线）
  IF1="wlan0"                                #映射网卡（无线）
  INNET="192.168.122.0/24"                   #关联网段
  NAT_IP_PREFIX="192.168.122."               #领域内NAT网段信息
  NAT_IP_L=2                                 #领域内NAT主机起点ip
  NAT_IP_R=254                               #领域内NAT主机终点ip
  OPENING_PORT=(20 21 22 80 2379 2380 6443)  #如有需要：1433（SQL对外） 3306（MySQL 服务） 3389（Window 远程桌面服务）
  FTP_PASV_PORTS_ENTRY=49999                 #FTP 被动模式端口起点（会从此端口开始开启5个连续端口，用于FTP被动模式）

  # 读取外部配置
  while getopts "e:w:i:p:l:r:h" opts
  do
    case $opts in
      e)
        #IF0:映射网卡（有线）
        IF0=$OPTARG
        ;;
      w)
        #IF1:映射网卡（无线）
        IF1=$OPTARG
        ;;
      i)
        #INNET:关联网段
        INNET=$OPTARG
        ;;
      p)
        #NAT_IP_PREFIX:领域内NAT网段信息
        NAT_IP_PREFIX=$OPTARG
        ;;
      l)
        #NAT_IP_L:领域内NAT主机起点ip
        NAT_IP_L=$OPTARG
        ;;
      r)
        #NAT_IP_R:领域内NAT主机终点ip
        NAT_IP_R=$OPTARG
        ;;
      h)
        echo -e "OPTIONS:"
        echo -e "-e:映射有线网卡（必选）"
        echo -e "-w:映射无线网卡（必选）"
        echo -e "-i:关联网段"
        echo -e "-p:领域内NAT网段信息"
        echo -e "-l:领域内NAT主机起点ip"
        echo -e "-r:领域内NAT主机终点ip"
        exit 1
        ;;
      ?)
        echo "missing options, pls do the check!"
        exit 1
        ;;
    esac
  done

  # 清除 iptables 历史规则
  for tb in filter nat mangle; do
    iptables -t $tb -F
    iptables -t $tb -X
    iptables -t $tb -Z
  done

  # 配置 iptables 转发规则 & 启动环路地址
  iptables -P INPUT DROP
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

  # 配置 ip 转发(默认配置 & 当前生效)
  sed -i "s/\#net\.ipv4\.ip_forward=1/net\.ipv4\.ip_forward=1/g" /etc/sysctl.conf
  echo "1" >/proc/sys/net/ipv4/ip_forward

  # 设置可访问主机 ip 列表(指定ip)
#  for ip in "$@"; do
#    echo "please enter access ip:"
#    iptables -A INPUT -s $ip -p icmp -j ACCEPT
#    iptables -A INPUT -s $ip -p tcp --dport 22 -j ACCEPT
#    iptables -A INPUT -s $ip -p tcp --dport 5900:5990 -j ACCEPT
#  done

   # 设置可访问主机 ip 列表(无ip限定)
  iptables -A INPUT -p icmp -j ACCEPT
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A INPUT -p tcp --dport 5900:5990 -j ACCEPT

  # kvm 服务端口映射
  iptables -A INPUT -p tcp --dport 50120 -j ACCEPT

  # 更新 NAT 缓存 & 消息队列
  iptables -t nat -A POSTROUTING -s $INNET -o $IF0 -j MASQUERADE
  iptables -t nat -A POSTROUTING -s $INNET -o $IF1 -j MASQUERADE

  # 虚拟机端口映射 & ftp pasv 端口设置
  for i in $(seq $NAT_IP_L $NAT_IP_R); do
    [ "$i" == "26" ] && continue

    for j in ${#OPENING_PORT[*]}; do
      DPORT=$((1000 * $i + $j))
      iptables -t nat -A PREROUTING -i $IF0 -p tcp -m tcp --dport $DPORT \
        -j DNAT --to-destination ${NAT_IP_PREFIX}$i:$j
      iptables -t nat -A PREROUTING -i $IF1 -p tcp -m tcp --dport $DPORT \
        -j DNAT --to-destination ${NAT_IP_PREFIX}$i:$j
    done

    for ((p = 1; p <= 5; p++)); do
      PASV_PORT=$((FTP_PASV_PORTS_ENTRY = $FTP_PASV_PORTS_ENTRY + 1))
      iptables -t nat -A PREROUTING -i $IF0 -p tcp -m tcp --dport $PASV_PORT \
        -j DNAT --to-destination ${NAT_IP_PREFIX}$i:$PASV_PORT
      iptables -t nat -A PREROUTING -i $IF1 -p tcp -m tcp --dport $PASV_PORT \
        -j DNAT --to-destination ${NAT_IP_PREFIX}$i:$PASV_PORT
    done
  done
  echo "-- auto_nat_port_mapping::finish ---"
}


echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf        ##开启路由转发功能
sysctl -p                       ##使其生效
iptables -t nat -I POSTROUTING -j SNAT -s 192.168.20.0/24 --to-source 192.168.10.12      ##配置策略使内网可以ping通外网
iptables -t nat -A PREROUTING -j DNAT -d 192.168.10.12 -p tcp --dport 80 --to-destination 192.168.20.13             ##配置策略映射内网服务