#!/bin/bash
# install-k3s-worker.sh
# Exécuter sur kubes-01 (192.168.81.22) et kubes-02 (192.168.81.23) en tant que root
# Usage : ./install-k3s-worker.sh <TOKEN>

set -e

MASTER_IP="192.168.81.21"
TOKEN=$1

if [ -z "$TOKEN" ]; then
  echo "Usage : ./install-k3s-worker.sh <TOKEN>"
  echo "Récupérer le token sur le master : cat /var/lib/rancher/k3s/server/node-token"
  exit 1
fi

echo "=== Arrêt du K3S server local ==="
systemctl stop k3s || true
systemctl disable k3s || true

echo "=== Installation des prérequis ==="
apt update && apt install -y curl iptables

echo "=== Installation K3S Worker ==="
curl -sfL https://get.k3s.io | \
  K3S_URL=https://${MASTER_IP}:6443 \
  K3S_TOKEN=${TOKEN} sh -

echo "=== Vérification ==="
systemctl status k3s-agent
echo "Worker ajouté au cluster. Vérifier sur le master : kubectl get nodes"
