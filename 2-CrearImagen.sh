echo "Construir la Imagen Docker"
cd MyAspNetCoreApp

docker build -t myaspnetcoreapp .
#docker run -it -p 5050:80 --name myaspnetcoreapp_container myaspnetcoreapp
docker run -it -p 5050:8080 --name myaspnetcoreapp_container myaspnetcoreapp


