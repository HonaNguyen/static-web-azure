terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "static-web" {
    name = "static-web"
    location = "East US"
}

resource "azurerm_storage_account" "honastatic" {
    name = "honastatic"
    resource_group_name = azurerm_resource_group.static-web.name
    location = azurerm_resource_group.static-web.location
    account_replication_type = "LRS"
    account_tier = "Standard"

    access_tier = "Cool"

    static_website {
      index_document = "index.html"
      error_404_document = "404.html"
    }
}

resource "azurerm_storage_container" "web" {
    name = "web"
    storage_account_name = azurerm_storage_account.honastatic.name
    container_access_type = "private"

}

resource "azurerm_storage_blob" "index" {
    name = "index.html"
    storage_account_name = azurerm_storage_account.honastatic.name
    type = "Block"
    # storage_container_name = azurerm_storage_container.web.name
    storage_container_name = "$web"
    source = "src/index.html"
}

resource "azurerm_storage_blob" "error" {
    name = "404.html"
    storage_account_name = azurerm_storage_account.honastatic.name
    type = "Block"
    # storage_container_name = azurerm_storage_container.web.name
    storage_container_name = "$web"
    source = "src/404.html"
}



