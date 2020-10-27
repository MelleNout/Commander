# NuGet restore
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY *.sln .
COPY commander-api/*.csproj commander-api/
RUN dotnet restore
COPY . .

# publish
FROM build AS publish
WORKDIR /src/commander-api
RUN dotnet publish -c Release -o /src/publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
# ENTRYPOINT ["dotnet", "Commander.dll"]
# heroku uses the following
CMD ASPNETCORE_URLS=http://*:$PORT dotnet Commander.dll