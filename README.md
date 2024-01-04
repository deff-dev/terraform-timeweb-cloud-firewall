<h1 align="center">  TimeWeb-Cloud Firewall Terraform module  </h1>


<div align="center">

![Release](https://img.shields.io/github/v/release/deff-dev/terraform-timeweb-cloud-firewall)
![Forks](https://img.shields.io/github/forks/deff-dev/terraform-timeweb-cloud-firewall)
![Stars](https://img.shields.io/github/stars/deff-dev/terraform-timeweb-cloud-firewall)
![License](https://img.shields.io/github/license/deff-dev/terraform-timeweb-cloud-firewall)

</div>


## 📝 Table of Contents

- [About](#about)
- [Usage](#usage)
- [Example](#example)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Authors](#authors)
- [License](#license)

## 🧐 About <a name = "about"></a>
Terraform module which creates firewall on TimeWeb Cloud

## 🎈 Usage <a name = "usage"></a>

### FireWall with Single Server
```hcl
module "server" {
  source  = "deff-dev/cloud-server/timeweb"
  version = ">= 1.0.0"

  name = "Single-preset"
  os = {
    name    = "ubuntu"
    version = "22.04"
  }
  location      = "ru-1"
  cpu_frequency = 3.3
  disk_type     = "nvme"

  preset = {
    cpu  = 1
    ram  = 1
    disk = 15

    price = {
      min = 100
      max = 200
    }
  }

  ssh_keys = ["key_name_1", "key_name_2"]
}

module "firewall" {
  source = "deff-dev/cloud-firewall/timeweb"

  name = "Web"
  rules = [
    {
      ports     = [80, 443]
      protocol  = "tcp"
      cidrs     = ["192.168.0.0/24", "192.167.11.112"]
      direction = "ingress"

    },
    {
      ports     = [80, 443]
      protocol  = "udp"
      cidrs     = [""]
      direction = "egress"
    },
  ]
  resources = [
    {
      id   = module.server.server_id
      type = "server"
    }
  ]
  depends_on = [module.server, null_resource.default]
}

# Check when server started
resource "null_resource" "default" {
  for_each = module.server
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = each.value.server_public_ip
  }

  provisioner "remote-exec" {
    inline = ["uptime"]
  }
}

```

## 😊 Example <a name = "example"></a>

- [Multiple Firewalls with servers](https://github.com/deff-dev/terraform-timeweb-cloud-firewall/tree/main/example)

## 📋 Requirements <a name = "requirements"></a>

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://www.terraform.io/) | >= 1.3 |
| <a name="requirement_timeweb-cloud"></a> [timeweb-cloud](https://registry.terraform.io/providers/timeweb-cloud/timeweb-cloud/latest/docs/) | >= 1.1.0 |

## ☁️ Providers <a name = "providers"></a>

| Name | Version |
|------|---------|
| <a name="provider_timeweb-cloud"></a> [timeweb-cloud](https://registry.terraform.io/providers/timeweb-cloud/timeweb-cloud/latest/docs/) | >= 1.1.0 |

## 📦 Modules <a name = "modules"></a>

| Name | Version |
|------|---------|
| <a name="module_server"></a> [server](https://github.com/deff-dev/terraform-timeweb-cloud-server) | >= 1.0.0 |

## 🌐 Resources <a name = "resources"></a>

| Name | Type |
|------|------|
| [twc_firewall.default](https://registry.terraform.io/providers/timeweb-cloud/timeweb-cloud/latest/docs/resources/firewall) | resource |
| [twc_firewall_rule.default](https://registry.terraform.io/providers/timeweb-cloud/timeweb-cloud/latest/docs/resources/firewall_rule) | resource |

## 📥 Inputs <a name = "inputs"></a>

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for FireWall | `string` | `"Managed by terraform"` | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Information about rules | `list(object)` |  `null` | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | Link resources| `list(object)` | `null` | no |

## 📤 Outputs <a name = "outputs"></a>

| Name | Description |
|------|-------------|
| <a name="output_firewall_id"></a> [firewall_id](#output\_firewall\_id) | Return firewall id |

## ✍️ Authors <a name = "authors"></a>

Module is maintained by [Deff](https://github.com/deff-dev). <br>
Thanks for help [denismaster](https://gitlab.com/denismaster).

## 🔑 License <a name = "license"></a>

Apache 2 Licensed. See [LICENSE](https://github.com/deff-dev/terraform-timeweb-cloud-firewall/blob/main/LICENSE) for full details.
