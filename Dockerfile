# NuGet restore
FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY *.sln .
COPY Commander/*.csproj Commander/
RUN dotnet restore
COPY . .

# publish
FROM build AS publish
WORKDIR /src/Commander
RUN dotnet publish -c Release -o /src/publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
# ENTRYPOINT ["dotnet", "Commander.dll"]
# heroku uses the following
CMD ASPNETCORE_URLS=http://*:$PORT dotnet Commander.dll