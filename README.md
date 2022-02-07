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
* VPC Gateway for S3 (Optional)

## Usage

### Subnets creation

The default behavior is to create 3 public subnets and 3 private subnets, 1 per availability zone.

To define the subnets explicitly, set the following variables with an array of subnets in the CIDR notation (e.g.: "10.0.1.0/24):
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
  sn_private_a_tags = [
    {
      key1 = "key1_value"
      key2 = "key2_value"
      key3   = 0
      key4  = true
    },
    {
      key1 = "key1_value"
      key2 = "key2_value"
      key3   = 90
      key4  = false
    }
  ]
  private_subnets_b = ["10.0.1.0/25","10.0.1.128/25"]
  private_subnets_c = ["10.0.2.0/24","10.0.3.0/24"]

  public_subnets_a =  ["10.0.4.0/24"]
  sn_public_a_tags = [
    {
      key1 = "key1_value"
      key2 = "key2_value"
      key3   = 0
      key4  = true
    }
  ]
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

### VPC Gateway for S3

A VPC Gateway for S3 is not created by default.

Setting the argument "create_vpcep_s3" to "true" will create a VPC Gateway for S3.

Setting "create_vpcep_s3" to "true" will create the following:

* VPC Gateway for S3 w/ policy
* A route in the public and private route table pointing to the VPC Gateway for S3

```hcl
module "network" {
  source      = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name    = "my_vpc"
  vpc_network = "10.161.32.0/21"
  region      = "eu-central-1"
  create_vpcep_s3 = true
}
```

### VPC Gateway for DynamoDB

A VPC Gateway for DynamoDB is not created by default.

Setting the argument "create_vpcep_dynamodb" to "true" will create a VPC Gateway for DynamoDB.

Setting "create_vpcep_dynamodb" to "true" will create the following:

* VPC Gateway for DynamoDB w/ policy
* A route in the public and private route table pointing to the VPC Gateway for DynamoDB

```hcl
module "network" {
  source      = "git::https://github.com/zoitech/terraform-aws-network.git"
  vpc_name    = "my_vpc"
  vpc_network = "10.161.32.0/21"
  region      = "eu-central-1"
  create_vpcep_dynamodb = true
}
```

### To Reference A Tagged Version of the Repository

Please refer to [changelog.md](changelog.md) for the latest release.

```hcl
module "network" {
  source      = "git::https://github.com/zoitech/terraform-aws-network.git?ref=2.4.0"
  vpc_name    = "my_vpc"
  vpc_network = "10.161.32.0/21"
  region      = "eu-central-1"
}
```

# Authors
This module is maintained by [Zoi](https://github.com/zoitech).

# License
Licensed under the MIT License. Have a look at the file `LICENSE` for more information.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway_without_ram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.natgw_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.natgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private_subnets_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public_subnets_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.vpc_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.acl_rule_deny](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_all_egress_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_all_ingress_in](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.private_subnet_acl_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_subnet_acl_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_ram_resource_share_accepter.network_transit_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter) | resource |
| [aws_route.rt_private_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.rt_private_transit_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.rt_public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.rt_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.rt_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rt_private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_private_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_private_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_public_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_public_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.sn_private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_private_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_private_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_public_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_public_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.dynamodb_private_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.dynamodb_public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.s3_private_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.s3_public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accept_resource_share"></a> [accept\_resource\_share](#input\_accept\_resource\_share) | Does the resource access manager resource share containaing the transit gateway need to be accepted? | `bool` | `false` | no |
| <a name="input_az1"></a> [az1](#input\_az1) | Availabilty zone for Subnet A | `string` | `""` | no |
| <a name="input_az2"></a> [az2](#input\_az2) | Availabilty zone for Subnet B | `string` | `""` | no |
| <a name="input_az3"></a> [az3](#input\_az3) | Availabilty zone for Subnet C | `string` | `""` | no |
| <a name="input_create_dhcp"></a> [create\_dhcp](#input\_create\_dhcp) | DHCP | `bool` | `false` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Create Internet GW for public subnets if set to true | `bool` | `false` | no |
| <a name="input_create_nat"></a> [create\_nat](#input\_create\_nat) | Create NAT GW for private subnets if set to true | `bool` | `false` | no |
| <a name="input_create_network_acl"></a> [create\_network\_acl](#input\_create\_network\_acl) | network acl # entire vpc | `bool` | `false` | no |
| <a name="input_create_private_subnet_acl"></a> [create\_private\_subnet\_acl](#input\_create\_private\_subnet\_acl) | # private subnets only | `bool` | `false` | no |
| <a name="input_create_public_subnet_acl"></a> [create\_public\_subnet\_acl](#input\_create\_public\_subnet\_acl) | # public subnets only | `bool` | `false` | no |
| <a name="input_create_tgw_attachment"></a> [create\_tgw\_attachment](#input\_create\_tgw\_attachment) | n/a | `bool` | `false` | no |
| <a name="input_create_tgw_attachment_without_ram"></a> [create\_tgw\_attachment\_without\_ram](#input\_create\_tgw\_attachment\_without\_ram) | n/a | `bool` | `false` | no |
| <a name="input_create_vpcep_dynamodb"></a> [create\_vpcep\_dynamodb](#input\_create\_vpcep\_dynamodb) | Create VPC endpoint for DynamoDB if set to true | `bool` | `false` | no |
| <a name="input_create_vpcep_s3"></a> [create\_vpcep\_s3](#input\_create\_vpcep\_s3) | Create VPC endpoint for S3 if set to true | `bool` | `false` | no |
| <a name="input_dhcp_domain_name"></a> [dhcp\_domain\_name](#input\_dhcp\_domain\_name) | n/a | `string` | `""` | no |
| <a name="input_domain_name_servers"></a> [domain\_name\_servers](#input\_domain\_name\_servers) | n/a | `list` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | (Optional) A boolean flag to enable/disable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_igw_tags"></a> [igw\_tags](#input\_igw\_tags) | Map containing key value tag pairs | `map(string)` | `{}` | no |
| <a name="input_nat_gw_tags"></a> [nat\_gw\_tags](#input\_nat\_gw\_tags) | Map containing key value tag pairs | `map(string)` | `{}` | no |
| <a name="input_netbios_name_servers"></a> [netbios\_name\_servers](#input\_netbios\_name\_servers) | n/a | `list` | `[]` | no |
| <a name="input_netbios_node_type"></a> [netbios\_node\_type](#input\_netbios\_node\_type) | n/a | `string` | `""` | no |
| <a name="input_network_acl_rules"></a> [network\_acl\_rules](#input\_network\_acl\_rules) | n/a | <pre>list(object({<br>    #network_acl_id = string<br>    rule_number = number<br>    egress      = bool<br>    protocol    = string<br>    rule_action = string<br>    cidr_block  = string<br>    from_port   = number<br>    to_port     = number<br>  }))</pre> | `null` | no |
| <a name="input_network_acl_tag_name"></a> [network\_acl\_tag\_name](#input\_network\_acl\_tag\_name) | n/a | `string` | `"tf-vpc-network"` | no |
| <a name="input_ntp_servers"></a> [ntp\_servers](#input\_ntp\_servers) | n/a | `list` | `[]` | no |
| <a name="input_private_subnet_acl_rules"></a> [private\_subnet\_acl\_rules](#input\_private\_subnet\_acl\_rules) | n/a | <pre>list(object({<br>    #network_acl_id = string<br>    rule_number = number<br>    egress      = bool<br>    protocol    = string<br>    rule_action = string<br>    cidr_block  = string<br>    from_port   = number<br>    to_port     = number<br>  }))</pre> | `null` | no |
| <a name="input_private_subnet_tag_name"></a> [private\_subnet\_tag\_name](#input\_private\_subnet\_tag\_name) | n/a | `string` | `"tf-vpc-network-private"` | no |
| <a name="input_private_subnets_a"></a> [private\_subnets\_a](#input\_private\_subnets\_a) | List of CIDR blocks for private subnets in AZ A | `list(string)` | `[]` | no |
| <a name="input_private_subnets_b"></a> [private\_subnets\_b](#input\_private\_subnets\_b) | List of CIDR blocks for private subnets in AZ B | `list(string)` | `[]` | no |
| <a name="input_private_subnets_c"></a> [private\_subnets\_c](#input\_private\_subnets\_c) | List of CIDR blocks for private subnets in AZ C | `list(string)` | `[]` | no |
| <a name="input_public_subnet_acl_rules"></a> [public\_subnet\_acl\_rules](#input\_public\_subnet\_acl\_rules) | n/a | <pre>list(object({<br>    #network_acl_id = string<br>    rule_number = number<br>    egress      = bool<br>    protocol    = string<br>    rule_action = string<br>    cidr_block  = string<br>    from_port   = number<br>    to_port     = number<br>  }))</pre> | `null` | no |
| <a name="input_public_subnet_tag_name"></a> [public\_subnet\_tag\_name](#input\_public\_subnet\_tag\_name) | n/a | `string` | `"tf-vpc-network-public"` | no |
| <a name="input_public_subnets_a"></a> [public\_subnets\_a](#input\_public\_subnets\_a) | List of CIDR blocks for public subnets in AZ A | `list(string)` | `[]` | no |
| <a name="input_public_subnets_b"></a> [public\_subnets\_b](#input\_public\_subnets\_b) | List of CIDR blocks for public subnets in AZ B | `list(string)` | `[]` | no |
| <a name="input_public_subnets_c"></a> [public\_subnets\_c](#input\_public\_subnets\_c) | List of CIDR blocks for public subnets in AZ C | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to use for this module. | `string` | `"eu-central-1"` | no |
| <a name="input_rt_private_tags"></a> [rt\_private\_tags](#input\_rt\_private\_tags) | Map containing key value tag pairs | `map(string)` | `{}` | no |
| <a name="input_rt_public_tags"></a> [rt\_public\_tags](#input\_rt\_public\_tags) | Map containing key value tag pairs | `map(string)` | `{}` | no |
| <a name="input_share_arn"></a> [share\_arn](#input\_share\_arn) | The resource access manager share ARN which contains the transit gateway resource | `string` | `""` | no |
| <a name="input_sn_private_a_name"></a> [sn\_private\_a\_name](#input\_sn\_private\_a\_name) | The name of the 1st Public Subnet which will be available in AZ-a. | `string` | `"Private A"` | no |
| <a name="input_sn_private_a_tags"></a> [sn\_private\_a\_tags](#input\_sn\_private\_a\_tags) | List of maps containing key value tag pairs | `list(map(string))` | `[]` | no |
| <a name="input_sn_private_b_name"></a> [sn\_private\_b\_name](#input\_sn\_private\_b\_name) | The name of the 2nd Private Subnet which will be available in AZ-b. | `string` | `"Private B"` | no |
| <a name="input_sn_private_b_tags"></a> [sn\_private\_b\_tags](#input\_sn\_private\_b\_tags) | List of maps containing key value tag pairs | `list(map(string))` | `[]` | no |
| <a name="input_sn_private_c_name"></a> [sn\_private\_c\_name](#input\_sn\_private\_c\_name) | The name of the 3rd Private Subnet which will be available in AZ-c. | `string` | `"Private C"` | no |
| <a name="input_sn_private_c_tags"></a> [sn\_private\_c\_tags](#input\_sn\_private\_c\_tags) | List of maps containing key value tag pairs | `list(map(string))` | `[]` | no |
| <a name="input_sn_public_a_name"></a> [sn\_public\_a\_name](#input\_sn\_public\_a\_name) | The name of the 1st Public Subnet which will be available in AZ-a. | `string` | `"Public A"` | no |
| <a name="input_sn_public_a_tags"></a> [sn\_public\_a\_tags](#input\_sn\_public\_a\_tags) | List of maps containing key value tag pairs | `list(map(string))` | `[]` | no |
| <a name="input_sn_public_b_name"></a> [sn\_public\_b\_name](#input\_sn\_public\_b\_name) | The name of the 2nd Public Subnet which will be available in AZ-b. | `string` | `"Public B"` | no |
| <a name="input_sn_public_b_tags"></a> [sn\_public\_b\_tags](#input\_sn\_public\_b\_tags) | List of maps containing key value tag pairs | `list(map(string))` | `[]` | no |
| <a name="input_sn_public_c_name"></a> [sn\_public\_c\_name](#input\_sn\_public\_c\_name) | The name of the 3rd Public Subnet which will be available in AZ-c. | `string` | `"Public C"` | no |
| <a name="input_sn_public_c_tags"></a> [sn\_public\_c\_tags](#input\_sn\_public\_c\_tags) | List of maps containing key value tag pairs | `list(map(string))` | `[]` | no |
| <a name="input_tgw_attachment_tag_name"></a> [tgw\_attachment\_tag\_name](#input\_tgw\_attachment\_tag\_name) | n/a | `string` | `"my-company-network"` | no |
| <a name="input_tgw_destination_cidr_blocks"></a> [tgw\_destination\_cidr\_blocks](#input\_tgw\_destination\_cidr\_blocks) | The IP ranges where traffic should be forwarded to the transit gateway | `list(string)` | `[]` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | n/a | `string` | `""` | no |
| <a name="input_vpc_dhcp_options_tag_name"></a> [vpc\_dhcp\_options\_tag\_name](#input\_vpc\_dhcp\_options\_tag\_name) | n/a | `string` | `"tf-dopt"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. Other names will result from this. | `string` | `"my-vpc"` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | Network within which the Subnets will be created. | `string` | `"10.0.0.0/24"` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags for the VPC | `map(string)` | `{}` | no |
| <a name="input_vpcep_dynamodb_name"></a> [vpcep\_dynamodb\_name](#input\_vpcep\_dynamodb\_name) | The name of the DynamoDB endpoint. | `string` | `"DynamoDB access"` | no |
| <a name="input_vpcep_dynamodb_tags"></a> [vpcep\_dynamodb\_tags](#input\_vpcep\_dynamodb\_tags) | Map containing key value tag pairs | `map(string)` | `{}` | no |
| <a name="input_vpcep_s3_name"></a> [vpcep\_s3\_name](#input\_vpcep\_s3\_name) | The name of the S3 endpoint. | `string` | `"S3 access"` | no |
| <a name="input_vpcep_s3_tags"></a> [vpcep\_s3\_tags](#input\_vpcep\_s3\_tags) | Map containing key value tag pairs | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The ID of the internet gateway. |
| <a name="output_nat_ip"></a> [nat\_ip](#output\_nat\_ip) | The IP of the NAT Gateway. |
| <a name="output_rt_private_id"></a> [rt\_private\_id](#output\_rt\_private\_id) | The ID of the private route table. |
| <a name="output_rt_public_id"></a> [rt\_public\_id](#output\_rt\_public\_id) | The ID of the public route table. |
| <a name="output_sn_private_a_ids"></a> [sn\_private\_a\_ids](#output\_sn\_private\_a\_ids) | The ID of the 1st Private Subnet. |
| <a name="output_sn_private_b_ids"></a> [sn\_private\_b\_ids](#output\_sn\_private\_b\_ids) | The ID of the 2nd Private Subnet. |
| <a name="output_sn_private_c_ids"></a> [sn\_private\_c\_ids](#output\_sn\_private\_c\_ids) | The ID of the 3rd Private Subnet. |
| <a name="output_sn_public_a_ids"></a> [sn\_public\_a\_ids](#output\_sn\_public\_a\_ids) | The ID of the 1st Public Subnet. |
| <a name="output_sn_public_b_ids"></a> [sn\_public\_b\_ids](#output\_sn\_public\_b\_ids) | The ID of the 2nd Public Subnet. |
| <a name="output_sn_public_c_ids"></a> [sn\_public\_c\_ids](#output\_sn\_public\_c\_ids) | The ID of the 3rd Public Subnet. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
