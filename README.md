# RAG-en-Azure-Openai
![rag azure](https://github.com/user-attachments/assets/010229d3-6f85-489a-bcb0-93fa6e1d62d6)

Despliegue de RAG utilizando los servicios de Azure Openai

# Introduccion  RAG en Azure OpenAI

## Introduccion

Este repositorio contiene el código y las instrucciones para crear un modelo RAG (Retrieval Augmented Generation) utilizando Azure OpenAI.

# Presentación de RAG (Retriever-Augmented Generation) en Azure OpenAI

## Introducción
**RAG (Retriever-Augmented Generation)** es un enfoque que combina la búsqueda de información relevante con la generación de texto, mejorando la capacidad de los modelos de lenguaje para generar respuestas más informadas y precisas. En el contexto de **Azure OpenAI**, RAG permite integrar bases de datos externas, documentos y otros recursos de información en tiempo real, mejorando la interacción con el modelo y la calidad de las respuestas.

## Objetivos
- Explicar cómo funciona RAG en Azure OpenAI.
- Demostrar cómo implementar una solución de RAG utilizando los servicios de Azure.
- Discutir los beneficios y aplicaciones del enfoque RAG.

## ¿Qué es RAG?
RAG es una técnica que combina dos componentes clave:
1. **Retriever**: Un componente de búsqueda que recupera información relevante de una base de datos o un conjunto de documentos.
2. **Generator**: Un modelo de lenguaje, como GPT, que usa la información recuperada para generar respuestas más precisas y contextuales.

### Flujo de trabajo de RAG
1. **Consulta inicial**: El usuario envía una consulta al sistema.
2. **Recuperación de información**: El sistema usa un modelo de búsqueda para recuperar los fragmentos de información más relevantes.
3. **Generación de respuesta**: El modelo generador toma esa información y produce una respuesta más coherente y precisa.

## Azure OpenAI y RAG

### 1. **Uso de Azure OpenAI**
Azure OpenAI es una plataforma que facilita el acceso a modelos de OpenAI como GPT-3, GPT-4, Codex, y DALL·E, a través de una API escalable y segura. En el contexto de RAG, Azure OpenAI puede servir como el componente generador que usa los datos recuperados para producir respuestas.

### 2. **Integración con Servicios de Búsqueda**
Azure Cognitive Search es uno de los servicios de Azure que se puede integrar para recuperar datos de fuentes externas, como documentos, bases de datos y sitios web. La combinación de este servicio con Azure OpenAI permite implementar un sistema de RAG eficiente.

### 3. **Ventajas de usar Azure**
- **Escalabilidad**: La plataforma Azure está diseñada para manejar grandes volúmenes de datos y consultas.
- **Seguridad**: Azure proporciona herramientas robustas de seguridad y cumplimiento normativo.
- **Fácil integración**: La integración de servicios de búsqueda y generación es sencilla utilizando Azure SDKs y APIs.

## Implementación de un modelo RAG en Azure OpenAI


```bash
az search service create --name my-search-service --resource-group my-resource-group --sku Standard
az search index create --name my-index --service-name my-search-service --fields "title, content"


## Crear recurso de búsqueda de Azure AI

```sh
$rgName = "rg-openai-course2"
$aiSearchName = "ai-search-swc-demo2"
$aiServiceName = "ai-services-swc-demo2"
$location = "swedencentral"
```

### 1. Crear un grupo de recursos

```sh
az group create -n $rgName -l $location
```

### 2. Crear un servicio de búsqueda

```sh
az search service create -n $aiSearchName -g $rgName --sku free
```

### 3. Obtener la clave de administrador

```sh
az search admin-key show --service-name $aiSearchName -g $rgName
# {
#   "primaryKey": "4wIdp9wU2xwTM5ltGro4wNF1VPXwPcrrHMuoy47CYeAzSxxxxxxxx",
#   "secondaryKey": "oa1LM4JA47W4lby8wa8cfOvBKif8I4CidFMTHG71yPAzxxxxxxx"
# }
```

## Crear un recurso de servicios de Azure AI

```sh
az cognitiveservices account create -n $aiServiceName -g $rgName --kind AIServices --sku S0 --location $location
```

### Obtenga la URL del punto final, las claves y el ID del recurso

```sh
az cognitiveservices account show -n $aiServiceName -g $rgName --query properties.endpoint
# "https://swedencentral.api.cognitive.microsoft.com/"

az cognitiveservices account keys list -n $aiServiceName -g $rgName
# {
#   "key1": "78f5592e1f70494dabd1a4040a61a96a",
#   "key2": "4f23266a2eb0475c8a0112044e03c4d1"
# }

az cognitiveservices account show -n $aiServiceName -g $rgName --query id
# "/subscriptions/38977b70-47bf-4da5-a492-xxxxxxxxx/resourceGroups/rg-openai-course2/providers/Microsoft.CognitiveServices/accounts/ai-services-swc-demo"
```

## Creando implementación para el modelo ChatGPT 4o

```sh
az cognitiveservices account deployment create -n $aiServiceName -g $rgName `
    --deployment-name gpt-4o `
    --model-name gpt-4o `
    --model-version "2024-05-13" `
    --model-format OpenAI `
    --sku-capacity "148" `
    --sku-name "Standard"
```

## Crear el embedding model

Replace ` with \ if you are using Linux or MacOS.

```sh
az cognitiveservices account deployment create -n $aiServiceName -g $rgName `
    --deployment-name text-embedding-3-large `
    --model-name text-embedding-3-large `
    --model-version "1" `
    --model-format OpenAI `
    --sku-capacity "227" `
    --sku-name "Standard"
```
## Cree el hub y un proyecto en Azure AI Studio

### Crear el Hub

```sh
az extension add -n ml
az extension update -n ml

az ml workspace create --kind hub -g $rgName -n hub-demo
```

### Crear el Proyecto

Creating a new project using Azure CLI like the following is not yet supported. You can create a project using the Azure AI studio.

```sh
$hubId=$(az ml workspace show -g $rgName -n hub-demo --query id -o tsv)

az ml workspace create --kind project --hub-id $hubId -g $rgName -n project-demo
```

### Creae el connection.yml file

Create a file named `connection.yml` with the following content to link `AI Services` to the `Hub`. Make sure to replace the values with your own.

```yml
name: ai-service-connection
type: azure_ai_services
endpoint: https://swedencentral.api.cognitive.microsoft.com/
api_key: 246cbcb9e3194fd5a09935a8418fe99a
ai_services_resource_id: /subscriptions/38977b70-47bf-4da5-a492-88712fce8725/resourceGroups/rg-openai-course2/providers/Microsoft.CognitiveServices/accounts/ai-services-swc-demo2
```

Deploy the connection using the following command.

```sh
az ml connection create --file connection.yml -g $rgName --workspace-name hub-demo
```

### Confirmar los recursos
Confirme que tiene los siguientes recursos en su Azure Portal.
![Captura de pantalla (48)](https://github.com/user-attachments/assets/efd8150f-e4fd-4ed2-8f1a-8a677d9f3dfd)


![Captura de pantalla (51)](https://github.com/user-attachments/assets/5c345a99-f117-48e5-92ee-e682671e39a4)
