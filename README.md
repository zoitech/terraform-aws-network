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

### Subnets creation

The default behavior is to create 3 public subnets and 3 private subnets, 1 per availability zone.

To define the subnets explicitly, set the following variables with an array of subnets in the CIDR notation (e.g.: "10.0.0.1/24"):
  * private_subnets_a
  * private_subnets_b
  * private_subnets_c
  * public_subnets_a
  * public_subnets_b
  * public_subnets_c

```hcl
module "network" {
  source = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name    = "my-vpc"
  vpc_network = "10.0.0.0/21"
  
  private_subnets_a = ["10.0.0.0/25","10.0.0.128/25"]
  private_subnets_b = ["10.0.1.0/25","10.0.1.128/25"]
  private_subnets_c = ["10.0.2.0/24","10.0.3.0/24"]

  public_subnets_a =  ["10.0.4.0/24"]
  public_subnets_b =  ["10.0.5.0/24"]
  public_subnets_c =  ["10.0.6.0/24","10.0.7.0/24"]
  
  create_nat = true
  create_igw = true
  region     = "eu-central-1"
}
```

When any of these variables are set, the module will create only the subnets that are explicitly declared (No default subnets are created).

**Please note: If you are creating only private subnets, the NAT Gateway will not be created**


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

Alternatively ACLs can be applied to private and public subnets separately via the variables "private_subnet_acl_rules" and "public_subnet_acl_rules" instead of using the variable "network_acl_rules".

### Transit Gateway Attachment to VPC

To attach a transit gateway (already existing) from another account, set the variable "create_tgw_attachment" to "true" (without quotations) along with "accept_resource_share", "share_arn", "transit_gateway_id" and "tgw_attachment_tag_name":

```hcl
module "network" {
  source                  = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name                = "my_vpc"
  vpc_network             = "10.161.32.0/21"
  region                  = "eu-central-1"
  create_tgw_attachment   = true
  accept_resource_share   = true
  share_arn               = "arn:aws:ram:eu-central-1:123456789123:resource-share/7ab74438-4ac2-0780-745d-1bf765ab5d7c"
  transit_gateway_id      = "tgw-12345678912345678"
  tgw_attachment_tag_name = "network-transitgw"
}
```
**Note: If a resource share was already accepted, the variable "accept_resource_share" can be set to *false***

For the transit gateway attachment to be successful:

1. In the account with the transit gateway: Share the transit gateway resource in the resource access manager with the account ID of the "child" account.
2. In the "child" account: Accept the resource share in the resource access manager.
3. In the account with the transit gateway: wait until the shared principal status for the "child" account is "associated" (otherwise step 4. will fail)
4. In the "child" account: Run and apply the terraform code referencing this module.
5. In the account with the transit gateway: The request to attach the transit gateway to the VPC from the "child" account needs to be accepted within the transit gateway resource (unless auto accept is activated).

### To Reference A Tagged Version of the Repository

To reference a tagged version of the repository:

```hcl
module "network" {
  source      = "git::https://github.com/zoitech/terraform-aws-network.git?ref=1.1.0"
  vpc_name    = "my_vpc"
  vpc_network = "10.161.32.0/21"
  region      = "eu-central-1"
}
```

# Authors
This module is maintained by [Zoi](https://github.com/zoitech).

# License
Licensed under the MIT License. Have a look at the file `LICENSE` for more information.
