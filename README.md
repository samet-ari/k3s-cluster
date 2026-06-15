# 🚢 Cluster K3S 

> Déploiement et gestion d'un cluster Kubernetes K3S sur 3 VM Debian 12 

---

## 📋 Vue d'ensemble

| Champ | Détail |
|---|---|
| **Auteur** | Samet ARI |
| **Formation** | Bachelor IT — Cybersécurité & Réseaux |
| **Version K3S** | v1.35.5+k3s1 |
| **OS** | Debian 12 Bookworm |
| **Hyperviseur** | VMware Workstation Pro |

---

## 🖥️ Architecture du cluster

```
┌─────────────────────────────────────────────────────┐
│                  UN SEUL CLUSTER K3S                │
│                                                     │
│  192.168.81.21        192.168.81.22   192.168.81.23 │
│  ┌─────────────┐    ┌───────────┐   ┌───────────┐  │
│  │ K8S         │    │ kubes-01  │   │ kubes-02  │  │
│  │ master      │    │ worker 1  │   │ worker 2  │  │
│  │ control-    │    │           │   │           │  │
│  │ plane       │    │           │   │           │  │
│  └─────────────┘    └───────────┘   └───────────┘  │
│         ↑                 ↑               ↑         │
│         └─────────────────┴───────────────┘         │
│              kubectl (depuis le master)              │
└─────────────────────────────────────────────────────┘
```

---

## 📁 Structure du dépôt

```
k3s-cluster/
├── README.md
├── docs/
│   └── Documentation_K3S_Samet_ARI.docx
├── manifests/
│   ├── job02/
│   │   ├── nginx-deployment.yaml
│   │   ├── apache-deployment.yaml
│   │   └── mariadb-deployment.yaml
│   ├── job04/
│   │   └── ha-deployments.yaml
│   ├── job05/
│   │   ├── nginx-pvc.yaml
│   │   └── mariadb-pvc.yaml
│   ├── job06/
│   │   └── nginx-configmap.yaml
│   ├── job07/
│   │   └── mariadb-secret.yaml
│   ├── job08/
│   │   ├── rbac-role.yaml
│   │   └── rbac-rolebinding.yaml
│   └── job09/
│       └── helm-commands.sh
└── scripts/
    ├── install-k3s-master.sh
    ├── install-k3s-worker.sh
    └── verify-cluster.sh
```

---

## 🗺️ Jobs réalisés

| Job | Objectif | Statut |
|---|---|---|
| **01** | Création des VM + Installation K3S | ✅ |
| **02** | Déploiement nginx, apache, mariadb | ✅ |
| **03** | Création du cluster (1 master + 2 workers) | ✅ |
| **04** | Haute disponibilité — test de panne worker | ✅ |
| **05** | Stockage persistant PV/PVC | ✅ |
| **06** | ConfigMaps | ✅ |
| **07** | Secrets | ✅ |
| **08** | RBAC — moindre privilège | ✅ |
| **09** | Helm — cycle de vie complet | ✅ |

---

## ⚡ Démarrage rapide

### Prérequis
- 3 VM Debian 12 (sans GUI)
- VMware Workstation Pro
- Accès SSH root sur chaque VM

### 1. Installation K3S — Master

```bash
curl -sfL https://get.k3s.io | sh -
kubectl get nodes
```

### 2. Récupérer le token

```bash
cat /var/lib/rancher/k3s/server/node-token
```

### 3. Joindre les workers

```bash
curl -sfL https://get.k3s.io | \
  K3S_URL=https://192.168.81.21:6443 \
  K3S_TOKEN=<TOKEN> sh -
```

### 4. Vérifier le cluster

```bash
kubectl get nodes
# NAME      STATUS   ROLES           AGE   VERSION
# k8s       Ready    control-plane   ...   v1.35.5+k3s1
# kubes01   Ready    <none>          ...   v1.35.5+k3s1
# kubes02   Ready    <none>          ...   v1.35.5+k3s1
```

### 5. Déployer les applications (HA)

```bash
kubectl apply -f manifests/job04/ha-deployments.yaml
kubectl get pods -o wide
```

---

## 🔑 Résultats clés

### Haute Disponibilité (Job 04)
Test réalisé : arrêt de kubes-02 → pods automatiquement replanifiés sur k8s et kubes-01 en ~5 minutes, sans intervention manuelle.

### Persistance des données (Job 05)
```bash
# Données écrites dans MariaDB
kubectl exec -it deployment/mariadb -- mariadb -uroot -pSuperSecret2026 \
  -e "SELECT * FROM laplateforme.etudiants;"
# Résultat après suppression/recréation du pod :
# +------+-------+
# | id   | nom   |
# +------+-------+
# |    1 | Samet |
# +------+-------+
```

### RBAC (Job 08)
```bash
# Lecture autorisée
kubectl auth can-i list pods --as=system:serviceaccount:default:stagiaire
# yes

# Suppression interdite
kubectl auth can-i delete pods --as=system:serviceaccount:default:stagiaire
# no
```

---

## 🛠️ Stack technique

![Kubernetes](https://img.shields.io/badge/K3S-v1.35.5-blue)
![Debian](https://img.shields.io/badge/Debian-12_Bookworm-red)
![Helm](https://img.shields.io/badge/Helm-v3-blueviolet)
![VMware](https://img.shields.io/badge/VMware-Workstation_Pro-607078)

- **K3S** v1.35.5+k3s1
- **Helm** v3
- **Applications** : nginx, Apache httpd, MariaDB, podinfo
- **StorageClass** : local-path (natif K3S)

---

## 📚 Compétences visées

- Administrer et sécuriser les infrastructures systèmes
- Administrer et sécuriser les infrastructures virtualisées
- Mettre en œuvre et optimiser la supervision des infrastructures

---
