resource "azapi_resource" "project" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-10-01"
  name      = "ai-project"
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description         = "This is my Azure AI PROJECT"
      friendlyName        = "My Project"
      hubResourceId       = azapi_resource.hub.id
      publicNetworkAccess = "Enabled"
      # ipAllowlist         = []
    }
    kind = "Project"
  }

  response_export_values = ["id", "name", "location", "identity", "properties"]
}