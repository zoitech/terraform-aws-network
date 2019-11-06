# terraform-aws-network

Terraform module for creating/managing VPCs and network resources.

# Description

This module creates the following resources:

* VPC
* 3 Public Subnets
* 3 Private Subnets
* Public Routing Tables
* Private Routing Tables
* DHCP Options (Optional)
* Internet Gateway (Optional)
* NAT Gateway (Optional) (Dependent on Internet Gateway)
* Elastic IP for NAT Gateway (Optional)
* Network ACL (Optional)
* Transit Gateway attachment to the VPC (Optional)

## Usage

### Internet and NAT Gateways

A Internet Gateway or NAT Gateway are not created by default.

Setting the arguments "create_igw" and "create_nat" to "true" will create an internet gateway and nat gateway respectively.

Setting "create_nat" to "true" will create the following:

* NAT gateway
* Elastic IP for the NAT gateway
* A route in the private routing table for the NAT gateway

**Please note: If "create_nat" is set to "true" but "create_igw" is set to "false", the NAT Gateway will not be created.**

```hcl
module "network" {
  source      = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name    = "my_vpc"
  vpc_network = "10.161.32.0/21"
  region      = "eu-central-1"
  create_igw  = true
  create_nat  = true
}
```

### DHCP Options

To configure DHCP options, "create_dhcp" needs to be set to "true", upon which the following DHCP options can be set (**at least 1 needs to be configured**):

* domain_name
* domain_name_servers
* ntp_servers
* netbios_name_servers
* netbios_node_type

```hcl
module "network" {
  source               = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name             = "my_vpc"
  vpc_network          = "10.161.32.0/21"
  region               = "eu-central-1"
  create_dhcp          = true
  domain_name          = "example.com"
  domain_name_servers  = ["8.8.8.8", "8.8.4.4"]
  ntp_servers          = ["127.0.0.1"]
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2
}
```

### Network ACLs

To add ACLs to all subnets within the VPC, include a list of maps within the "network_acl_rules" argument, as per the example shown below:

```hcl
module "network" {
  source             = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name           = "my_vpc"
  vpc_network        = "10.161.32.0/21"
  region             = "eu-central-1"
  create_network_acl = true
  network_acl_rules  = [
  {
    egress      = true
    rule_number = 150
    rule_action = "deny"
    cidr_block  = "10.0.0.0/24"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22

  },
  {
    egress      = true
    rule_number = 200
    rule_action = "deny"
    cidr_block  = "10.0.2.0/24"
    protocol    = "tcp"
    from_port   = 23
    to_port     = 23
  },
  {
    egress      = false
    rule_number = 200
    rule_action = "deny"
    cidr_block  = "10.0.2.0/24"
    protocol    = "tcp"
    from_port   = 23
    to_port     = 23
  },
]
}
```

### Transit Gateway Attachment to VPC

To attach a transit gateway (already existing) from another account, set the variable "create_tgw_attachment" to "true" (without quotations) along with "transit_gateway_id" and "tgw_attachment_tag_name":

```hcl
module "network" {
  source                  = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name                = "my_vpc"
  vpc_network             = "10.161.32.0/21"
  region                  = "eu-central-1"
  create_tgw_attachment   = true
  transit_gateway_id      = "tgw-12345678912345678"
  tgw_attachment_tag_name = "network-transitgw"
}
```

For the transit gateway attachment to be successful:
#!#!#!#!
1. The transit gateway resource needs to be shared in the resource access manager of the network account to the account ID of the sandbox/project account being configured
2. The terraform code for the sandbox/project account referencing the terraform.module.network module needs to be applied.
3. The request to attach the transit gateway to the VPC in the sandbox/project account needs to be accepted within the trumpf network account.
#!#!#!#!

### To Reference A Tagged Version of the Repository

To reference a tagged version of the repository:

```hcl
module "network" {
  source = "git::https://https://gitlab.com/TRUMPF-corp/ccc/terraform.module.network.git?ref=0.0.4"
  vpc_name    = "my_vpc"
  vpc_network = "10.161.32.0/21"
  region      = "eu-central-1"
}
```

# Authors
This module is maintained by [Zoi](https://github.com/zoitech).

# License
Licensed under the MIT License. Have a look at the file `LICENSE` for more information.
