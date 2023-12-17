resource "azurerm_service_plan" "demo" {
  name                = "asp-redis-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
  worker_count        = 3
}

resource "azurerm_linux_web_app" "demo" {
  name                = "btchoum-redis-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.demo.location
  service_plan_id     = azurerm_service_plan.demo.id

  https_only = true

  site_config {
    always_on = true

    application_stack {
      dotnet_version = "8.0"
    }
  }
}
