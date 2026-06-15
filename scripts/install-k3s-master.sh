#!/bin/bash
# install-k3s-master.sh
# Exécuter sur la VM master (K8S - 192.168.81.21) en tant que root

set -e

echo "=== Installation K3S Master ==="

# 1. Prérequis
apt update && apt install -y curl iptables

# 2. Installation K3S
curl -sfL https://get.k3s.io | sh -

# 3. Vérification
systemctl status k3s
kubectl get nodes

# 4. Afficher le token pour les workers
echo ""
echo "=== TOKEN POUR LES WORKERS ==="
cat /var/lib/rancher/k3s/server/node-token
echo ""
echo "Commande worker : curl -sfL https://get.k3s.io | K3S_URL=https://192.168.81.21:6443 K3S_TOKEN=<TOKEN> sh -"
