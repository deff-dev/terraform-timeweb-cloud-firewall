firewalls = {
  web = {
    rules = [
      {
        ports     = [80, 443]
        protocol  = "udp"
        cidrs     = ["192.168.0.0/24", "192.167.0.0/24"]
        direction = "ingress"

      },
      {
        ports     = [80, 443]
        protocol  = "tcp"
        cidrs     = [""]
        direction = "egress"
      },
    ]
  }
  mysql = {
    rules = [
    {
      ports     = [3306]
      protocol  = "udp"
      cidrs      = [""]
      direction = "egress"

    },
    {
      ports     = [3306]
      protocol  = "tcp"
      cidrs      = ["0.0.0.0/0"]
      direction = "ingress"
    },
  ]
  }
}

servers = {
  server_with_preset = {
    location      = "ru-1",
    cpu_frequency = 3.3,
    disk_type     = "nvme",
    preset = {
      cpu  = 1
      ram  = 1
      disk = 15

      price = {
        min = 100
        max = 200
      }
    }
    os = {
      name    = "ubuntu"
      version = "22.04"
    }
    ssh_keys = ["key_name_1", "key_name_2"]
  }
}