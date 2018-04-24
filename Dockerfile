# Build image
FROM microsoft/aspnetcore-build:2.0.6-2.1.101 AS builder
WORKDIR /sln

COPY ./*.sln ./NuGet.config  ./

# Copy the main source project files
COPY src/*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p src/${file%.*}/ && mv $file src/${file%.*}/; done
# Copy the test project files
COPY test/*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p test/${file%.*}/ && mv $file test/${file%.*}/; done 

RUN dotnet restore

COPY ./test ./test
COPY ./src ./src
RUN dotnet build -c Release --no-restore

RUN find /test -name '*.csproj' -print0 | xargs -L1 -0 -P 8 dotnet test  -c Release --no-build --no-restore

RUN dotnet publish "./src/AspNetCoreInDocker.Web/AspNetCoreInDocker.Web.csproj" -c Release -o "../../dist" --no-restore

#App image
FROM microsoft/aspnetcore:2.0.6
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT Local
ENTRYPOINT ["dotnet", "AspNetCoreInDocker.Web.dll"]
COPY --from=builder /sln/dist .