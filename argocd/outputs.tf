output "argocd_server_service_name" {
  value = helm_release.argocd.name
}

output "argocd_server_namespace" {
  value = helm_release.argocd.namespace
}
