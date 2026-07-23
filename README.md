# San Andreas Prison RP

Servidor de roleplay carcelario para open.mp / SA-MP.

## Requisitos

- open.mp server (incluido)
- MySQL 5.7+ / MariaDB 10+
- Linux x86 (para el binario `omp-server` incluido)

## Instalacion

1. Crear la base de datos e importar el schema:

```bash
mysql -u root -p < Server/SQL/database_prison.sql
```

2. Configurar credenciales de la base de datos:

```bash
cp Server/mysql.ini.example Server/mysql.ini
# editar Server/mysql.ini con tus credenciales
```

3. Compilar el gamemode:

```bash
cd Server/gamemodes
./compile
```

4. Iniciar el servidor:

```bash
cd Server
./omp-server
```

## Estructura del proyecto

```
Server/
 +-- config.json              configuracion del servidor
 +-- mysql.ini                credenciales MySQL (gitignorado)
 +-- omp-server               binario del servidor open.mp
 +-- components/              componentes/plugins del servidor
 +-- gamemodes/
 |    +-- compile             script de compilacion
 |    +-- main.pwn            punto de entrada
 |    +-- constants/          constantes y defines
 |    +-- variables/          variables globales
 |    +-- utils/              funciones auxiliares
 |    +-- systems/
 |         +-- auth/          sistema de login/registro
 |         +-- prison/        logica principal de la prision
 |         +-- commands.pwn   comandos de los jugadores
 +-- qawno/                   compilador e includes
 +-- SQL/
      +-- database_prison.sql schema de la base de datos
```

## Funcionalidades

- Autenticacion con bcrypt + MySQL
- Sistema de condena con cuenta regresiva en tiempo real
- Asignacion de celdas y pabellones
- Trabajos de prision (cocina, lavanderia, taller, biblioteca, limpieza)
- Sistema de facciones (presos, guardias, staff)
- Comandos de jugador (/me, /do, /report, etc.)
- Comandos de administrador (/setpreso)
