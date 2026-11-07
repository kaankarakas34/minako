# temuko-posix

A modern, cross-platform POSIX (Linux/macOS) C++ port of the Knight Online Game Server (originally based on NecACS/TEMUKO). This repository modernizes the classic backend by completely removing Windows-specific dependencies (such as MS SQL Server, MFC, and BugTrap) and replacing them with a robust, cloud-ready stack.

## Key Features
- **Cross-Platform:** Compiles and runs natively on Linux and macOS using CMake.
- **PostgreSQL Powered:** The entire database layer has been ported from Microsoft SQL Server to PostgreSQL, including a full translation of 214 complex T-SQL stored procedures into native PL/pgSQL.
- **Docker Ready:** Designed with containerization in mind. It is easy to package into a Docker container for modern deployment workflows (Server-side Dockerization is currently in the roadmap).
- **Clean Codebase:** Removed legacy Windows `.dll`s, Visual Studio projects, and proprietary ODBC bindings.

## Prerequisites
To compile and run `temuko-posix`, you will need:
- **C++ Compiler:** GCC or Clang (with C++17 support or higher)
- **CMake:** Version 3.10+
- **Database:** PostgreSQL (Tested on PostgreSQL 15+)
- **Dependencies:** Boost (ASIO)

## Database Setup
Because this project utilizes PostgreSQL instead of MS SQL Server, you must restore the provided database dumps which contain the schema, initial data, and all the required PL/pgSQL procedures.

1. Ensure you have a running PostgreSQL instance.
2. Create the target databases:
   ```bash
   createdb KO_DATABASE_MAIN
   createdb KO_DATABASE_SERVER_001
   ```
3. Restore the dumps provided in the `Database/` directory:
   ```bash
   zcat Database/KO_DATABASE_MAIN_DUMP.sql.gz | psql -U your_db_user -d KO_DATABASE_MAIN
   zcat Database/KO_DATABASE_SERVER_001_DUMP.sql.gz | psql -U your_db_user -d KO_DATABASE_SERVER_001
   ```

## Building the Project
We use `CMake` for cross-platform builds.

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/temuko-posix.git
cd temuko-posix

# 2. Generate build files
mkdir build && cd build
cmake ..

# 3. Compile the servers
make -j$(nproc)
```

## Running the Servers
Before running the servers, ensure that your `.ini` files in the `Server_Assets/` folder have the correct PostgreSQL credentials. Do not commit your real production passwords to the repository.

To run the servers:
```bash
# Run the LogInServer
cd build/LogInServer
./LogInServer

# Run the GameServer
cd build/GameServer
./GameServer
```
*(Note: If the `.ini` configuration files are missing, the server will automatically generate them with generic default values in the current directory).*

## Roadmap
- [ ] Dockerize the LogInServer and GameServer for 1-click deployments.
- [ ] Native POSIX Client compatibility.

---
**Disclaimer:** This project is for educational and research purposes. All rights to the original Knight Online assets belong to their respective owners.
