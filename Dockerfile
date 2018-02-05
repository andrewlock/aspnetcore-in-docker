# Build image
FROM microsoft/aspnetcore-build:2.0.3 AS builder
WORKDIR /sln

COPY projectfiles.tar .
RUN tar -xvf projectfiles.tar && dotnet restore

COPY ./test ./test
COPY ./src ./src
RUN dotnet build -c Release --no-restore

RUN dotnet test "./test/AspNetCoreInDocker.Web.Tests/AspNetCoreInDocker.Web.Tests.csproj" -c Release --no-build --no-restore

RUN dotnet publish "./src/AspNetCoreInDocker.Web/AspNetCoreInDocker.Web.csproj" -c Release -o "../../dist" --no-restore

#App image
FROM microsoft/aspnetcore:2.0.3
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT Local
ENTRYPOINT ["dotnet", "AspNetCoreInDocker.Web.dll"]
COPY --from=builder /sln/dist .