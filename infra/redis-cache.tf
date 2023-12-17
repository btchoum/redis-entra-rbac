resource "azurerm_redis_cache" "example" {
  name                = "btchoum-demo-cache"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  redis_version       = "6"

  redis_configuration {
  }
}