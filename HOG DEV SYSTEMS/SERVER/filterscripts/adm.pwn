/*
 |INCLUDES|
*/
#include <a_samp>
#include <zcmd>
#include <sscanf2>
/*
 *****************************************************************************
*/
/*
 |MACROS|
*/
stock stringf[256];
#define SendClientMessageEx(%0,%1,%2,%3) format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
/*
 *****************************************************************************
*/
/*
 |VARIABLES|
*/
static
	bool:vehicleRadio[MAX_PLAYERS] = true;
/*
 *****************************************************************************
*/
/*
 |CALLBACKS NATIVE|
*/
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER && !vehicleRadio[playerid])
    {
        PlayAudioStreamForPlayer(playerid, "");
    }
    return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(!vehicleRadio[playerid]) PlayAudioStreamForPlayer(playerid, "");

    return 1;
}
/*
 *****************************************************************************
*/
/*
 |COMMANDS|
*/
CMD:isnpc(playerid, params[])
{
	SendClientMessageEx(playerid, -1, "%d %s", strval(params), (IsPlayerNPC(strval(params))) ? ("é um NPC") : ("não é um NPC"));

	return 1;
}
CMD:cam(playerid)
{
	SetPlayerInterior(playerid, 9);
	/*SetPlayerCameraPos(playerid, 315.745086,984.969299,1958.919067);
	SetPlayerCameraLookAt(playerid, 315.745086+1.0,984.969299+1.0,1958.919067+1.0);*/

	SetPlayerPos(playerid, 311.6683, 1004.9227, 1954.3143);

	SetPlayerCameraPos(playerid, 316.0638, 1043.2716, 1947.5927);
	SetPlayerCameraLookAt(playerid, 316.0855, 1042.2743, 1947.6384);

	return 1;
}
CMD:go(playerid, params[])
{
	if(isnull(params)) return 1;

	new interior, Float:pos[3];
	
	if(sscanf(params, "ip<,>fff", interior, pos[0], pos[1], pos[2]))
		return SendClientMessage(playerid, -1, "/go <int> <pos x> <pos y> <pos z>");

	SetPlayerInterior(playerid, interior);
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	return 1;
}
CMD:score(playerid, params[])
{
	if(isnull(params)) return 1;
	
	SetPlayerScore(playerid, strval(params));

	return 1;
}
CMD:arma(playerid, params[])
{
	if(isnull(params)) return 1;
	
	new weaponid = strval(params);

	GivePlayerWeapon(playerid, weaponid, 100);

	return 1;
}
CMD:tapa(playerid)
{
	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]+10);

	return 1;
}
CMD:vida(playerid, params[])
{
	if(isnull(params)) return SetPlayerHealth(playerid, Float:0x7F800000);

	new Float:value = floatstr(params);

	SetPlayerHealth(playerid, value);
	
	return 1;
}
CMD:cv(playerid, params[])
{
	if(isnull(params)) return 1;

	if(GetPlayerVehicleID(playerid) != 0) return 1;

	new id, Float:pos[4];

	id = strval(params);
	
	GetPlayerPos(playerid, pos[0],pos[1],pos[2]);

	CreateVehicle(id, pos[0],pos[1],pos[2], (GetPlayerFacingAngle(playerid, pos[3]), pos[3]), 0, 0, 0);

	return 1;
}

CMD:trazer(playerid, params[])
{
	if(isnull(params)) return 1;

	new Float:pos[3], id;

	id = strval(params);
	
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	
	SetPlayerPos(strval(params), pos[0], pos[1], pos[2]);
	SetPlayerInterior(id, GetPlayerInterior(playerid));
	return 1;
}

CMD:radio(playerid)
{
	vehicleRadio[playerid] = !vehicleRadio[playerid];

	if(!vehicleRadio[playerid]) PlayAudioStreamForPlayer(playerid, "");

	SendClientMessageEx(playerid, -1, "Rádio do veículo %s", (vehicleRadio[playerid]) ? ("ligada") : ("desligada"));

	return 1;
}

CMD:money(playerid)
{
	GivePlayerMoney(playerid, 20000);
	return 1;
}

CMD:ls(playerid)
{
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, 1400.83447, -2546.60962, 32.93296);
	return 1;
}