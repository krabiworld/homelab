#!/bin/bash

cd certificates || exit

# kubelet
kubectl config set-cluster krabernetes \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=vagrant.kubeconfig

kubectl config set-credentials system:node:vagrant \
    --client-certificate=vagrant.crt \
    --client-key=vagrant.key \
    --embed-certs=true \
    --kubeconfig=vagrant.kubeconfig

kubectl config set-context default \
    --cluster=krabernetes \
    --user=system:node:vagrant \
    --kubeconfig=vagrant.kubeconfig

kubectl config use-context default \
    --kubeconfig=vagrant.kubeconfig

# kube-proxy
kubectl config set-cluster krabernetes \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.crt \
    --client-key=kube-proxy.key \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
    --cluster=krabernetes \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default \
    --kubeconfig=kube-proxy.kubeconfig

# kube-controller-manager
kubectl config set-cluster krabernetes \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.crt \
    --client-key=kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
    --cluster=krabernetes \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default \
    --kubeconfig=kube-controller-manager.kubeconfig

# kube-scheduler
kubectl config set-cluster krabernetes \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.crt \
    --client-key=kube-scheduler.key \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context default \
    --cluster=krabernetes \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context default \
    --kubeconfig=kube-scheduler.kubeconfig

# admin
kubectl config set-cluster krabernetes \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

kubectl config set-credentials admin \
    --client-certificate=admin.crt \
    --client-key=admin.key \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

kubectl config set-context default \
    --cluster=krabernetes \
    --user=admin \
    --kubeconfig=admin.kubeconfig

kubectl config use-context default \
    --kubeconfig=admin.kubeconfig

cd ..
