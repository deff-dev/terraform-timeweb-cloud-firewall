locals {
  parsed_rules = flatten([
    for rule in var.rules : [
      for port in coalesce(rule.ports, [null]) : [
        for cidr in coalesce(rule.cidrs, [""]) : {
          ports     = port
          protocol  = rule.protocol
          cidrs     = cidr
          direction = rule.direction
        }
      ]
    ]
  ])
}

resource "twc_firewall" "default" {
  name = var.name

  dynamic "link" {
    for_each = coalesce(var.resources, [])

    content {
      id   = link.value.id
      type = link.value.type
    }
  }
}

resource "twc_firewall_rule" "default" {
  for_each = { for key, rule in local.parsed_rules : key => rule }

  firewall_id = resource.twc_firewall.default.id
  direction   = each.value.direction
  port        = each.value.ports
  protocol    = each.value.protocol
  cidr        = each.value.cidrs

  lifecycle {
    precondition {
      condition     = contains(["egress", "ingress"], each.value.direction)
      error_message = "Error! Protocol does not support"
    }
    precondition {
      condition     = each.value.protocol == "icmp" || each.value.ports != null
      error_message = "Error! If protocol is 'icmp', ports must be empty."
    }
    precondition {
      condition     = contains(["udp", "tcp", "icmp"], each.value.protocol)
      error_message = "Error! Protocol does not support"
    }
  }
}