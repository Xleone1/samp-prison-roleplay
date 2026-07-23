
forward PrisonTimerSegundo(playerid);

new gExtCP = -1;
new gIntCP = -1;

stock SetPlayerCameraIntro(playerid)
{
    TogglePlayerSpectating(playerid, true);
    SetPlayerCameraPos(playerid, INTRO_CAM_X, INTRO_CAM_Y, INTRO_CAM_Z);
    SetPlayerCameraLookAt(playerid, INTRO_LOOK_X, INTRO_LOOK_Y, INTRO_LOOK_Z, CAMERA_MOVE);
}

stock SpawnPlayerInPrison(playerid)
{
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
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

stock CreatePrisonCheckpoints()
{
    gExtCP = CreateDynamicCircle(EXT_DOOR_X, EXT_DOOR_Y, 2.0, 0, 0);
    gIntCP = CreateDynamicCircle(INT_DOOR_X, INT_DOOR_Y, 2.0, PRISION_INT_WORLD, PRISION_INT_INTERIOR);
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == gExtCP && PlayerData[playerid][pLogueado] == 1)
    {
        SetPlayerInterior(playerid, PRISION_INT_INTERIOR);
        SetPlayerVirtualWorld(playerid, PRISION_INT_WORLD);
        SetPlayerPos(playerid, INT_DOOR_X, INT_DOOR_Y, INT_DOOR_Z);
        SetPlayerFacingAngle(playerid, 0.0);
        SetCameraBehindPlayer(playerid);
        return 1;
    }
    if(areaid == gIntCP && PlayerData[playerid][pLogueado] == 1)
    {
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerPos(playerid, EXT_DOOR_X, EXT_DOOR_Y, EXT_DOOR_Z);
        SetPlayerFacingAngle(playerid, 270.0);
        SetCameraBehindPlayer(playerid);
        return 1;
    }
    return 0;
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
