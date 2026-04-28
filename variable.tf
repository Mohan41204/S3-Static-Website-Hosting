variable "s3" {
  description = "s3 bucket name"
  type = string
  default = "staticsite280426"
}

variable "acl" {
  description = "acl"
  type = bool
  default = false
}

variable "file" {
  description = "uplading file"
  type = string
  default = "index.html"
}

variable "path" {
  description = "path"
  type = string
  default = "./WebSite/index.html"
}