#!/bin/bash

# Containerd
cp services/containerd.service /etc/systemd/system/

# etcd
cp services/etcd.service /etc/systemd/system/

# Kube apiserver
cp services/kube-apiserver.service /etc/systemd/system/kube-apiserver.service

# Kube controller manager
cp certificates/kube-controller-manager.kubeconfig /var/lib/kubernetes/
cp services/kube-controller-manager.service /etc/systemd/system/

# Kube scheduler
cp certificates/kube-scheduler.kubeconfig /var/lib/kubernetes/
mkdir -p /etc/kubernetes/config/
cp configs/kube-scheduler.yaml /etc/kubernetes/config/
cp services/kube-scheduler.service /etc/systemd/system/

# Kubelet
cp certificates/vagrant.kubeconfig /var/lib/kubelet/kubeconfig
cp configs/kubelet-config.yaml /var/lib/kubelet/
cp services/kubelet.service /etc/systemd/system/

# Kube proxy
cp certificates/kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
cp configs/kube-proxy-config.yaml /var/lib/kube-proxy/
cp services/kube-proxy.service /etc/systemd/system/

systemctl daemon-reload

systemctl enable --now containerd

systemctl enable --now etcd

systemctl enable --now kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy
