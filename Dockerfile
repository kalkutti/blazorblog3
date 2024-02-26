FROM mcr.microsoft.com/dotnet/sdk:8.0-nanoserver-1809 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY BlazorBlog3/BlazorBlog3.csproj BlazorBlog3/
COPY BlazorBlog3.Client/BlazorBlog3.Client.csproj BlazorBlog3.Client/
#COPY BlazorBlogLibrary/BlazorBlogLibrary.csproj BlazorBlogLibrary/
RUN dotnet restore BlazorBlog3/BlazorBlog3.csproj
#RUN dotnet restore BlazorBlog.Client/BlazorBlog.Client.csproj

COPY . .
WORKDIR /src/BlazorBlog3
RUN dotnet build BlazorBlog3.csproj -c %BUILD_CONFIGURATION% -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish BlazorBlog3.csproj -c %BUILD_CONFIGURATION% -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-1809 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorBlog.dll"]