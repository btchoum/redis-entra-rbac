resource "azurerm_log_analytics_workspace" "demo" {
  name                = "laws-btchoum-redis-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "demo" {
  name                          = "appi-btchoum-redis-demo"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  workspace_id                  = azurerm_log_analytics_workspace.demo.id
  application_type              = "web"
  local_authentication_disabled = false
}

# resource "azurerm_role_assignment" "webapp_appinsights" {
#   scope                = azurerm_application_insights.demo.id
#   role_definition_name = "Monitoring Metrics Publisher"
#   principal_id         = azurerm_linux_web_app.demo.id
# }
