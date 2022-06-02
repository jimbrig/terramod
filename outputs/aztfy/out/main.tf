resource "azurerm_container_registry" "res-0" {
  data_endpoint_enabled = true
  location              = "eastus"
  name                  = "rezmodacr"
  resource_group_name   = "rezmod-resources"
  sku                   = "Premium"
  depends_on = [
    azurerm_resource_group.res-323,
  ]
}
resource "azurerm_container_registry_scope_map" "res-3" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
  container_registry_name = "rezmodacr"
  description             = "Can perform all read, write and delete operations on the registry"
  name                    = "_repositories_admin"
  resource_group_name     = "rezmod-resources"
  depends_on = [
    azurerm_container_registry.res-0,
  ]
}
resource "azurerm_container_registry_scope_map" "res-4" {
  actions                 = ["repositories/*/content/read"]
  container_registry_name = "rezmodacr"
  description             = "Can pull any repository of the registry"
  name                    = "_repositories_pull"
  resource_group_name     = "rezmod-resources"
  depends_on = [
    azurerm_container_registry.res-0,
  ]
}
resource "azurerm_container_registry_scope_map" "res-5" {
  actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "rezmodacr"
  description             = "Can push to any repository of the registry"
  name                    = "_repositories_push"
  resource_group_name     = "rezmod-resources"
  depends_on = [
    azurerm_container_registry.res-0,
  ]
}
resource "azurerm_mssql_server_vulnerability_assessment" "res-33" {
  server_security_alert_policy_id = "/subscriptions/9b0ffeeb-be0c-4bb3-a3c0-6860e7dbddf2/resourceGroups/rezmod-resources/providers/Microsoft.Sql/servers/rezmod-sqlserver/securityAlertPolicies/Default"
  # storage_container_path          = ""
  depends_on = [
    # Depending on "/subscriptions/9b0ffeeb-be0c-4bb3-a3c0-6860e7dbddf2/resourceGroups/rezmod-resources/providers/Microsoft.Sql/servers/rezmod-sqlserver", which is not imported by Terraform.
  ]
}
resource "azurerm_app_service_custom_hostname_binding" "res-38" {
  app_service_name    = "rezmod-appservice"
  hostname            = "rezmod-appservice.azurewebsites.net"
  resource_group_name = "rezmod-resources"
  depends_on = [
    # Depending on "/subscriptions/9b0ffeeb-be0c-4bb3-a3c0-6860e7dbddf2/resourceGroups/rezmod-resources/providers/Microsoft.Web/sites/rezmod-appservice", which is not imported by Terraform.
  ]
}
resource "azurerm_app_service_slot_custom_hostname_binding" "res-202" {
  app_service_slot_id = "/subscriptions/9b0ffeeb-be0c-4bb3-a3c0-6860e7dbddf2/resourceGroups/rezmod-resources/providers/Microsoft.Web/sites/rezmod-appservice/slots/staging"
  hostname            = "rezmod-appservice-staging.azurewebsites.net"
  depends_on = [
    # Depending on "/subscriptions/9b0ffeeb-be0c-4bb3-a3c0-6860e7dbddf2/resourceGroups/rezmod-resources/providers/Microsoft.Web/sites/rezmod-appservice/slots/staging", which is not imported by Terraform.
    # Depending on "/subscriptions/9b0ffeeb-be0c-4bb3-a3c0-6860e7dbddf2/resourceGroups/rezmod-resources/providers/Microsoft.Web/sites/rezmod-appservice", which is not imported by Terraform.
  ]
}
resource "azurerm_resource_group" "res-323" {
  location = "eastus"
  name     = "rezmod-resources"
}