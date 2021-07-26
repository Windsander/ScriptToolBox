#!/bin/bash
chmod +x k8s_clusters_master_establish.sh

# 关键参数定义
MASTER_LIST={}
WORKER_LIST={}
MASTER_IP_1="192.168.122.10"              #cluster-master1's ip
MASTER_IP_2="192.168.122.20"              #cluster-master2's ip
MASTER_IP_3="192.168.122.30"              #cluster-master3's ip
VIRTUAL_IP="192.168.122.254"              #rafting control plane's ip
INTERFACE="eth0"                          #common network interface

#============================================== core ==============================================

# purify network environment
function purify_network_env() {
  echo "-- purify network environment::init ---"
  systemctl disable NetworkManager
  systemctl stop NetworkManager
  systemctl disable firewalld
  systemctl stop firewalld
  swapoff -a
  echo "-- purify network environment::done ---"
}

# auto config yum resources
function config_yum_repos() {
  echo "-- auto config yum resources::init ---"
  # shellcheck disable=SC2164
  yum install epel -y
  #wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
  cp /yum.repos.d/docker-ce.repo /etc/yum.repos.d/docker-ce.repo
  cp /yum.repos.d/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
  dnf remove podman -y
  yum erase podman buildah -y
  yum clean all
  yum update -y
  echo "-- auto config yum resources::init ---"
}

# install docker-ce
function install_docker_ce() {
  echo "-- install docker-ce::init ---"
  yum install docker-ce -y
  cp /etc.extras/daemon.json /etc/docker/daemon.json
  systemctl daemon-reload
  systemctl enable docker
  systemctl start docker
  echo "-- install docker-ce::done ---"
}

# prepare kubernetes components
function prepare_k8s_components() {
  echo "-- prepare kubernetes components::init ---"
  yum install kubeadm kubelet -y
  cp /etc.extras/k8s.conf /etc/sysctl.d/k8s.conf
  systemctl daemon-reload
  systemctl enable kubelet
  systemctl start kubelet
  echo "-- prepare kubernetes components::done ---"
}

# pulling kubernetes necessary images
function prepare_k8s_key_images() {
  echo "-- pulling kubernetes necessary images::init ---"
  kubeadm config images pull
  docker pull docker.mirrors.ustc.edu.cn/coredns/coredns:1.8.0
  docker tag docker.mirrors.ustc.edu.cn/coredns/coredns:1.8.0 registry.aliyuncs.com/google_containers/coredns:v1.8.0
  docker rmi docker.mirrors.ustc.edu.cn/coredns/coredns:1.8.0
  docker images
  echo "-- pulling kubernetes necessary images::done ---"
}

# establish haproxy & keepalived docker pods
function prepare_rafting_ip() {
  echo "-- establish haproxy docker pod::init ---"
  docker run -d --restart=always \
                --name haproxy-k8s -p 6444:6444 \
                -e MasterIP1=$MASTER_IP_1 \
                -e MasterIP2=$MASTER_IP_2 \
                -e MasterIP3=$MASTER_IP_3 \
                -e MasterPort=6443 \
                wise2c/haproxy-k8s
  echo "-- establish haproxy docker pod::done ---"
  echo "-- establish keepalived docker pod::init ---"
  docker run -itd --restart=always \
                --name=keepalived-k8s \
                -e VIRTUAL_IP=$VIRTUAL_IP \
                -e INTERFACE=$INTERFACE \
                -e CHECK_PORT=6444 \
                -e RID=10 \
                -e VRID=160 \
                -e NETMASK_BIT=24 \
                -e MCAST_GROUP=224.0.0.18 \
                wise2c/keepalived-k8s
  echo "-- establish keepalived docker pod::done ---"
}

# install kubernetes master node
function install_k8s_first_master() {
  echo "-- install kubernetes master node::init ---"
  echo "-- install kubernetes master node::generating kubeadm-config-temp file ---"
  cp kubeadm-config-master.yaml /etc/kubernetes/kubeadm-config-master_temp.yaml
  sed -i 's/MASTER_IP_1/'${MASTER_IP_1}'/g' /etc/kubernetes/kubeadm-config-master_temp.yaml
  sed -i 's/MASTER_IP_2/'${MASTER_IP_2}'/g' /etc/kubernetes/kubeadm-config-master_temp.yaml
  sed -i 's/MASTER_IP_3/'${MASTER_IP_3}'/g' /etc/kubernetes/kubeadm-config-master_temp.yaml
  sed -i 's/VIRTUAL_IP/'${VIRTUAL_IP}'/g' /etc/kubernetes/kubeadm-config-master_temp.yaml
  for worker in "${WORKER_LIST[@]}"
  do
    temp_append_str="- $worker
        WORKER_LIST
    "
    sed -i 's/WORKER_LIST/'${temp_append_str}'/' /etc/kubernetes/kubeadm-config-master_temp.yaml
  done
  sed -i '/WORKER_LIST/d' /etc/kubernetes/kubeadm-config-master_temp.yaml
  echo "-- install kubernetes master node::installing ---"
  kubeadm reset -y
  kubeadm init --config=/etc/kubernetes/kubeadm-config-master_temp.yaml | tee /etc/kubernetes/kubeadm-init.log
  echo "-- install kubernetes master node::installed ---"

  echo "-- install kubernetes master node::request local access ---"
  rm -rf $HOME/.kube
  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config
  kubectl get pods -n kube-system
  echo "-- install kubernetes master node::local access granted ---"

  echo "-- install kubernetes master node::add flannel to init coredns ---"
  cp kube-flannel.yml /etc/kubernetes/kube-flannel.yml
  kubectl create -f /etc/kubernetes/kube-flannel.yml
  echo "-- install kubernetes master node::flannel success ---"
}

# generate k8s remain nodes join script
function send_join_script_to_nodes() {
  echo "-- generate k8s remain nodes join script::init ---"
}

#============================================= parse ==============================================

# parse params from command line
help_str="
参数说明：
  -h, --help:                   打印帮助信息
  -m, --master [master_ip,..]:  指定初始化k8s集群的3台主机 IP。注意：第一位需要为当前执行命令的初始化节点
  -w, --worker [worker_ip,..]:  指定将要添加到集群的工作节点（IP 或 主机名）
  -c, --control_plane_ip:       指定用于负载均衡的k8s统一控制平台漂流 IP。注意：最好和 master 在同一网段下
"

# 解析命令行参数
getopt_cmd=$(getopt -o hm:a:c: --long help,master:,worker:,control_plane_ip: -n $(basename $0) -- "$@")
[ $? -ne 0 ] && exit 1
eval set -- "$getopt_cmd"
# 解析选项
while [ -n "$1" ]
do
  case "$1" in
    -h|--help)
      echo -e "$help_str"
      exit ;;
    -m|--master)
      MASTER_LIST=(${"$2"//,/ })
      MASTER_IP_1="${MASTER_LIST[1]}"
      MASTER_IP_2="${MASTER_LIST[2]}"
      MASTER_IP_3="${MASTER_LIST[3]}"
      shift ;;
    -w|--worker)
      WORKER_LIST=(${"$2"//,/ })
      shift ;;
    -c|--control_plane_ip)
      VIRTUAL_IP="$2"
      shift ;;
    --)
      shift
      break ;;
    *)
      echo "$1 is not an option"
      exit 1 ;;
  esac
  shift
done

purify_network_env
config_yum_repos
install_docker_ce
prepare_k8s_components
prepare_k8s_key_images
prepare_rafting_ip
install_k8s_first_master
send_join_script_to_nodes