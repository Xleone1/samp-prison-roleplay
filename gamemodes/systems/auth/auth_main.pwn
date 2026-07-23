//
// auth_main.pwn
//

forward OnPasswordHashDone(playerid, hashid);
forward OnLoginAfterRegister(playerid);
forward OnPasswordVerify(playerid, bool:success);
forward OnCheckAccountResult(playerid);

public OnPasswordHashDone(playerid, hashid)
{
    new hash[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hash);
    strcat(PlayerData[playerid][pPassword], hash, BCRYPT_HASH_LENGTH);

    new query[512];
    mysql_format(g_SQL, query, sizeof(query),
        "INSERT INTO `users` (`Nombre`, `Password`, `PrimeraVez`) VALUES ('%e', '%e', NOW())",
        PlayerData[playerid][pNombre], PlayerData[playerid][pPassword]
    );
    mysql_tquery(g_SQL, query, "OnLoginAfterRegister", "d", playerid);
    return 1;
}

public OnLoginAfterRegister(playerid)
{
    PlayerData[playerid][pId] = cache_insert_id();
    PlayerData[playerid][pLogueado] = 1;
    PlayerData[playerid][pDinero] = 0;
    PlayerData[playerid][pAdmin] = 0;

    SendClientMessage(playerid, COLOR_PRISION, "|___ San Andreas Prison RP ___|");
    SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a la prision. Has sido registrado.");
    TogglePlayerSpectating(playerid, false);
    return 1;
}

public OnPasswordVerify(playerid, bool:success)
{
    if(!success)
    {
        SendClientMessage(playerid, COLOR_ROJO, "Contrasena incorrecta.");
        ShowLoginDialog(playerid);
        return 1;
    }

    PlayerData[playerid][pLogueado] = 1;
    SendClientMessage(playerid, COLOR_PRISION, "|___ San Andreas Prison RP ___|");
    SendClientMessage(playerid, COLOR_VERDE, "Sesion iniciada correctamente.");
    TogglePlayerSpectating(playerid, false);
    return 1;
}

stock ShowRegisterDialog(playerid)
{
    new dialog[256];
    format(dialog, sizeof(dialog),
        "Bienvenido a San Andreas Prison RP

Tu nombre: %s

Este nombre no esta registrado.
Ingresa una contrasena para registrarte:",
        PlayerData[playerid][pNombre]);
    ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_INPUT,
        "Registro", dialog, "Registrar", "Salir");
}

stock ShowLoginDialog(playerid)
{
    new dialog[256];
    format(dialog, sizeof(dialog),
        "Bienvenido de vuelta a San Andreas Prison RP

Tu nombre: %s

Ingresa tu contrasena:",
        PlayerData[playerid][pNombre]);
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,
        "Iniciar Sesion", dialog, "Entrar", "Salir");
}

stock OnAccountCheck(playerid)
{
    new query[256];
    mysql_format(g_SQL, query, sizeof(query),
        "SELECT * FROM `users` WHERE `Nombre` = '%e'",
        PlayerData[playerid][pNombre]);
    mysql_tquery(g_SQL, query, "OnCheckAccountResult", "d", playerid);
}

public OnCheckAccountResult(playerid)
{
    new rows = cache_num_rows();
    if(rows > 0)
    {
        cache_get_value_name_int(0, "Id", PlayerData[playerid][pId]);
        cache_get_value_name(0, "Password", PlayerData[playerid][pPassword], BCRYPT_HASH_LENGTH);
        cache_get_value_name_int(0, "Admin", PlayerData[playerid][pAdmin]);
        cache_get_value_name_int(0, "Dinero", PlayerData[playerid][pDinero]);
        cache_get_value_name_int(0, "Horas", PlayerData[playerid][pHoras]);
        cache_get_value_name_int(0, "Baneado", PlayerData[playerid][pBaneado]);
        cache_get_value_name_float(0, "PosX", PlayerData[playerid][pPosX]);
        cache_get_value_name_float(0, "PosY", PlayerData[playerid][pPosY]);
        cache_get_value_name_float(0, "PosZ", PlayerData[playerid][pPosZ]);
        cache_get_value_name_float(0, "PosA", PlayerData[playerid][pPosA]);
        cache_get_value_name_int(0, "PosWorld", PlayerData[playerid][pPosWorld]);
        cache_get_value_name_int(0, "PosInterior", PlayerData[playerid][pPosInterior]);

        if(PlayerData[playerid][pBaneado] == 1)
        {
            cache_get_value_name(0, "RazonBan", PlayerData[playerid][pRazonBan], 128);
            SendClientMessage(playerid, COLOR_ROJO, "Estas baneado del servidor.");
            SendClientMessage(playerid, COLOR_ROJO, PlayerData[playerid][pRazonBan]);
            Kick(playerid);
            return 1;
        }
        ShowLoginDialog(playerid);
    }
    else
        ShowRegisterDialog(playerid);
    return 1;
}
