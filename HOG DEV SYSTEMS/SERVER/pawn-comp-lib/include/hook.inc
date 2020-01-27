#define include::%0(%1) \
		forward _@%0(%1); \
		public _@%0(%1)
#define inc->%0(%1) include::%0(%1)
#define hook::%0(%1) include::%0(%1)

#define MAX_NAME (30)

forward _wOnGameModeInit();
forward _wOnGameModeExit();
forward _wOnFilterScriptInit();
forward _wOnFilterScriptExit();
forward _wOnPlayerConnect(playerid);
forward _wOnPlayerDisconnect(playerid, reason);
forward _wOnPlayerSpawn(playerid);
forward _wOnPlayerDeath(playerid, killerid, reason);
forward _wOnVehicleSpawn(vehicleid);
forward _wOnVehicleDeath(vehicleid, killerid);
forward _wOnPlayerText(playerid, text[]);
forward _wOnPlayerCommandText(playerid, cmdtext[]);
forward _wOnPlayerRequestClass(playerid, classid);
forward _wOnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
forward _wOnPlayerExitVehicle(playerid, vehicleid);
forward _wOnPlayerStateChange(playerid, newstate, oldstate);
forward _wOnPlayerEnterCheckpoint(playerid);
forward _wOnPlayerLeaveCheckpoint(playerid);
forward _wOnPlayerEnterRaceCheckpoint(playerid);
forward _wOnPlayerLeaveRaceCheckpoint(playerid);
forward _wOnRconCommand(cmd[]);
forward _wOnPlayerRequestSpawn(playerid);
forward _wOnObjectMoved(objectid);
forward _wOnPlayerObjectMoved(playerid, objectid);
forward _wOnPlayerPickUpPickup(playerid, pickupid);
forward _wOnVehicleMod(playerid, vehicleid, componentid);
forward _wOnEnterExitModShop(playerid, enterexit, interiorid);
forward _wOnVehiclePaintjob(playerid, vehicleid, paintjobid);
forward _wOnVehicleRespray(playerid, vehicleid, color1, color2);
forward _wOnVehicleDamageStatusUpdate(vehicleid, playerid);
forward _wOnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat);
forward _wOnPlayerSelectedMenuRow(playerid, row);
forward _wOnPlayerExitedMenu(playerid);
forward _wOnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);
forward _wOnPlayerKeyStateChange(playerid, newkeys, oldkeys);
forward _wOnRconLoginAttempt( ip[], password[], success );
forward _wOnPlayerUpdate(playerid);
forward _wOnPlayerStreamIn(playerid, forplayerid);
forward _wOnPlayerStreamOut(playerid, forplayerid);
forward _wOnVehicleStreamIn(vehicleid, forplayerid);
forward _wOnVehicleStreamOut(vehicleid, forplayerid);
forward _wOnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
forward _wOnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid);
forward _wOnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid);
forward _wOnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ);
forward _wOnPlayerClickTextDraw(playerid, Text:clickedid);
forward _wOnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
forward _wOnPlayerClickPlayer(playerid, clickedplayerid, source);
forward _wOnPlayerEditObject( playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ );
forward _wOnPlayerEditAttachedObject( playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ );
forward _wOnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ);

public OnGameModeInit()
{
	//strcat(gHookName, "_@OnGameModeInit");

    if (funcidx("_@OnGameModeInit") != -1)
   		CallLocalFunction("_@OnGameModeInit", "");

	if (funcidx("_wOnGameModeInit") != -1)
	    return CallLocalFunction("_wOnGameModeInit", "");

    return 1;
}

#if defined ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define OnGameModeInit _wOnGameModeInit
#endif
public OnGameModeExit()
{
	//strcat(gHookName, "_@OnGameModeInit");

    if (funcidx("_@OnGameModeExit") != -1)
   		CallLocalFunction("_@OnGameModeExit", "");

	if (funcidx("_wOnGameModeExit") != -1)
	    return CallLocalFunction("_wOnGameModeExit", "");

    return 1;
}

#if defined ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define OnGameModeExit _wOnGameModeExit
#endif
public OnFilterScriptInit()
{
	//strcat(gHookName, "_@OnFilterScriptInit");

    if (funcidx("_@OnFilterScriptInit") != -1)
   		CallLocalFunction("_@OnFilterScriptInit", "");

	if (funcidx("_wOnFilterScriptInit") != -1)
	    return CallLocalFunction("_wOnFilterScriptInit", "");

    return 1;
}

