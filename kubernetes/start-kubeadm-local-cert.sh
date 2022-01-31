rm -rf $HOME/.kube
mkdir -p $HOME/.kube
cd /etc/kubernetes/
cp -i admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get cs
sysctl -p /etc/sysctl.d/k8s.conf
