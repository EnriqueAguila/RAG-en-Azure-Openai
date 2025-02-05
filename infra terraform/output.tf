output "azure_openai_endpoint" {
  value = azurerm_ai_services.ai-services.endpoint
}

output "azure_openai_key" {
  value = azurerm_ai_services.ai-services.primary_access_key
  sensitive = true
}

output "azure_openai_chat_completions_deployment_name" {
  value = azurerm_cognitive_deployment.gpt-4o.name
}

output "azure_openai_embedding_model" {
  value = azurerm_cognitive_deployment.text-embedding-3-large.name
}

output "azure_search_service_endpoint" {
  value = "https://${azurerm_search_service.search-service.name}.search.windows.net"
}

output "azure_search_service_admin_key" {
  value = azurerm_search_service.search-service.primary_key
  sensitive = true
}