#if defined ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define OnFilterScriptInit _wOnFilterScriptInit
#endif
public OnFilterScriptExit()
{
	//strcat(gHookName, "_@OnFilterScriptExit");

    if (funcidx("_@OnFilterScriptExit") != -1)
   		CallLocalFunction("_@OnFilterScriptExit", "");

	if (funcidx("_wOnFilterScriptExit") != -1)
	    return CallLocalFunction("_wOnFilterScriptExit", "");

    return 1;
}

#if defined ALS_OnFilterScriptExit
    #undef OnFilterScriptExit
#else
    #define OnFilterScriptExit _wOnFilterScriptExit
#endif
public OnPlayerConnect(playerid)
{
	//strcat(gHookName, "_@OnPlayerConnect");

    if (funcidx("_@OnPlayerConnect") != -1)
   		CallLocalFunction("_@OnPlayerConnect", "i", playerid);

	if (funcidx("_wOnPlayerConnect") != -1)
	    return CallLocalFunction("_wOnPlayerConnect", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define OnPlayerConnect _wOnPlayerConnect
#endif
public OnPlayerDisconnect(playerid, reason)
{
	//strcat(gHookName, "_@OnPlayerDisconnect");

    if (funcidx("_@OnPlayerDisconnect") != -1)
   		CallLocalFunction("_@OnPlayerDisconnect", "ii", playerid, reason);

	if (funcidx("_wOnPlayerDisconnect") != -1)
	    return CallLocalFunction("_wOnPlayerDisconnect", "ii", playerid, reason);

    return 1;
}

#if defined ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define OnPlayerDisconnect _wOnPlayerDisconnect
#endif
public OnPlayerSpawn(playerid)
{
	//strcat(gHookName, "_@OnPlayerSpawn");

    if (funcidx("_@OnPlayerSpawn") != -1)
   		CallLocalFunction("_@OnPlayerSpawn", "i", playerid);

	if (funcidx("_wOnPlayerSpawn") != -1)
	    return CallLocalFunction("_wOnPlayerSpawn", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define OnPlayerSpawn _wOnPlayerSpawn
#endif
public OnPlayerDeath(playerid, killerid, reason)
{
	//strcat(gHookName, "_@OnPlayerDeath");

    if (funcidx("_@OnPlayerDeath") != -1)
   		CallLocalFunction("_@OnPlayerDeath", "iii", playerid, killerid, reason);

	if (funcidx("_wOnPlayerDeath") != -1)
	    return CallLocalFunction("_wOnPlayerDeath", "iii", playerid, killerid, reason);

    return 1;
}

#if defined ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define OnPlayerDeath _wOnPlayerDeath
#endif
public OnVehicleSpawn(vehicleid)
{
	//strcat(gHookName, "_@OnVehicleSpawn");

    if (funcidx("_@OnVehicleSpawn") != -1)
   		CallLocalFunction("_@OnVehicleSpawn", "i", vehicleid);

	if (funcidx("_wOnVehicleSpawn") != -1)
	    return CallLocalFunction("_wOnVehicleSpawn", "i", vehicleid);

    return 1;
}

#if defined ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define OnVehicleSpawn _wOnVehicleSpawn
#endif
public OnVehicleDeath(vehicleid, killerid)
{
	//strcat(gHookName, "_@OnVehicleDeath");

    if (funcidx("_@OnVehicleDeath") != -1)
   		CallLocalFunction("_@OnVehicleDeath", "ii", vehicleid, killerid);

	if (funcidx("_wOnVehicleDeath") != -1)
	    return CallLocalFunction("_wOnVehicleDeath", "ii", vehicleid, killerid);

    return 1;
}

#if defined ALS_OnVehicleDeath
    #undef OnVehicleDeath
#else
    #define OnVehicleDeath _wOnVehicleDeath
#endif
public OnPlayerText(playerid, text[])
{
	//strcat(gHookName, "_@OnPlayerText");

    if (funcidx("_@OnPlayerText") != -1)
   		CallLocalFunction("_@OnPlayerText", "is", playerid, text);

	if (funcidx("_wOnPlayerText") != -1)
	    return CallLocalFunction("_wOnPlayerText", "is", playerid, text);

    return 1;
}

#if defined ALS_OnPlayerText
    #undef OnPlayerText
#else
    #define OnPlayerText _wOnPlayerText
#endif
public OnPlayerCommandText(playerid, cmdtext[])
{
	//strcat(gHookName, "_@OnPlayerCommandText");

    if (funcidx("_@OnPlayerCommandText") != -1)
   		CallLocalFunction("_@OnPlayerCommandText", "is", playerid, cmdtext);

	if (funcidx("_wOnPlayerCommandText") != -1)
	    return CallLocalFunction("_wOnPlayerCommandText", "is", playerid, cmdtext);

    return 1;
}

#if defined ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define OnPlayerCommandText _wOnPlayerCommandText
#endif
public OnPlayerRequestClass(playerid, classid)
{
	//strcat(gHookName, "_@OnPlayerRequestClass");

    if (funcidx("_@OnPlayerRequestClass") != -1)
   		CallLocalFunction("_@OnPlayerRequestClass", "ii", playerid, classid);

	if (funcidx("_wOnPlayerRequestClass") != -1)
	    return CallLocalFunction("_wOnPlayerRequestClass", "ii", playerid, classid);

    return 1;
}

#if defined ALS_OnPlayerRequestClass
    #undef OnPlayerRequestClass
#else
    #define OnPlayerRequestClass _wOnPlayerRequestClass
#endif
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	//strcat(gHookName, "_@OnPlayerEnterVehicle");

    if (funcidx("_@OnPlayerEnterVehicle") != -1)
   		CallLocalFunction("_@OnPlayerEnterVehicle", "iii", playerid, vehicleid, ispassenger);

	if (funcidx("_wOnPlayerEnterVehicle") != -1)
	    return CallLocalFunction("_wOnPlayerEnterVehicle", "iii", playerid, vehicleid, ispassenger);

    return 1;
}

#if defined ALS_OnPlayerEnterVehicle
    #undef OnPlayerEnterVehicle
#else
    #define OnPlayerEnterVehicle _wOnPlayerEnterVehicle
#endif
public OnPlayerExitVehicle(playerid, vehicleid)
{
	//strcat(gHookName, "_@OnPlayerExitVehicle");

    if (funcidx("_@OnPlayerExitVehicle") != -1)
   		CallLocalFunction("_@OnPlayerExitVehicle", "ii", playerid, vehicleid);

	if (funcidx("_wOnPlayerExitVehicle") != -1)
	    return CallLocalFunction("_wOnPlayerExitVehicle", "ii", playerid, vehicleid);

    return 1;
}

#if defined ALS_OnPlayerExitVehicle
    #undef OnPlayerExitVehicle
#else
    #define OnPlayerExitVehicle _wOnPlayerExitVehicle
#endif
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	//strcat(gHookName, "_@OnPlayerStateChange");

    if (funcidx("_@OnPlayerStateChange") != -1)
   		CallLocalFunction("_@OnPlayerStateChange", "iii", playerid, newstate, oldstate);

	if (funcidx("_wOnPlayerStateChange") != -1)
	    return CallLocalFunction("_wOnPlayerStateChange", "iii", playerid, newstate, oldstate);

    return 1;
}

#if defined ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define OnPlayerStateChange _wOnPlayerStateChange
#endif
public OnPlayerEnterCheckpoint(playerid)
{
	//strcat(gHookName, "_@OnPlayerEnterCheckpoint");

    if (funcidx("_@OnPlayerEnterCheckpoint") != -1)
   		CallLocalFunction("_@OnPlayerEnterCheckpoint", "i", playerid);

	if (funcidx("_wOnPlayerEnterCheckpoint") != -1)
	    return CallLocalFunction("_wOnPlayerEnterCheckpoint", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define OnPlayerEnterCheckpoint _wOnPlayerEnterCheckpoint
#endif
public OnPlayerLeaveCheckpoint(playerid)
{
	//strcat(gHookName, "_@OnPlayerLeaveCheckpoint");

    if (funcidx("_@OnPlayerLeaveCheckpoint") != -1)
   		CallLocalFunction("_@OnPlayerLeaveCheckpoint", "i", playerid);

	if (funcidx("_wOnPlayerLeaveCheckpoint") != -1)
	    return CallLocalFunction("_wOnPlayerLeaveCheckpoint", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerLeaveCheckpoint
    #undef OnPlayerLeaveCheckpoint
#else
    #define OnPlayerLeaveCheckpoint _wOnPlayerLeaveCheckpoint
#endif
public OnPlayerEnterRaceCheckpoint(playerid)
{
	//strcat(gHookName, "_@OnPlayerEnterRaceCheckpoint");

    if (funcidx("_@OnPlayerEnterRaceCheckpoint") != -1)
   		CallLocalFunction("_@OnPlayerEnterRaceCheckpoint", "i", playerid);

	if (funcidx("_wOnPlayerEnterRaceCheckpoint") != -1)
	    return CallLocalFunction("_wOnPlayerEnterRaceCheckpoint", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerEnterRaceCheckpoint
    #undef OnPlayerEnterRaceCheckpoint
#else
    #define OnPlayerEnterRaceCheckpoint _wOnPlayerEnterRaceCheckpoint
#endif
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	//strcat(gHookName, "_@OnPlayerLeaveRaceCheckpoint");

    if (funcidx("_@OnPlayerLeaveRaceCheckpoint") != -1)
   		CallLocalFunction("_@OnPlayerLeaveRaceCheckpoint", "i", playerid);

	if (funcidx("_wOnPlayerLeaveRaceCheckpoint") != -1)
	    return CallLocalFunction("_wOnPlayerLeaveRaceCheckpoint", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerLeaveRaceCheckpoint
    #undef OnPlayerLeaveRaceCheckpoint
#else
    #define OnPlayerLeaveRaceCheckpoint _wOnPlayerLeaveRaceCheckpoint
#endif
public OnRconCommand(cmd[])
{
	//strcat(gHookName, "_@OnRconCommand");

    if (funcidx("_@OnRconCommand") != -1)
   		CallLocalFunction("_@OnRconCommand", "s", cmd);

	if (funcidx("_wOnRconCommand") != -1)
	    return CallLocalFunction("_wOnRconCommand", "s", cmd);

    return 1;
}

#if defined ALS_OnRconCommand
    #undef OnRconCommand
#else
    #define OnRconCommand _wOnRconCommand
#endif
public OnPlayerRequestSpawn(playerid)
{
	//strcat(gHookName, "_@OnPlayerRequestSpawn");

    if (funcidx("_@OnPlayerLeaveRaceCheckpoint") != -1)
   		CallLocalFunction("_@OnPlayerLeaveRaceCheckpoint", "i", playerid);

	if (funcidx("_wOnPlayerLeaveRaceCheckpoint") != -1)
	    return CallLocalFunction("_wOnPlayerLeaveRaceCheckpoint", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerLeaveRaceCheckpoint
    #undef OnPlayerLeaveRaceCheckpoint
#else
    #define OnPlayerLeaveRaceCheckpoint _wOnPlayerLeaveRaceCheckpoint
#endif
public OnObjectMoved(objectid)
{
	//strcat(gHookName, "_@OnObjectMoved");

    if (funcidx("_@OnObjectMoved") != -1)
   		CallLocalFunction("_@OnObjectMoved", "i", objectid);

	if (funcidx("_wOnObjectMoved") != -1)
	    return CallLocalFunction("_wOnObjectMoved", "i", objectid);

    return 1;
}

#if defined ALS_OnObjectMoved
    #undef OnObjectMoved
#else
    #define OnObjectMoved _wOnObjectMoved
#endif
public OnPlayerObjectMoved(playerid, objectid)
{
	//strcat(gHookName, "_@OnPlayerObjectMoved");

    if (funcidx("_@OnPlayerObjectMoved") != -1)
   		CallLocalFunction("_@OnPlayerObjectMoved", "ii", playerid, objectid);

	if (funcidx("_wOnPlayerObjectMoved") != -1)
	    return CallLocalFunction("_wOnPlayerObjectMoved", "ii", playerid, objectid);

    return 1;
}

#if defined ALS_OnPlayerObjectMoved
    #undef OnPlayerObjectMoved
#else
    #define OnPlayerObjectMoved _wOnPlayerObjectMoved
#endif
public OnPlayerPickUpPickup(playerid, pickupid)
{
	//strcat(gHookName, "_@OnPlayerPickUpPickup");

    if (funcidx("_@OnPlayerPickUpPickup") != -1)
   		CallLocalFunction("_@OnPlayerPickUpPickup", "ii", playerid, pickupid);

	if (funcidx("_wOnPlayerPickUpPickup") != -1)
	    return CallLocalFunction("_wOnPlayerPickUpPickup", "ii", playerid, pickupid);

    return 1;
}

#if defined ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define OnPlayerPickUpPickup _wOnPlayerPickUpPickup
#endif
public OnVehicleMod(playerid, vehicleid, componentid)
{
	//strcat(gHookName, "_@OnVehicleMod");

    if (funcidx("_@OnVehicleMod") != -1)
   		CallLocalFunction("_@OnVehicleMod", "iii", playerid, vehicleid, componentid);

	if (funcidx("_wOnVehicleMod") != -1)
	    return CallLocalFunction("_wOnVehicleMod", "iii", playerid, vehicleid, componentid);

    return 1;
}

#if defined ALS_OnVehicleMod
    #undef OnVehicleMod
#else
    #define OnVehicleMod _wOnVehicleMod
#endif
public OnEnterExitModShop(playerid, enterexit, interiorid)
{
	//strcat(gHookName, "_@OnEnterExitModShop");

    if (funcidx("_@OnEnterExitModShop") != -1)
   		CallLocalFunction("_@OnEnterExitModShop", "iii", playerid, enterexit, interiorid);

	if (funcidx("_wOnEnterExitModShop") != -1)
	    return CallLocalFunction("_wOnEnterExitModShop", "iii", playerid, enterexit, interiorid);

    return 1;
}

#if defined ALS_OnEnterExitModShop
    #undef OnEnterExitModShop
#else
    #define OnEnterExitModShop _wOnEnterExitModShop
#endif
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	//strcat(gHookName, "_@OnVehiclePaintjob");

    if (funcidx("_@OnVehiclePaintjob") != -1)
   		CallLocalFunction("_@OnVehiclePaintjob", "iii", playerid, vehicleid, paintjobid);

	if (funcidx("_wOnVehiclePaintjob") != -1)
	    return CallLocalFunction("_wOnVehiclePaintjob", "iii", playerid, vehicleid, paintjobid);

    return 1;
}

#if defined ALS_OnVehiclePaintjob
    #undef OnVehiclePaintjob
#else
    #define OnVehiclePaintjob _wOnVehiclePaintjob
#endif
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	//strcat(gHookName, "_@OnVehicleRespray");

    if (funcidx("_@OnVehicleRespray") != -1)
   		CallLocalFunction("_@OnVehicleRespray", "iiii", playerid, vehicleid, color1, color2);

	if (funcidx("_wOnVehicleRespray") != -1)
	    return CallLocalFunction("_wOnVehicleRespray", "iiii", playerid, vehicleid, color1, color2);

    return 1;
}

#if defined ALS_OnVehicleRespray
    #undef OnVehicleRespray
#else
    #define OnVehicleRespray _wOnVehicleRespray
#endif
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	//strcat(gHookName, "_@OnVehicleDamageStatusUpdate");

    if (funcidx("_@OnVehicleDamageStatusUpdate") != -1)
   		CallLocalFunction("_@OnVehicleDamageStatusUpdate", "ii", vehicleid, playerid);

	if (funcidx("_wOnVehicleDamageStatusUpdate") != -1)
	    return CallLocalFunction("_wOnVehicleDamageStatusUpdate", "ii", vehicleid, playerid);

    return 1;
}

#if defined ALS_OnVehicleDamageStatusUpdate
    #undef OnVehicleDamageStatusUpdate
#else
    #define OnVehicleDamageStatusUpdate _wOnVehicleDamageStatusUpdate
#endif
public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat)
{
	//strcat(gHookName, "_@OnUnoccupiedVehicleUpdate");

    if (funcidx("_@OnUnoccupiedVehicleUpdate") != -1)
   		CallLocalFunction("_@OnUnoccupiedVehicleUpdate", "iii", vehicleid, playerid, passenger_seat);

	if (funcidx("_wOnUnoccupiedVehicleUpdate") != -1)
	    return CallLocalFunction("_wOnUnoccupiedVehicleUpdate", "iii", vehicleid, playerid, passenger_seat);

    return 1;
}

#if defined ALS_OnUnoccupiedVehicleUpdate
    #undef OnUnoccupiedVehicleUpdate
#else
    #define OnUnoccupiedVehicleUpdate _wOnUnoccupiedVehicleUpdate
#endif
public OnPlayerSelectedMenuRow(playerid, row)
{
	//strcat(gHookName, "_@OnPlayerSelectedMenuRow");

    if (funcidx("_@OnPlayerSelectedMenuRow") != -1)
   		CallLocalFunction("_@OnPlayerSelectedMenuRow", "ii", playerid, row);

	if (funcidx("_wOnPlayerSelectedMenuRow") != -1)
	    return CallLocalFunction("_wOnPlayerSelectedMenuRow", "ii", playerid, row);

    return 1;
}

#if defined ALS_OnPlayerSelectedMenuRow
    #undef OnPlayerSelectedMenuRow
#else
    #define OnPlayerSelectedMenuRow _wOnPlayerSelectedMenuRow
#endif
public OnPlayerExitedMenu(playerid)
{
	//strcat(gHookName, "_@OnPlayerExitedMenu");

    if (funcidx("_@OnPlayerExitedMenu") != -1)
   		CallLocalFunction("_@OnPlayerExitedMenu", "i", playerid);

	if (funcidx("_wOnPlayerExitedMenu") != -1)
	    return CallLocalFunction("_wOnPlayerExitedMenu", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerExitedMenu
    #undef OnPlayerExitedMenu
#else
    #define OnPlayerExitedMenu _wOnPlayerExitedMenu
#endif
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	//strcat(gHookName, "_@OnPlayerInteriorChange");

    if (funcidx("_@OnPlayerInteriorChange") != -1)
   		CallLocalFunction("_@OnPlayerInteriorChange", "iii", playerid, newinteriorid, oldinteriorid);

	if (funcidx("_wOnPlayerInteriorChange") != -1)
	    return CallLocalFunction("_wOnPlayerInteriorChange", "iii", playerid, newinteriorid, oldinteriorid);

    return 1;
}

#if defined ALS_OnPlayerInteriorChange
    #undef OnPlayerInteriorChange
#else
    #define OnPlayerInteriorChange _wOnPlayerInteriorChange
#endif
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//strcat(gHookName, "_@OnPlayerKeyStateChange");

    if (funcidx("_@OnPlayerKeyStateChange") != -1)
   		CallLocalFunction("_@OnPlayerKeyStateChange", "iii", playerid, newkeys, oldkeys);

	if (funcidx("_wOnPlayerKeyStateChange") != -1)
	    return CallLocalFunction("_wOnPlayerKeyStateChange", "iii", playerid, newkeys, oldkeys);

    return 1;
}

#if defined ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define OnPlayerKeyStateChange _wOnPlayerKeyStateChange
#endif
public OnRconLoginAttempt(ip[], password[], success)
{
	//strcat(gHookName, "_@OnRconLoginAttempt");

    if (funcidx("_@OnRconLoginAttempt") != -1)
   		CallLocalFunction("_@OnRconLoginAttempt", "ssi", ip, password, success);

	if (funcidx("_wOnRconLoginAttempt") != -1)
	    return CallLocalFunction("_wOnRconLoginAttempt", "ssi", ip, password, success);

    return 1;
}

#if defined ALS_OnRconLoginAttempt
    #undef OnRconLoginAttempt
#else
    #define OnRconLoginAttempt _wOnRconLoginAttempt
#endif
public OnPlayerUpdate(playerid)
{
	//strcat(gHookName, "_@OnPlayerUpdate");

    if (funcidx("_@OnPlayerUpdate") != -1)
   		CallLocalFunction("_@OnPlayerUpdate", "i", playerid);

	if (funcidx("_wOnPlayerUpdate") != -1)
	    return CallLocalFunction("_wOnPlayerUpdate", "i", playerid);

    return 1;
}

#if defined ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define OnPlayerUpdate _wOnPlayerUpdate
#endif
public OnPlayerStreamIn(playerid, forplayerid)
{
	//strcat(gHookName, "_@OnRconLoginAttempt");

    if (funcidx("_@OnPlayerStreamIn") != -1)
   		CallLocalFunction("_@OnPlayerStreamIn", "ii", playerid, forplayerid);

	if (funcidx("_wOnPlayerStreamIn") != -1)
	    return CallLocalFunction("_wOnPlayerStreamIn", "ii", playerid, forplayerid);

    return 1;
}

#if defined ALS_OnPlayerStreamIn
    #undef OnPlayerStreamIn
#else
    #define OnPlayerStreamIn _wOnPlayerStreamIn
#endif
public OnPlayerStreamOut(playerid, forplayerid)
{
	//strcat(gHookName, "_@OnPlayerStreamOut");

    if (funcidx("_@OnPlayerStreamOut") != -1)
   		CallLocalFunction("_@OnPlayerStreamOut", "ii", playerid, forplayerid);

	if (funcidx("_wOnPlayerStreamOut") != -1)
	    return CallLocalFunction("_wOnPlayerStreamOut", "ii", playerid, forplayerid);

    return 1;
}

#if defined ALS_OnPlayerStreamOut
    #undef OnPlayerStreamOut
#else
    #define OnPlayerStreamOut _wOnPlayerStreamOut
#endif
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	//strcat(gHookName, "_@OnVehicleStreamIn");

    if (funcidx("_@OnVehicleStreamIn") != -1)
   		CallLocalFunction("_@OnVehicleStreamIn", "ii", vehicleid, forplayerid);

	if (funcidx("_wOnVehicleStreamIn") != -1)
	    return CallLocalFunction("_wOnVehicleStreamIn", "ii", vehicleid, forplayerid);

    return 1;
}

#if defined ALS_OnVehicleStreamIn
    #undef OnVehicleStreamIn
#else
    #define OnVehicleStreamIn _wOnVehicleStreamIn
#endif
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	//strcat(gHookName, "_@OnVehicleStreamOut");

    if (funcidx("_@OnVehicleStreamOut") != -1)
   		CallLocalFunction("_@OnVehicleStreamOut", "ii", vehicleid, forplayerid);

	if (funcidx("_wOnVehicleStreamOut") != -1)
	    return CallLocalFunction("_wOnVehicleStreamOut", "ii", vehicleid, forplayerid);

    return 1;
}

#if defined ALS_OnVehicleStreamOut
    #undef OnVehicleStreamOut
#else
    #define OnVehicleStreamOut _wOnVehicleStreamOut
#endif
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//strcat(gHookName, "_@OnDialogResponse");

    if (funcidx("_@OnDialogResponse") != -1)
   		CallLocalFunction("_@OnDialogResponse", "iiiis", playerid, dialogid, response, listitem, inputtext);

	if (funcidx("_wOnDialogResponse") != -1)
	    return CallLocalFunction("_wOnDialogResponse", "iiiis", playerid, dialogid, response, listitem, inputtext);

    return 1;
}

#if defined ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define OnDialogResponse _wOnDialogResponse
#endif
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	//strcat(gHookName, "_@OnPlayerTakeDamage");

    if (funcidx("_@OnPlayerTakeDamage") != -1)
   		CallLocalFunction("_@OnPlayerTakeDamage", "iifi", playerid, issuerid, amount, weaponid);

	if (funcidx("_wOnPlayerTakeDamage") != -1)
	    return CallLocalFunction("_wOnPlayerTakeDamage", "iifi", playerid, issuerid, amount, weaponid);

    return 1;
}

#if defined ALS_OnPlayerTakeDamage
    #undef OnPlayerTakeDamage
#else
    #define OnPlayerTakeDamage _wOnPlayerTakeDamage
#endif
public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	//strcat(gHookName, "_@OnPlayerGiveDamage");

    if (funcidx("_@OnPlayerGiveDamage") != -1)
   		CallLocalFunction("_@OnPlayerGiveDamage", "iifi", playerid, damagedid, amount, weaponid);

	if (funcidx("_wOnPlayerGiveDamage") != -1)
	    return CallLocalFunction("_wOnPlayerGiveDamage", "iifi", playerid, damagedid, amount, weaponid);

    return 1;
}

#if defined ALS_OnPlayerGiveDamage
    #undef OnPlayerGiveDamage
#else
    #define OnPlayerGiveDamage _wOnPlayerGiveDamage
#endif
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	//strcat(gHookName, "_@OnPlayerClickMap");

    if (funcidx("_@OnPlayerClickMap") != -1)
   		CallLocalFunction("_@OnPlayerClickMap", "ifff", playerid, fX, fY, fZ);

	if (funcidx("_wOnPlayerClickMap") != -1)
	    return CallLocalFunction("_wOnPlayerClickMap", "ifff", playerid, fX, fY, fZ);

    return 1;
}

#if defined ALS_OnPlayerClickMap
    #undef OnPlayerClickMap
#else
    #define OnPlayerClickMap _wOnPlayerClickMap
#endif
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//strcat(gHookName, "_@OnPlayerClickTextDraw");

    if (funcidx("_@OnPlayerClickTextDraw") != -1)
   		CallLocalFunction("_@OnPlayerClickTextDraw", "ii", playerid, _:clickedid);

	if (funcidx("_wOnPlayerClickTextDraw") != -1)
	    return CallLocalFunction("_wOnPlayerClickTextDraw", "ii", playerid, _:clickedid);

    return 1;
}

