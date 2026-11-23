terraform {
  cloud {
    organization = "sakuro"

    workspaces {
      name = "dotfiles"
    }
  }
}
