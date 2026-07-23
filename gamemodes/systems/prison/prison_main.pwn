//
// prison_main.pwn
//

forward PrisonTimerSegundo(playerid);

stock SpawnPlayerInPrison(playerid)
{
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, PRISION_SPAWN_X, PRISION_SPAWN_Y, PRISION_SPAWN_Z);
    SetPlayerFacingAngle(playerid, PRISION_SPAWN_A);
    SetCameraBehindPlayer(playerid);

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);

    if(PlayerData[playerid][pSkin] == 0)
    {
        if(PlayerData[playerid][pEsPreso] == 1)
            SetPlayerSkin(playerid, 50);
        else
            SetPlayerSkin(playerid, 60);
    }
    else
        SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);

    PlayerData[playerid][pSpawned] = 1;
    TogglePlayerClock(playerid, false);
    SetPlayerTime(playerid, 8, 0);

    new msg[128];
    format(msg, sizeof(msg), "Bienvenido a San Andreas Prison RP, %s.", PlayerData[playerid][pNombre]);
    SendClientMessage(playerid, COLOR_PRISION, msg);
    SendClientMessage(playerid, COLOR_GRIS, "Usa /ayuda para ver los comandos.");
    return 1;
}

public PrisonTimerSegundo(playerid)
{
    if(PlayerData[playerid][pLogueado] == 0 || PlayerData[playerid][pEsPreso] == 0)
        return 1;

    if(PlayerData[playerid][pCondena] > 0)
    {
        PlayerData[playerid][pCondena]--;
        if(PlayerData[playerid][pCondena] <= 0)
        {
            PlayerData[playerid][pCondena] = 0;
            PlayerData[playerid][pEsPreso] = 0;
            SendClientMessage(playerid, COLOR_VERDE, "Has cumplido tu condena. Eres libre.");
            SetPlayerPos(playerid, 0.0, 0.0, 3.0);
        }
    }
    return 1;
}