#if defined ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define OnPlayerClickTextDraw _wOnPlayerClickTextDraw
#endif
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	//strcat(gHookName, "_@OnPlayerClickPlayerTextDraw");

    if (funcidx("_@OnPlayerClickPlayerTextDraw") != -1)
   		CallLocalFunction("_@OnPlayerClickPlayerTextDraw", "ii", playerid, _:playertextid);

	if (funcidx("_wOnPlayerClickPlayerTextDraw") != -1)
	    return CallLocalFunction("_wOnPlayerClickPlayerTextDraw", "ii", playerid, _:playertextid);

    return 1;
}

#if defined ALS_OnPlayerClickPlayerTextDraw
    #undef OnPlayerClickPlayerTextDraw
#else
    #define OnPlayerClickPlayerTextDraw _wOnPlayerClickPlayerTextDraw
#endif
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	//strcat(gHookName, "_@OnPlayerClickPlayer");

    if (funcidx("_@OnPlayerClickPlayer") != -1)
   		CallLocalFunction("_@OnPlayerClickPlayer", "iii", playerid, clickedplayerid, source);

	if (funcidx("_wOnPlayerClickPlayer") != -1)
	    return CallLocalFunction("_wOnPlayerClickPlayer", "iii", playerid, clickedplayerid, source);

    return 1;
}

