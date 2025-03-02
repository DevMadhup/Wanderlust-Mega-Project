variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"  # Update as needed
}

variable "ec2_ssh_key_name" {
  description = "Name of the SSH key pair for EC2 instances"
  type        = string
  default     = "ec2-key-pair"  
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-00bb6a80f01f03502"  # Update as needed
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "wanderlust-eks-cluster" 
}

variable "eks_node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "wanderlust-node-group"
}

variable "eks_node_instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
  default     = "t2.medium"
}

variable "eks_cluster_policy_arn" {
  description = "ARN of the EKS cluster policy"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

variable "eks_node_policy_arn" {
  description = "ARN of the EKS node policy"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


variable "eks_cni_policy_arn" {
  description = "ARN of the EKS CNI policy"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

variable "eks_ecr_read_only_policy_arn" {
  description = "ARN of the ECR read only policy"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
