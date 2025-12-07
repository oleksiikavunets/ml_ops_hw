resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.0"

  values = [file("${path.module}/values/argocd-values.yaml")]

  timeout = 600
  wait    = true

  depends_on = [kubernetes_namespace.argocd]
}

# Створюємо ArgoCD Application для Git-репозиторію
resource "kubernetes_manifest" "mlflow_app" {
  depends_on = [helm_release.argocd]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "mlflow"
      namespace = kubernetes_namespace.argocd.metadata[0].name
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/oleksiikavunets/hw-7-repo.git"
        targetRevision = "main"
        path           = "."       # де лежить application.yaml/values
        helm = {
          valueFiles = ["values/mlflow-values.yaml"]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "mlflow"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}
