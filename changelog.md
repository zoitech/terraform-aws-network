## 2.2.4

BUG FIXES:

* Fix terraform dhcp passed variables

## 2.2.3

ENHANCEMENTS:

* Rename domain_name variable to dhcp_domain_name

## 2.2.2

ENHANCEMENTS:

* Add IGW, NatGW and Route table tags to support backward compatibility


## 2.2.1

BUG FIXES:

* Fixed "Error: Incorrect attribute value type" for "subnet_ids" parameters [#36](https://github.com/zoitech/terraform-aws-network/issues/36)

## 2.2.0

BACKWARDS INCOMPATIBILITIES / NOTES:

* Names for subnet ID outputs changed to reflect plural nature (e.g. "sn_private_a_id" is now "sn_private_a_ids" )

BUG FIXES:

* Fixed output for nat_ip

ENHANCEMENTS:

* Output for internet gateway ID

## 1.2.0

ENHANCEMENTS:

* Added VPC and subnet tagging capabilities [#30](https://github.com/zoitech/terraform-aws-network/issues/30)

## 1.1.0

NEW FEATURES:
* Support for dynamic subnet creation. Due to: [#31](https://github.com/zoitech/terraform-aws-network/issues/31)
* Support for multiple subnet creation in the same availability zone. Due to: [#31](https://github.com/zoitech/terraform-aws-network/issues/31)

## 1.0.7

IMPROVEMENTS:
* small fixes to variable defaults

## 1.0.6

IMPROVEMENTS:
* Make "aws_ram_resource_share_accepter" optional ([#27](https://github.com/zoitech/terraform-aws-network/issues/27))

## 1.0.5n

Same as "1.0.5" but with no "aws_ram_resource_share_accepter" incase this step was done manually. Due to [import bug](https://github.com/terraform-providers/terraform-provider-aws/issues/10186)

## 1.0.5

IMPROVEMENTS:
* Support multiple IP address range forwarding to the transit gateway ([#20](https://github.com/zoitech/terraform-aws-network/issues/20))

## 1.0.4

IMPROVEMENTS:
* A network ACL can now be applied to all subnets within a VPC or on a private/public subnet basis ([#18](https://github.com/zoitech/terraform-aws-network/issues/18))

## 1.0.3

NEW FEATURES:
* Added aws_ram_resource_share_accepter for the transit gateway attachment ([#15](https://github.com/zoitech/terraform-aws-network/issues/15))

## 1.0.2

IMPROVEMENTS:
* Removed public subnets from transit gateway vpc attachment ([#13](https://github.com/zoitech/terraform-aws-network/issues/13))

## 1.0.1

NEW FEATURES:
* DHCP Options (Optional) ([#9](https://github.com/zoitech/terraform-aws-network/issues/9))
* Internet Gateway (Optional)
* NAT Gateway (Optional) (Dependent on Internet Gateway)
* Elastic IP for NAT Gateway (Optional)
* Network ACL (Optional) ([#10](https://github.com/zoitech/terraform-aws-network/issues/10))
* Transit Gateway attachment to the VPC (Optional) ([#11](https://github.com/zoitech/terraform-aws-network/issues/11)))

BACKWARDS INCOMPATIBILITIES / NOTES:
* Works with terraform 0.12.x ([#8](https://github.com/zoitech/terraform-aws-network/issues/8))

IMPROVEMENTS:
* Upgraded to terrfaform 0.12 ([#8](https://github.com/zoitech/terraform-aws-network/issues/8))

BUG FIXES:
* Fixed output for nat gateway IP if not created ([#6](https://github.com/zoitech/terraform-aws-network/issues/6))