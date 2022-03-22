resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}



resource "azurerm_storage_account" "my_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true



  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_share" "aci_caddy" {
  name                 = "aci-caddy-data"
  storage_account_name = azurerm_storage_account.my_storage_account.name
}
resource "azurerm_container_group" "dapi" {
  name                = "dapi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = "dapisvc"
  os_type             = "Linux"
  restart_policy = "OnFailure"

  container {
    name   = "dapi"
    image  = "jramirezg/deloitte-api:latest"
    cpu    = "0.5"
    memory = "0.5"

    # ports {
    #   port     = 80
    #   protocol = "TCP"
    # }
  }

  container {
    name   = "caddy"
    image  = "caddy"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 443
      protocol = "TCP"
    }

    ports {
      port     = 80
      protocol = "TCP"
    }
    volume {
      name                 = "aci-caddy-data"
      mount_path           = "/data"
      storage_account_name = azurerm_storage_account.my_storage_account.name
      storage_account_key  = azurerm_storage_account.my_storage_account.primary_access_key
      share_name           = azurerm_storage_share.aci_caddy.name
    }
    commands = ["caddy", "reverse-proxy", "--from", "dapisvc.westeurope.azurecontainer.io", "--to", "localhost:8080"]
  }

  tags = {
    app = "dapi"
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}