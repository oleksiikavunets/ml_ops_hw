# Опис проєкту

Цей проєкт створює інфраструктуру AWS, яка складається з:
- VPC (3 приватні + 3 публічні сабнети)
- Internet Gateway, NAT Gateway, маршрути
- EKS кластеру
- Node Group
- Окремих станів Terraform для root, VPC і EKS

Структура директорій
```commandline
eks-vpc-cluster/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tf
├── backend.tf
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   └── backend.tf
├── eks/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   └── backend.tf
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

## Запуск
1) Ініціалізація бекендів

У корені:
```commandline
terraform init
```

У vpc/:
```commandline
cd vpc
terraform init
cd ..
```
У eks/:
```commandline
cd eks
terraform init
cd ..
```
2) Створення інфраструктури
Створити VPC
```commandline
cd vpc
terraform plan
terraform apply -auto-approve
cd ..
```
Створити EKS
```commandline
terraform plan
terraform apply -auto-approve
```

## Підключення до EKS
Оновлюємо kubeconfig:
```commandline
aws eks update-kubeconfig --region us-east-1 --name hw-5-6-cluster --profile goit-terraform
```
Перевіряємо:
```commandline
kubectl get nodes
```

## Видалення всіх ресурсів
Спочатку видаляємо EKS:
```commandline
terraform destroy -auto-approve
```

Потім VPC:
```commandline
cd vpc
terraform destroy -auto-approve
```