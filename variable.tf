variable "s3" {
  description = "s3 bucket name"
  default = "staticsite280426"
}

variable "acl" {
  description = "acl"
  default = false
}

variable "file" {
  description = "uplading file"
  default = "index.html"
}

variable "path" {
  description = "path"
  default = "./WebSite/index.html"
}