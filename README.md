# Provisioning VPC, ECS and ALB using Terraform

![](https://github.com/MarkWahba-git/challenge-ecr-terraform/workflows/Terraform/badge.svg)

This is the example of creating a simple infrastructure using Terraform and AWS cloud provider. It consists of:
- Virtual Private Cloud (VPC) with 3 public subnets in 3 availability zones
- Elastic Container Service (ECS)
- Application Load Balancer (ALB)
- Auto Scaling Group (asg)

## How to create the infrastructure?
This example implies that you have already AWS account and Terraform CLI installed.
1. `git clone https://github.com/MarkWahba-git/challenge-ecr-terraform-.git`
2. [Install terraform](https://www.terraform.io/intro/getting-started/install.html) (alternatively - [run terraform via docker](https://hub.docker.com/r/hashicorp/terraform/) - note they don't mention there to mount the directory with TF templates to the container, don't forget that)
3. Update variables.tf according to your environment
4. terraform init
5. terraform plan
6. terraform apply

Note: it can take about 5 minutes to provision all resources.
## How to delete the infrastructure?
1. Terminate instances
2. Run `terraform destroy`

## Brief Description

Cluster is created using container instances (EC2 launch type, not Fargate!). 

In this example, verified module `vpc` is imported from Terraform Registry, other resources are created in relevant files.

In file `ecs.tf` we create:
  - cluster of container instances _web-cluster_
  - capacity provider, which is basically AWS Autoscaling group for EC2 instances. In this     example managed scaling is enabled, 
  Amazon ECS manages the scale-in and scale-out actions of the Auto Scaling group used when creating the capacity provider. 
  I set target capacity to 85%, which will result in the Amazon EC2 instances in your Auto Scaling group being utilized for 85% and any instances not running any tasks will be scaled in.
  - task definition with family _web-family_, volume and container definition is defined in the file container-def.json
  - service _web-service_, desired count is set to 10, which means there are 10 tasks will be running simultaneously on your cluster. There are two service scheduler strategies available: REPLICA and DAEMON, in this example REPLICA is used. Application load balancer is attached to this service, so the traffic can be distributed between those tasks.
  Note: The _binpack_ task placement strategy is used, which places tasks on available instances that have the least available amount of the cpu (specified with the field parameter). 

In file `asg.tf` we create:
  - launch configuration
  - key pair
  - security groups for EC2 instances
  - auto-scaling group. 

Note: in order to enable ECS managed scaling you need to enable `protect from scale in` from auto-scaling group.

In file `iam.tf` we create roles, which will help us to associate EC2 instances to clusters, and other tasks.

In file `alb.tf` we create Application Load Balancer with target groups, security group and listener. 

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | Name of the application.  | string |  | yes |
| key_name | TThe name for ssh key, used for aws_launch_configuration.| string |  | yes |

it's much better to increase your Varaibles like (region,aws_profile , tags...)

## Outputs

| Name | Description |
|------|-------------|
| alb_dns | Returns the dns of the Cluster  |

