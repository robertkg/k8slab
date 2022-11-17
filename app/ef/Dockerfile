FROM mcr.microsoft.com/mssql-tools
COPY migrations.sql /migrations.sql

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /app
# COPY . ./
# RUN dotnet restore
# RUN dotnet publish -c Release -o out
# RUN dotnet tool install --global dotnet-ef
# ENV PATH="$PATH:/root/.dotnet/tools"
# # COPY migrations.sql /migrations.sql