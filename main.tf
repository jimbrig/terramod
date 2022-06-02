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

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.prefix-resources
  location = var.location
}

resource "azurerm_service_plan" "main" {
  name                = var.prefix-service-plan
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "main" {
  name                = var.prefix-appservice
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id = azurerm_service_plan.main.id

  site_config {
    app_command_line = ""
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    # "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
  }

  connection_string {
    name = "Database"
    type = "SQLServer"
    value = "Server=tcp:azurerm_mssql_server.terraform-sqlserver.fully_qualified_domain_name Database=azurerm_mssql_database.terraform-sqldatabase.name;User ID=azurerm_mssql_server.terraform-sqlserver.administrator_login;Password=azurerm_mssql_server.terraform-sqlserver.administrator_login_password;Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_mssql_server" "terraform-sqlserver" {
  name                         = "${var.prefix}-sqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "rezmod_admin"
  administrator_login_password = "Pwcwelcome001"
}

resource "azurerm_mssql_database" "terraform-sqldatabase" {
  name                = var.prefix-db
  server_id           = azurerm_mssql_server.terraform-sqlserver.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  license_type        = "LicenseIncluded"
  max_size_gb         = 4
  read_scale          = true
  sku_name            = "S0"
  zone_redundant      = true

  tags = {
    environment = "development"
  }
}

resource "azurerm_key_vault" "main" {
  name = var.prefix-keyvault
  location = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}


resource "azurerm_container_registry" "main" {
  name                  = var.prefix-acr
  admin_enabled         = true
  sku                   = "Premium"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  data_endpoint_enabled = true
  tags = {
    ghs-apptioid = ""
    ghs-los      = ""
    ghs-owner    = ""
    ghs-solution = ""
    ghs-tariff   = ""
  }
  depends_on = [
    azurerm_resource_group.main
  ]
}
