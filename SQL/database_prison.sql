-- ============================================================
-- San Andreas Prison RP - Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS database_prison
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE database_prison;

-- ============================================================
-- PLAYERS
-- ============================================================
CREATE TABLE IF NOT EXISTS `users` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Nombre` VARCHAR(24) NOT NULL,
    `Password` VARCHAR(128) NOT NULL,
    `Email` VARCHAR(64) DEFAULT NULL,
    `Ip` VARCHAR(16) DEFAULT NULL,
    `Admin` INT NOT NULL DEFAULT 0,
    `Skin` INT NOT NULL DEFAULT 0,
    `Dinero` INT NOT NULL DEFAULT 0,
    `Horas` INT NOT NULL DEFAULT 0,
    `PrimeraVez` DATETIME NOT NULL,
    `UltimaVez` DATETIME DEFAULT NULL,
    `Baneado` INT NOT NULL DEFAULT 0,
    `RazonBan` VARCHAR(128) DEFAULT NULL,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `Nombre` (`Nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- INMATES (prisoner data)
-- ============================================================
CREATE TABLE IF NOT EXISTS `inmates` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `UserId` INT NOT NULL,
    `Condena` INT NOT NULL DEFAULT 0,
    `CondenaOriginal` INT NOT NULL DEFAULT 0,
    `Ingreso` DATETIME NOT NULL,
    `Liberacion` DATETIME DEFAULT NULL,
    `Pabellon` INT NOT NULL DEFAULT 0,
    `Celda` INT NOT NULL DEFAULT 0,
    `Rango` INT NOT NULL DEFAULT 0,
    `Puntos` INT NOT NULL DEFAULT 0,
    `Conducta` INT NOT NULL DEFAULT 100,
    `Trabajo` INT NOT NULL DEFAULT 0,
    `Faccion` INT NOT NULL DEFAULT 0,
    `FaccionRango` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    KEY `UserId` (`UserId`),
    FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- GUARDS / STAFF
-- ============================================================
CREATE TABLE IF NOT EXISTS `staff` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `UserId` INT NOT NULL,
    `Rango` INT NOT NULL DEFAULT 0,
    `Salario` INT NOT NULL DEFAULT 0,
    `Turno` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    KEY `UserId` (`UserId`),
    FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- PUNISHMENTS (infractions record)
-- ============================================================
CREATE TABLE IF NOT EXISTS `punishments` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `UserId` INT NOT NULL,
    `OficialId` INT DEFAULT NULL,
    `Tipo` INT NOT NULL DEFAULT 0,
    `Razon` VARCHAR(255) NOT NULL,
    `Duracion` INT NOT NULL DEFAULT 0,
    `Fecha` DATETIME NOT NULL,
    PRIMARY KEY (`Id`),
    KEY `UserId` (`UserId`),
    FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- VISITS
-- ============================================================
CREATE TABLE IF NOT EXISTS `visits` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `InmateId` INT NOT NULL,
    `Visitante` VARCHAR(24) NOT NULL,
    `Tipo` INT NOT NULL DEFAULT 0,
    `Fecha` DATETIME NOT NULL,
    PRIMARY KEY (`Id`),
    KEY `InmateId` (`InmateId`),
    FOREIGN KEY (`InmateId`) REFERENCES `inmates` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- CONTRABAND (seized contraband)
-- ============================================================
CREATE TABLE IF NOT EXISTS `contraband` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `UserId` INT NOT NULL,
    `Item` VARCHAR(64) NOT NULL,
    `Cantidad` INT NOT NULL DEFAULT 0,
    `Descubierto` DATETIME NOT NULL,
    PRIMARY KEY (`Id`),
    KEY `UserId` (`UserId`),
    FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- PRISON CELLS
-- ============================================================
CREATE TABLE IF NOT EXISTS `cells` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Pabellon` INT NOT NULL DEFAULT 0,
    `Nombre` VARCHAR(16) NOT NULL,
    `Camas` INT NOT NULL DEFAULT 2,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
