locals {
  resources = [for value in module.server : {
    id   = value.server_id
    type = "server"
  }]

  ssh_private_key = "~/.ssh/id_rsa"

}

module "server" {
  for_each = var.servers

  source  = "deff-dev/cloud-server/timeweb"
  version = ">= 1.0.0"

  name          = each.key
  os            = each.value.os
  location      = each.value.location
  cpu_frequency = each.value.cpu_frequency
  disk_type     = each.value.disk_type

  preset       = each.value.preset
  configurator = each.value.configurator
  ssh_keys     = each.value.ssh_keys
}

module "firewall" {
  for_each = var.firewalls

  source     = "../"
  name       = each.key
  rules      = each.value.rules
  resources  = local.resources
  depends_on = [module.server, null_resource.default]
}

# Check when server started
resource "null_resource" "default" {
  for_each = module.server
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(local.ssh_private_key)
    host        = each.value.server_public_ip
  }

  provisioner "remote-exec" {
    inline = ["uptime"]
  }
}
