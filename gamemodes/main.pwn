//
// San Andreas Prison RP - Gamemode principal
//

#include <open.mp>
#include <streamer>
#include <a_mysql>
#include <samp_bcrypt>
#include <sscanf2>

#include "constants/core.pwn"
#include "variables/core.pwn"
#include "utils/core.pwn"

#include "systems/auth/auth_data.pwn"
#include "systems/auth/auth_main.pwn"

#include "systems/prison/prison_data.pwn"
#include "systems/prison/prison_main.pwn"
#include "systems/prison/prison_map.pwn"

#include "systems/commands.pwn"

main()
{
    print("San Andreas Prison RP - Iniciando...");
}

public OnGameModeInit()
{
    new MySQLOpt:options = mysql_init_options();
    mysql_set_option(options, SSL_ENABLE, 0);
    g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB, options);
    if(g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
    {
        print("[ERROR] MySQL. Servidor detenido.");
        SendRconCommand("exit");
        return 0;
    }
    print("[MYSQL] Conectado.");

    SetGameModeText("San Andreas Prison RP");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    ShowNameTags(true);
    EnableStuntBonusForAll(false);
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(70.0);
    UsePlayerPedAnims();
    ManualVehicleEngineAndLights();

    bcrypt_set_thread_limit(3);

    SetWeather(10);
    SetWorldTime(8);

    AddPlayerClass(60, PRISION_SPAWN_X, PRISION_SPAWN_Y, PRISION_SPAWN_Z, PRISION_SPAWN_A, WEAPON:0, 0, WEAPON:0, 0, WEAPON:0, 0);

    LoadPrisonExterior();
    CreatePrisonDoors();

    print("[SERVER] San Andreas Prison RP iniciado.");
    return 1;
}

public OnGameModeExit()
{
    mysql_close(g_SQL);
    print("[SERVER] Servidor detenido.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerData[playerid][pLogueado] = 0;
    PlayerData[playerid][pSpawned] = 0;
    PlayerData[playerid][pId] = 0;
    PlayerData[playerid][pDinero] = 0;
    PlayerData[playerid][pAdmin] = 0;
    PlayerData[playerid][pEsPreso] = 0;
    PlayerData[playerid][pCondena] = 0;
    PlayerData[playerid][pCondenaOriginal] = 0;
    PlayerData[playerid][pPabellon] = 0;
    PlayerData[playerid][pCelda] = 0;
    PlayerData[playerid][pRangoPreso] = 0;
    PlayerData[playerid][pConducta] = 100;
    PlayerData[playerid][pTrabajo] = 0;
    PlayerData[playerid][pFaccion] = 0;
    PlayerData[playerid][pFaccionRango] = 0;
    PlayerData[playerid][pPassword][0] = EOS;

    GetPlayerName(playerid, PlayerData[playerid][pNombre], MAX_PLAYER_NAME);
    TimerSegundo[playerid] = SetTimerEx("PrisonTimerSegundo", 1000, true, "d", playerid);
    OnAccountCheck(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][pLogueado] == 1)
    {
        GetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
        PlayerData[playerid][pPosWorld] = GetPlayerVirtualWorld(playerid);
        PlayerData[playerid][pPosInterior] = GetPlayerInterior(playerid);

        new query[512];
        mysql_format(g_SQL, query, sizeof(query),
            "UPDATE `users` SET `Dinero` = %d, `Horas` = `Horas` + 1, `UltimaVez` = NOW(), `PosX` = %f, `PosY` = %f, `PosZ` = %f, `PosA` = %f, `PosWorld` = %d, `PosInterior` = %d WHERE `Id` = %d",
            PlayerData[playerid][pDinero], PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ], PlayerData[playerid][pPosA], PlayerData[playerid][pPosWorld], PlayerData[playerid][pPosInterior], PlayerData[playerid][pId]);
        mysql_tquery(g_SQL, query);
    }
    KillTimer(TimerSegundo[playerid]);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(PlayerData[playerid][pLogueado] == 1)
    {
        if(PlayerData[playerid][pPosX] != 0.0 && PlayerData[playerid][pPosY] != 0.0)
        {
            SetPlayerInterior(playerid, PlayerData[playerid][pPosInterior]);
            SetPlayerVirtualWorld(playerid, PlayerData[playerid][pPosWorld]);
            SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
            SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
            SetCameraBehindPlayer(playerid);
        }
        else
            SpawnPlayerInPrison(playerid);
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    TogglePlayerSpectating(playerid, true);
    SetPlayerCameraPos(playerid, INTRO_CAM_X, INTRO_CAM_Y, INTRO_CAM_Z);
    SetPlayerCameraLookAt(playerid, INTRO_LOOK_X, INTRO_LOOK_Y, INTRO_LOOK_Z, CAMERA_MOVE);
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    SpawnPlayerInPrison(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_REGISTRO:
        {
            if(!response) { Kick(playerid); return 1; }
            if(strlen(inputtext) < 4)
            {
                SendClientMessage(playerid, COLOR_ROJO, "Minimo 4 caracteres.");
                ShowRegisterDialog(playerid);
                return 1;
            }
            bcrypt_hash(playerid, "OnPasswordHashDone", inputtext, BCRYPT_COST);
            return 1;
        }
        case DIALOG_LOGIN:
        {
            if(!response) { Kick(playerid); return 1; }
            bcrypt_verify(playerid, "OnPasswordVerify", inputtext, PlayerData[playerid][pPassword]);
            return 1;
        }
    }
    return 0;
}
