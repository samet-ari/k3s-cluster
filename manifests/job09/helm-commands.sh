#!/bin/bash
# Job 09 — Helm : cycle de vie complet
# Exécuter depuis le master (K8S - 192.168.81.21)

# ── Prérequis ────────────────────────────────────────────────
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# ── 1. Installation de Helm ──────────────────────────────────
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

# ── 2. Ajout du dépôt podinfo ───────────────────────────────
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update
helm search repo podinfo

# ── 3. Installation avec personnalisation ───────────────────
helm install mon-app podinfo/podinfo \
  --set ui.message="Cluster K3S - La Plateforme" \
  --set replicaCount=2

# ── 4. Vérification ─────────────────────────────────────────
helm list
kubectl get pods -o wide

# ── 5. Exposition NodePort ───────────────────────────────────
kubectl expose deployment mon-app-podinfo \
  --port=9898 \
  --type=NodePort \
  --name=podinfo-np
kubectl get svc podinfo-np
# Accès : http://192.168.81.21:<NODE_PORT>

# ── 6. Mise à jour (upgrade) → REVISION 2 ───────────────────
helm upgrade mon-app podinfo/podinfo \
  --set ui.message="Cluster K3S - La Plateforme" \
  --set replicaCount=3

# ── 7. Historique ────────────────────────────────────────────
helm history mon-app

# ── 8. Rollback → REVISION 1 ────────────────────────────────
helm rollback mon-app 1
helm history mon-app

# ── 9. Désinstallation ──────────────────────────────────────
helm uninstall mon-app
kubectl delete svc podinfo-np
kubectl get pods
