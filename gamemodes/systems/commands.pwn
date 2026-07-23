//
// commands.pwn
//

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(PlayerData[playerid][pLogueado] == 0) return 0;

    if(strcmp(cmdtext, "/ayuda", true, 6) == 0)
    {
        SendClientMessage(playerid, COLOR_PRISION, "|___ Comandos San Andreas Prison RP ___|");
        SendClientMessage(playerid, COLOR_BLANCO, "/ayuda - Este menu");
        SendClientMessage(playerid, COLOR_BLANCO, "/entrar - Entrar a un edificio");
        SendClientMessage(playerid, COLOR_BLANCO, "/celda - Gestionar tu celda");
        SendClientMessage(playerid, COLOR_BLANCO, "/trabajo - Ver trabajos disponibles");
        SendClientMessage(playerid, COLOR_BLANCO, "/faccion - Info de tu faccion");
        SendClientMessage(playerid, COLOR_BLANCO, "/presos - Lista de presos en linea");
        SendClientMessage(playerid, COLOR_BLANCO, "/reportar - Reportar un problema");
        SendClientMessage(playerid, COLOR_BLANCO, "/me - Accion en tercera persona");
        SendClientMessage(playerid, COLOR_BLANCO, "/do - Descripcion de entorno");
        return 1;
    }

    if(strcmp(cmdtext, "/me", true, 4) == 0)
    {
        new text[128];
        if(sscanf(cmdtext[4], "s[128]", text))
        {
            SendClientMessage(playerid, COLOR_GRIS, "Uso: /me [accion]");
            return 1;
        }
        new msg[144];
        format(msg, sizeof(msg), "* %s %s", PlayerData[playerid][pNombre], text);
        SendClientMessageToAll(COLOR_GRIS, msg);
        return 1;
    }

    if(strcmp(cmdtext, "/do", true, 3) == 0)
    {
        new text[128];
        if(sscanf(cmdtext[3], "s[128]", text))
        {
            SendClientMessage(playerid, COLOR_GRIS, "Uso: /do [descripcion]");
            return 1;
        }
        new msg[144];
        format(msg, sizeof(msg), "** %s (( %s ))", text, PlayerData[playerid][pNombre]);
        SendClientMessageToAll(COLOR_GRIS, msg);
        return 1;
    }

    if(strcmp(cmdtext, "/celda", true, 6) == 0)
    {
        new dialog[512];
        format(dialog, sizeof(dialog),
            "Pabellon actual: %s
Celda: %d
Conducta: %d
Condena restante: %d segundos",
            gPabellonNombres[PlayerData[playerid][pPabellon]],
            PlayerData[playerid][pCelda],
            PlayerData[playerid][pConducta],
            PlayerData[playerid][pCondena]);
        ShowPlayerDialog(playerid, 100, DIALOG_STYLE_MSGBOX,
            "Tu Celda", dialog, "Cerrar", "");
        return 1;
    }

    if(strcmp(cmdtext, "/trabajo", true, 8) == 0)
    {
        new dialog[512];
        format(dialog, sizeof(dialog),
            "Tu trabajo actual: %s

Trabajos disponibles:
", gTrabajoNombres[PlayerData[playerid][pTrabajo]]);
        for(new i = 1; i < TRABAJO_MAX; i++)
            format(dialog, sizeof(dialog), "%s%d. %s
", dialog, i, gTrabajoNombres[i]);
        strcat(dialog, "
Usa /solicitar [numero] para pedir un trabajo.");
        ShowPlayerDialog(playerid, 101, DIALOG_STYLE_MSGBOX,
            "Trabajos de la Prision", dialog, "Cerrar", "");
        return 1;
    }

    if(strcmp(cmdtext, "/solicitar", true, 10) == 0)
    {
        new trabajo;
        if(sscanf(cmdtext[10], "d", trabajo))
        {
            SendClientMessage(playerid, COLOR_GRIS, "Uso: /solicitar [numero de trabajo]");
            return 1;
        }
        if(trabajo < 1 || trabajo >= TRABAJO_MAX)
        {
            SendClientMessage(playerid, COLOR_ROJO, "Trabajo invalido.");
            return 1;
        }
        PlayerData[playerid][pTrabajo] = trabajo;
        new msg[128];
        format(msg, sizeof(msg), "Has solicitado trabajo en: %s", gTrabajoNombres[trabajo]);
        SendClientMessage(playerid, COLOR_VERDE, msg);
        return 1;
    }

    if(strcmp(cmdtext, "/presos", true, 7) == 0)
    {
        new count, msg[256];
        SendClientMessage(playerid, COLOR_PRISION, "|___ Presos en linea ___|");
        for(new i; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && PlayerData[i][pLogueado] && PlayerData[i][pEsPreso])
            {
                format(msg, sizeof(msg), "%d. %s | Pabellon: %s | Celda: %d",
                    ++count,
                    PlayerData[i][pNombre],
                    gPabellonNombres[PlayerData[i][pPabellon]],
                    PlayerData[i][pCelda]);
                SendClientMessage(playerid, COLOR_BLANCO, msg);
            }
        }
        if(count == 0)
            SendClientMessage(playerid, COLOR_GRIS, "No hay presos en linea.");
        return 1;
    }

    if(strcmp(cmdtext, "/reportar", true, 9) == 0)
    {
        new razon[128];
        if(sscanf(cmdtext[9], "s[128]", razon))
        {
            SendClientMessage(playerid, COLOR_GRIS, "Uso: /reportar [razon]");
            return 1;
        }
        new msg[256];
        format(msg, sizeof(msg), "[REPORTE] %s: %s", PlayerData[playerid][pNombre], razon);
        for(new i; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && PlayerData[i][pAdmin] >= 1)
                SendClientMessage(i, COLOR_ROJO, msg);
        }
        SendClientMessage(playerid, COLOR_VERDE, "Reporte enviado a los admins.");
        return 1;
    }

    if(strcmp(cmdtext, "/faccion", true, 8) == 0)
    {
        new faccion = PlayerData[playerid][pFaccion];
        if(faccion < 0 || faccion >= FACCION_MAX)
        {
            SendClientMessage(playerid, COLOR_GRIS, "No perteneces a ninguna faccion.");
            return 1;
        }
        new msg[128];
        format(msg, sizeof(msg), "Faccion: %s | Rango: %d",
            gFaccionNombres[faccion], PlayerData[playerid][pFaccionRango]);
        SendClientMessage(playerid, COLOR_PRISION, msg);
        return 1;
    }

    if(strcmp(cmdtext, "/setpreso", true, 9) == 0)
    {
        if(PlayerData[playerid][pAdmin] < 1) return 0;
        new target, segundos;
        if(sscanf(cmdtext[9], "dd", target, segundos))
        {
            SendClientMessage(playerid, COLOR_GRIS, "Uso: /setpreso [id] [segundos]");
            return 1;
        }
        if(!IsPlayerConnected(target) || !PlayerData[target][pLogueado])
        {
            SendClientMessage(playerid, COLOR_ROJO, "Jugador invalido.");
            return 1;
        }
        PlayerData[target][pEsPreso] = 1;
        PlayerData[target][pCondena] = segundos;
        PlayerData[target][pCondenaOriginal] = segundos;
        new msg[128];
        format(msg, sizeof(msg), "Has enviado a %s a prision por %d segundos.", PlayerData[target][pNombre], segundos);
        SendClientMessage(playerid, COLOR_ADMIN, msg);
        SpawnPlayerInPrison(target);
        return 1;
    }

    if(strcmp(cmdtext, "/entrar", true, 7) == 0)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, EXT_DOOR_X, EXT_DOOR_Y, EXT_DOOR_Z) && GetPlayerVirtualWorld(playerid) == 0)
        {
            SendClientMessage(playerid, COLOR_GRIS, "El interior aun no esta disponible.");
            return 1;
        }
        SendClientMessage(playerid, COLOR_GRIS, "No hay ninguna puerta cerca.");
        return 1;
    }

    return 0;
}
