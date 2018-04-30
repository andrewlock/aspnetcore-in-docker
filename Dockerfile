# Build image
FROM andrewlock/aspnetcore-cakebuild AS builder

ARG PackageVersion
ENV PackageVersion=$PackageVersion

# Publish web app
Run ./build.sh -Target=PublishWeb

#App image
FROM microsoft/aspnetcore:2.0.3
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT Production
ENTRYPOINT ["dotnet", "AspNetCoreInDocker.Web.dll"]
COPY --from=builder ./sln/dist .