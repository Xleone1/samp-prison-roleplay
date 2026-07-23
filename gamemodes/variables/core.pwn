//
// variables/core.pwn
//

new MySQL:g_SQL;

enum E_PLAYER_DATA
{
    pId,
    pNombre[MAX_PLAYER_NAME],
    pPassword[BCRYPT_HASH_LENGTH],
    pAdmin,
    pSkin,
    pDinero,
    pHoras,
    pBaneado,
    pRazonBan[128],
    pLogueado,
    pSpawned,
    pEsPreso,
    pCondena,
    pCondenaOriginal,
    pPabellon,
    pCelda,
    pRangoPreso,
    pConducta,
    pTrabajo,
    pFaccion,
    pFaccionRango,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,
    pPosWorld,
    pPosInterior
}
new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];
new TimerSegundo[MAX_PLAYERS];