#if defined ALS_OnPlayerClickPlayer
    #undef OnPlayerClickPlayer
#else
    #define OnPlayerClickPlayer _wOnPlayerClickPlayer
#endif
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	//strcat(gHookName, "_@OnPlayerEditObject");

    if (funcidx("_@OnPlayerEditObject") != -1)
   		CallLocalFunction("_@OnPlayerEditObject", "iiiiffffff", playerid, playerobject, objectid, response, fX, fY, fZ, fRotX, fRotY, fRotZ);

	if (funcidx("_wOnPlayerEditObject") != -1)
	    return CallLocalFunction("_wOnPlayerEditObject", "iiiiffffff", playerid, playerobject, objectid, response, fX, fY, fZ, fRotX, fRotY, fRotZ);

    return 1;
}

#if defined ALS_OnPlayerEditObject
    #undef OnPlayerEditObject
#else
    #define OnPlayerEditObject _wOnPlayerEditObject
#endif
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	//strcat(gHookName, "_@OnPlayerEditAttachedObject");

    if (funcidx("_@OnPlayerEditAttachedObject") != -1)
   		CallLocalFunction("_@OnPlayerEditAttachedObject", "iiiiifffffffff", playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);

	if (funcidx("_wOnPlayerEditAttachedObject") != -1)
	    return CallLocalFunction("_wOnPlayerEditAttachedObject", "iiiiifffffffff", playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);

    return 1;
}

#if defined ALS_OnPlayerEditAttachedObject
    #undef OnPlayerEditAttachedObject
#else
    #define OnPlayerEditAttachedObject _wOnPlayerEditAttachedObject
#endif
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	//strcat(gHookName, "_@OnPlayerSelectObject");

    if (funcidx("_@OnPlayerSelectObject") != -1)
   		CallLocalFunction("_@OnPlayerSelectObject", "iiiifff", playerid, type, objectid, modelid, fX, fY, fZ);

	if (funcidx("_wOnPlayerSelectObject") != -1)
	    return CallLocalFunction("_wOnPlayerSelectObject", "iiiifff", playerid, type, objectid, modelid, fX, fY, fZ);

    return 1;
}

#if defined ALS_OnPlayerSelectObject
    #undef OnPlayerSelectObject
#else
    #define OnPlayerSelectObject _wOnPlayerSelectObject
#endif