terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "remiscarlet"
    workspaces {
      name = "amatsu"
    }
  }
}
