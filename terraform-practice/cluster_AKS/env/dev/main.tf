module "cluster" {
    source = "../../module/cluster"
    subscription_id = var.subscription_id
    environmet      = var.environmet
}