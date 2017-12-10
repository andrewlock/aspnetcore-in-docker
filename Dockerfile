# Build image
FROM microsoft/aspnetcore-build:2.0.3 AS builder

ARG PackageVersion
ENV PackageVersion=$PackageVersion

# Install mono for Cake
ENV MONO_VERSION 5.4.1.6

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb http://download.mono-project.com/repo/debian stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list \
  && apt-get update \
  && apt-get install -y mono-runtime \
  && rm -rf /var/lib/apt/lists/* /tmp/*

RUN apt-get update \
  && apt-get install -y binutils curl mono-devel ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl \
  && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /sln

COPY ./build.sh ./build.cake ./NuGet.config ./aspnetcore-in-docker.sln  ./

# Install Cake, and compile the Cake build script
RUN ./build.sh -Target=Clean

# Copy all the csproj files and restore to cache the layer for faster builds
# The dotnet_build.sh script does this anyway, so superfluous, but docker can 
# cache the intermediate images so _much_ faster
COPY ./src/AspNetCoreInDocker.Lib/AspNetCoreInDocker.Lib.csproj  ./src/AspNetCoreInDocker.Lib/AspNetCoreInDocker.Lib.csproj
COPY ./src/AspNetCoreInDocker.Web/AspNetCoreInDocker.Web.csproj  ./src/AspNetCoreInDocker.Web/AspNetCoreInDocker.Web.csproj
COPY ./test/AspNetCoreInDocker.Web.Tests/AspNetCoreInDocker.Web.Tests.csproj  ./test/AspNetCoreInDocker.Web.Tests/AspNetCoreInDocker.Web.Tests.csproj
RUN ./build.sh -Target=Restore

COPY ./test ./test
COPY ./src ./src

# Build and Test
RUN ./build.sh -Target=Build && ./build.sh -Target=Test

# Publish web app
Run ./build.sh -Target=PublishWeb

#App image
FROM microsoft/aspnetcore:2.0.3
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT Production
ENTRYPOINT ["dotnet", "AspNetCoreInDocker.Web.dll"]
COPY --from=builder ./sln/dist .