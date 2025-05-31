#!/bin/bash

wget -q --show-progress \
  --https-only \
  --timestamping \
  -P downloads \
  -i downloads.txt

mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /etc/containerd \
  /etc/etcd \
  /var/lib/etcd \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes

cd downloads || exit

# CNI
mkdir cni
tar -xvf cni-plugins-linux-arm64-v1.6.2.tgz -C cni
cp cni/* /opt/cni/bin
cp configs/10-bridge.conf configs/99-loopback.conf /etc/cni/net.d/

modprobe br-netfilter
echo "br-netfilter" >> /etc/modules-load.d/modules.conf

echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/kubernetes.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/kubernetes.conf
sysctl -p /etc/sysctl.d/kubernetes.conf

# runc
install -m 755 runc.arm64 /usr/local/bin/runc

# Containerd
mkdir containerd
tar -xvf containerd-2.1.0-beta.0-linux-arm64.tar.gz -C containerd
cp containerd/bin/containerd containerd/bin/containerd-shim-runc-v2 containerd/bin/containerd-stress /bin/
cp ../configs/containerd-config.toml /etc/containerd/config.toml

# etcd
mkdir etcd
tar -xvf etcd-v3.6.0-rc.3-linux-arm64.tar.gz -C etcd
cp etcd/*/etcd* /usr/local/bin/
chmod 700 /var/lib/etcd
cp ../certificates/ca.crt ../certificates/kube-api-server.key ../certificates/kube-api-server.crt /etc/etcd/

# Kubernetes
chmod +x kube-apiserver \
    kube-controller-manager \
    kube-scheduler kubectl \
    kube-proxy kubelet

cp kube-apiserver \
    kube-controller-manager \
    kube-scheduler kubectl \
    kube-proxy kubelet \
    /usr/local/bin/

cd ..
