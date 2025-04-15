#!/bin/bash

cd certificates

openssl genrsa -out ca.key 4096
openssl req -x509 -new -sha512 -noenc \
    -key ca.key -days 3653 \
    -config ca.conf \
    -out ca.crt

certs=(
  admin
  vagrant
  kube-proxy
  kube-scheduler
  kube-controller-manager
  kube-api-server
  service-accounts
)

for i in ${certs[*]}; do
  openssl genrsa -out "${i}.key" 4096

  openssl req -new -key "${i}.key" -sha256 \
    -config "ca.conf" -section ${i} \
    -out "${i}.csr"

  openssl x509 -req -days 3653 -in "${i}.csr" \
    -copy_extensions copyall \
    -sha256 -CA "ca.crt" \
    -CAkey "ca.key" \
    -CAcreateserial \
    -out "${i}.crt"
done

mkdir -p /var/lib/kubernetes/

export ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

envsubst < ../configs/encryption-config.yaml > encryption-config.yaml

cp ca.crt ca.key \
    kube-api-server.key kube-api-server.crt \
    service-accounts.key service-accounts.crt \
    encryption-config.yaml \
    /var/lib/kubernetes/

cp ca.crt vagrant.crt vagrant.key /var/lib/kubelet

cd ..
