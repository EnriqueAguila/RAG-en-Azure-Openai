resource "azapi_resource" "ai-services-connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview"
  name      = "ai-service-connection"
  parent_id = azapi_resource.hub.id

  body = {
    properties = {
      category      = "AIServices",
      target        = azurerm_ai_services.ai-services.endpoint,
      authType      = "AAD",
      isSharedToAll = true,

      metadata = {
        ApiType    = "Azure",
        ResourceId = azurerm_ai_services.ai-services.id
      }
    }
  }

  response_export_values = ["*"]
}

resource "azapi_resource" "search-service-connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview"
  name      = "search-service-connection"
  parent_id = azapi_resource.hub.id

  body = {
    properties = {
      category      = "CognitiveSearch"
      target        = "${azurerm_search_service.search-service.name}.search.windows.net"
      authType      = "AAD"
      isSharedToAll = true

      metadata = {
        ApiType    = "Azure"
        ResourceId = azurerm_search_service.search-service.id
      }
    }
  }
}