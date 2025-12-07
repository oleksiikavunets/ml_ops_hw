# Опис проєкту

Цей проєкт створює інфраструктуру AWS та налаштовує автоматичне розгортання застосунків у Kubernetes за допомогою GitOps:

- **VPC** з 3 приватними та 3 публічними сабнетами  
- **Internet Gateway**, **NAT Gateway**, маршрути  
- **EKS кластер**  
- **Node Group** для запуску подів  
- **Окремі стани Terraform** для root, VPC та EKS  
- **ArgoCD**, розгорнутий у Kubernetes через Helm і Terraform, для управління застосунками  
- **Автоматичне слідкування за Git-репозиторієм** [hw-7-repo](https://github.com/oleksiikavunets/hw-7-repo.git)
  - MLflow деплоїться автоматично через ArgoCD  
  - Використовується Helm chart та кастомні `values.yaml` для конфігурації застосунку  
- **Можливість швидкого доступу до ArgoCD UI та MLflow UI** через `kubectl port-forward` або LoadBalancer  
- **Повне керування інфраструктурою через Terraform**, включно з видаленням ресурсів (`terraform destroy`) для економії коштів


Структура директорій

```commandline
ml_ops_hw/
├── argocd/
│   ├── main.tf
│   ├── variables.tf
│   ├── provider.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   ├── backend.tf
│   └── values/
│       └── argocd-values.yaml
├── eks-vpc-cluster/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   ├── backend.tf
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tf
│   │   └── backend.tf
│   └── eks/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tf
│       └── backend.tf
└── README.md

```

## Попередні вимоги

Встановити:
-AWS CLI
-Terraform ≥ 1.6
-kubectl

Створити AWS профіль:

```commandline
aws configure --profile goit-terraform
```

## 1. Розгортання VPC та EKS
- Створюється VPC, subnets, security groups
- Піднімається EKS кластер

```commandline
cd eks-vpc-cluster/
terraform init
terraform apply
```

1.1. Перевірка кластеру:

- Оновлюємо kubeconfig:

```commandline
aws eks update-kubeconfig --region us-east-1 --name hw-7-cluster --profile goit-terraform
```

- Перевіряємо:

```commandline
kubectl get nodes
```

## 2. Розгортання ArgoCD через Terraform
- Створюється namespace infra-tools
- Встановлюється ArgoCD через Helm chart
- Створюється ArgoCD Application, який підключається до Git-репозиторію hw-7-repo та деплоїть MLflow

```commandline
cd ../argocd/
terraform init
terraform apply
```

2.1 Перевірка подів:
```commandline
kubectl get pods -n infra-tools
```

## 3. Доступ до ArgoCD UI

3.1 Зробити Port-forward:
```commandline
kubectl port-forward svc/argocd-server -n infra-tools 8080:80
```

3.2. Відкрити браузер: https://localhost:8080 і залогінитись:
- логін: admin
- пароль: 
```commandline
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## 4. Видалення всіх ресурсів
4.1. Видалення ArgoCD
```commandline
cd argocd
terraform destroy -auto-approve
```
4.2. Видалення кластеру
```commandline
cd ../eks-vpc-cluster/
terraform destroy -auto-approve
```