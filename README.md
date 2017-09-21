# Description

This module is intended to be used for configuring an AWS network.

In detail, a VPC with two public and two private subnets will be created.
Additionally, an Internet Gateway with an Elastic IP will be created and routing tables will be configured.

In the end you will have a working VPC in which you are able to create private and public (internet faced) resources. 

# Usage
Create a new file called my-project.tf and copy the following content in it:

```hcl
module "region" {
  source   = "zoitech/network/aws"
  vpc_name = "my-aws-account"
}
```

# Authors
This module is maintained by [Zoi](https://github.com/zoitech).

# License
Licensed under the MIT License. Have a look at the file `LICENSE` for more information.
