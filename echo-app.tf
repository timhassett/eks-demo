data "kubectl_file_documents" "deployment-docs" {
    content = file("${path.module}/manifests/deployment.yaml")
}

resource "kubectl_manifest" "deployment" {
    for_each  = data.kubectl_file_documents.deployment-docs.manifests
    yaml_body = each.value
}
