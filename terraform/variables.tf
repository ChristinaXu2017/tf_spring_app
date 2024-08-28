# App variables
variable "app-name" {
  type        = string
  default     = "vaccine-webapp"
  description = "name of the app you're deployingÏ"
}

# Common variables
variable "region" {
  type        = string
  default     = "ap-southeast-2"
  description = "deployment region"
}

variable "install-command" {
  type        = string
  description = "Install command to install requirements"
  default     = "npm install --legacy-peer-deps"
}

variable "build-command" {
  type        = string
  description = "Build command to build the webapp"
  default     = "npm run build"
}

variable "build-destination" {
  type        = string
  description = "Path to built source"
  default     = "../frontend/build/"
}
# Angulart build commands
variable "webapp-dir" {
  type        = string
  description = "Relative path to webapp"
  default     = "../frontend/"
}


variable "tags" {
  type = map(any)
  default = {
    NAME = "template"
    STAGE = "dev"
  }
  description = "Default tags for the deployment"
}

variable "vaccine-guest-username" {
  type        = string
  description = "Value for guest username (must be an email)"
  default     = "guest@example.com"
}

variable "vaccine-guest-password" {
  type        = string
  description = "Value for guest password"
  default     = "guest1234"
}
variable "vaccine-admin-username" {
  type        = string
  description = "Value for admin username  (must be an email)"
  default     = "admin@example.com"
}

variable "vaccine-admin-password" {
  type        = string
  description = "Value for admin password"
  default     = "admin1234"
}


# retrieve data of default subnet ids where vpc id not specified
variable "vpc_id" {
  default     = ""
  description = "The ID of the VPC, if empty default VPC ID is used"
}
resource "aws_default_vpc" "default" {}
locals { vpc_id = var.vpc_id == "" ? aws_default_vpc.default.id : var.vpc_id }

# retrieve data of default subnet ids where subnet id not specified
variable "subnet_id" {
  default     = ""
  description = "Name of the availability subnet to use, if empty TF will pick up one"
}
data "aws_subnets" "default" {
  filter { 
	 name   = "vpc-id" 
	 values = [local.vpc_id] 
         }
}
locals { subnet_id = var.subnet_id == "" ? data.aws_subnets.default.ids[0] : var.subnet_id }


variable "ssh_ips" {
  type        = list(string)
  default     = ["159.196.0.0/16", "140.79.0.0/16", "140.253.0.0/16"]
  description = "Set my IPs, if empty all IPs are allowed (0.0.0.0/0)"
}

# curl -4 ifconfig.me to get my ip of ipv4 from MAC
variable "http_ips" {
  type        = list(string)
  default     = ["159.196.0.0/16", "140.79.0.0/16", "140.253.0.0/16"]
  description = "Set my IPs, if empty all IPs are allowed (0.0.0.0/0)"
}

variable jupyter_pw {
  default = "sha1:73f6a934fce7:a1e171a70c1b0abdb4a3d406c480ae4dcfdcb253"
  description = "a hashed string to access jupyter notebook. eg. here is the hashed pw of 'tb@user'"
}
