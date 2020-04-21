locals {
  pdb_content = templatefile("${path.module}/templates/pdb.yaml", {
    name          = var.name
    k8s_namespace = var.k8s_namespace
  })
}

resource "null_resource" "pdb" {
  depends_on = [null_resource.remove_pdb]

  provisioner "local-exec" {
    command = "echo \"${self.triggers.content}\" | kubectl apply -f -"
  }

  triggers = {
    content = local.pdb_content
  }
}

resource "null_resource" "remove_pdb" {
  provisioner "local-exec" {
    when    = destroy
    command = "echo \"${self.triggers.content}\" | kubectl delete --ignore-not-found -f -"
  }

  triggers = {
    content = local.pdb_content
  }
}
