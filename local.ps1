# wrapper script to run outside of k8s
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=MyPass@word' -e 'MSSQL_PID=Express' -p 1433:1433 -d --name k8slab-mssql mcr.microsoft.com/mssql/server:2019-CU18-ubuntu-20.04
dotnet ef database update --project app
dotnet run --project app