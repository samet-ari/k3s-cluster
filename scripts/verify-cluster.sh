#!/bin/bash
# verify-cluster.sh
# Vérification complète de l'état du cluster
# Exécuter depuis le master en tant que root

echo "======================================"
echo "  VÉRIFICATION CLUSTER K3S"
echo "======================================"

echo ""
echo "--- NODES ---"
kubectl get nodes -o wide

echo ""
echo "--- PODS ---"
kubectl get pods -o wide

echo ""
echo "--- SERVICES ---"
kubectl get services

echo ""
echo "--- PVC ---"
kubectl get pvc

echo ""
echo "--- CONFIGMAPS ---"
kubectl get configmaps

echo ""
echo "--- SECRETS ---"
kubectl get secrets

echo ""
echo "--- RBAC : ROLES ---"
kubectl get roles

echo ""
echo "--- RBAC : ROLEBINDINGS ---"
kubectl get rolebindings

echo ""
echo "--- HELM RELEASES ---"
helm list 2>/dev/null || echo "Helm non installé"

echo ""
echo "======================================"
echo "  TEST RBAC"
echo "======================================"
echo "list pods (stagiaire) :"
kubectl auth can-i list pods \
  --as=system:serviceaccount:default:stagiaire

echo "delete pods (stagiaire) :"
kubectl auth can-i delete pods \
  --as=system:serviceaccount:default:stagiaire
