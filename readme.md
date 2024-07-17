# Crear WebAPP con Docker

## Creamos la Web APP

1. Creamos la aplicacion con el siguiente comando

        dotnet new mvc -o MyAspNetCoreApp

2. No ubicamos en el directorio del proyecto

        cd MyAspNetCoreApp

3. Compilar aplicación MyAspNetCoreApp

        dotnet build
4. Ejecutando aplicación WebAPP

        dotnet run

## Creamos el archivo dockerfile

Para este demo el archivo debe estar a nivel del archivo csproj

1. Para crear Imagen Base para Producción

    ```docker
    FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
    WORKDIR /app
    EXPOSE 80
    ```

2. Crea Imagen Base para Construcción

    ```docker
    FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
    WORKDIR /src
    COPY *.csproj .
    RUN dotnet restore
    ```

3. Construcción de la Aplicación

    ```docker
    COPY . .
    WORKDIR "/src/."
    RUN dotnet build  -c Release -o /app/build
   ```

4. Publicación de la Aplicación

    ```docker
    FROM build AS publish
    RUN dotnet publish -c Release -o /app/publish
    ```

5. Construcción de la Imagen Final

    ```docker
    FROM base AS final
    WORKDIR /app
    COPY --from=publish /app/publish .
    ENTRYPOINT ["dotnet", "MyAspNetCoreApp.dll"]
    ```

El archivo final queda como el siguiente:

```docker
# MyAspNetCoreApp
#Imagen Base para Producción
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

#Imagen Base para Construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY *.csproj .
RUN dotnet restore 

#Construcción de la Aplicación
COPY . .
WORKDIR "/src/."
RUN dotnet build  -c Release -o /app/build

#Publicación de la Aplicación
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

#Construcción de la Imagen Final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyAspNetCoreApp.dll"]

```

## Construir y ejecutar la imagen Docker

1. Nos ubicamos a nivel del archivo Dockerfile

    ```powershell
    cd MyAspNetCoreApp
    ```

2. Construir la Imagen:

    ```powershell
    docker build -t myaspnetcoreapp .
    ```

3. Ejecutar el Contenedor:

    ```powershell
    docker run -it -p 5050:8080 --name myaspnetcoreapp_container myaspnetcoreapp
    ```

## Verificar la Aplicación

1. Abrir en el Navegador y Navega a <http://localhost:5050> para ver si tu aplicación se está ejecutando

2. Revisar Logs. Si hay problemas, revisa los logs del contenedor

    ```
    docker logs myaspnetcoreapp_container
    ```
