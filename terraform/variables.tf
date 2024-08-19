# App variables
variable "app-name" {
  type        = string
  default     = "template"
  description = "name of the app you're deployingÏ"
}

# Common variables
variable "region" {
  type        = string
  default     = "ap-southeast-2"
  description = "deployment region"
}

variable "tags" {
  type = map(any)
  default = {
    NAME = "template"
    STAGE = "dev"
  }
  description = "Default tags for the deployment"
}

# react build commands
variable "webapp-dir" {
  type        = string
  description = "Relative path to webapp"
  default     = "../frontend/"
}

variable "install-command" {
  type        = string
  description = "Install command to install requirements"
  default     = "npm install"
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
