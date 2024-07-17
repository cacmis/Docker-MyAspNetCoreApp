echo "Creamos nuestro grupo de recurso"
az group create --name myResourceGroup-cacmis --location eastus

echo "Creamos nuestro registro de contenedores"
az acr create --resource-group myResourceGroup-cacmis --name myContainerRegistry-cacmis --sku Basic

echo "Construimos la imagen"
az acr build --image myaspnetcoreapp:v1 \
  --registry myResourceGroup-cacmis \
  --file MyAspNetCoreApp/Dockerfile . 
