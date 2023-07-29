# Подключение к БД

## MSSQL

### Develop версия

1. [Free specialized edition - Developer](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) установщик
2. [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/ru-ru/sql/ssms/download-sql-server-management-studio-ssms)

### docker-compose.yaml

[Official images for Microsoft SQL Server](https://hub.docker.com/_/microsoft-mssql-server)

```docker
services:
  db_mssql:
    container_name: db_mssql_SOME
    image: mcr.microsoft.com/mssql/server:2022-CU6-ubuntu-20.04
    ports:
      - "7755:1433"
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=LtlVjhjp1983
      - MSSQL_PID=Developer
```

### Строки подключения

#### По логину/паролю:

```csharp
@"Server=localhost,6445;
  Database=my_db;
  User ID=sa;
  Password=LtlVjhjp1983;
  Encrypt=false
 "
```

#### Windows credentials

```csharp
@"Server=localhost\\SQLEXPRESS;
  Database=TestDb;
  Trusted_Connection=True;
  Encrypt=False;
 "
```

```csharp
@"Server=localhost;
  Database=my_db;
  Trusted_Connection=true;
  Encrypt=false
 "
```

## PostgreSQL

### docker-compose.yaml

[The PostgreSQL object-relational database system provides reliability and data integrity](https://hub.docker.com/_/postgres)  
[Tags](https://hub.docker.com/_/postgres/tags)

```docker
services:
  db_postgres:
    container_name: db_postgres_SOME
    image: postgres:15.2-alpine
    ports:
      - "7788:5432"
    environment:
      - POSTGRES_DB=db
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=12345
```

### Строки подключения

```csharp
@"host=127.0.0.1;
  port=6748;
  database=db;
  username=root;
  password=12345
 "
```

