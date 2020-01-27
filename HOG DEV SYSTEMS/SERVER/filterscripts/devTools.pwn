/*
 |INCLUDES|
*/
#include <a_samp>
#include <zcmd>
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

/*
 *****************************************************************************
*/
/*
 |CALLBACKS NATIVE|
*/

/*
 *****************************************************************************
*/
/*
 |COMMANDS|
*/
CMD:tele(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, -1, "Use: /tele <id> (1. Castelo | 2. Estação KingCross | 3. Estação 9¾ | 4. Floresta Proibida)");
	
	new id = strval(params);

	switch(id)
	{
		case 1:
		{
			SetPlayerInterior(playerid, 0);
		    SetPlayerPos(playerid, -459.6759, -6783.8613, 23.0089);
		    SendClientMessage(playerid, -1, "|{EDD100}Hogwarts Principal (Castelo){FFFFFF}|");
		}
		case 2:
		{
			SetPlayerInterior(playerid, 1);
		    SetPlayerPos(playerid, 7791.47, 1684.39, 22.73);
		    SetPlayerFacingAngle(playerid, 90.0);
		    SendClientMessage(playerid, -1, "|{EDD100}Estação KingCross{FFFFFF}|");
		}
		case 3:
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, -509.6036,-1210.0787,42.5593);
			SetPlayerFacingAngle(playerid, 50.0);
		    SendClientMessage(playerid, -1, "|{EDD100}Estação 9¾{FFFFFF}|");
		}
		case 4:
		{
			SetPlayerPos(playerid, 232.3885, 8892.7344, 52.2921);
		    SetPlayerFacingAngle(playerid, 215.5679);
		    SetPlayerInterior(playerid, 0);
		    SendClientMessage(playerid, -1, "|{EDD100}Floresta Proibida{FFFFFF}|");
		}
		default:
			return SendClientMessage(playerid, -1, "Use: /tele <id> (1. Castelo | 2. Estação KingCross | 3. Estação 9¾ | 4. Floresta Proibida)");
	}

	return 1;
}

CMD:ir(playerid, params[])
{
	new id, Float:pos[3];

	id = strval(params);

	if(!IsPlayerConnected(id)) return 1;

	GetPlayerPos(id, pos[0], pos[1], pos[2]);
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	return 1;
}

CMD:int(playerid, params[])
{
	SetPlayerInterior(playerid, strval(params));

	return 1;
}

CMD:pos(playerid)
{
	SetPlayerPos(playerid, 1223.6770,-1814.7300,16.5938);

	return 1;
}