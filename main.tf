module "s3_bucket"{
    source = "./module"
    s3 = var.s3
    acl = var.acl
    file = var.file
    path = var.path
}