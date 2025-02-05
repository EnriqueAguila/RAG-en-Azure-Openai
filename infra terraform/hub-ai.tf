resource "azapi_resource" "hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-07-01-preview"
  name      = "ai-hub"
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id

  identity {
    type = "SystemAssigned"
  }

  body = {
    kind = "Hub"
    properties = {
      description         = "This is my Azure AI hub"
      friendlyName        = "My Hub"
      publicNetworkAccess = "Enabled"
      storageAccount      = azurerm_storage_account.storage.id
      keyVault            = azurerm_key_vault.keyvault.id
      applicationInsights = azurerm_application_insights.app-insights.id
      containerRegistry   = azurerm_container_registry.acr.id
      # managedNetwork = {
      #   isolationMode = "Disabled"
      # }
    }
  }

  response_export_values = ["id", "name", "location", "identity", "properties"]
}
