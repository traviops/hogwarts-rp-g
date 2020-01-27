#include <a_samp>
#include <zcmd>
#include <mapandreas>
/*----------------------------------------------------------------------------*/
/*
	{DEFINES/MACROS}
*/
#define call::%0(%1) forward %0(%1); public %0(%1)
#define SendClientMessageEx(%0,%1,%2,%3) static stringf[256]; format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
//-------------
#define MAX_BROOM_TYPES				3
//-------------
#define INVALID_BROOM_TYPE			-1
//-------------
#define BROOM_ATTACH_INDEX_LEGS		2
#define BROOM_ATTACH_INDEX_HANDS	2
#define BROOM_ATTACH_INDEX_KEPT     3
/*----------------------------------------------------------------------------*/
/*
	{ENUMERATORS}
*/
enum attachData
{
	a_index,
	a_modelid,
	a_bone,
	Float:a_fOffsetX,
	Float:a_fOffsetY,
	Float:a_fOffsetZ,
	Float:a_fRotX,
	Float:a_fRotY,
	Float:a_fRotZ,
	Float:a_fScaleX,
	Float:a_fScaleY,
	Float:a_fScaleZ,
	a_matcolor1,
	a_matcolor2
}
enum broomData
{
	bool:b_HAVE,
	bool:b_IN_HANDS,
	bool:b_FLYING,
	b_TYPE,
	Float:b_LIFE[2]
}
/*----------------------------------------------------------------------------*/
/*
	{ARRAYS}
*/
static
	broomAttachmentLegs[MAX_BROOM_TYPES][attachData] = {
		{BROOM_ATTACH_INDEX_LEGS, 1778, 1, -0.523967, -0.076321, -0.319795, 282.881927, 30.137561, 350.511016, 1.000000, 1.000000, 1.000000, 0, 0},
		{BROOM_ATTACH_INDEX_LEGS, 18890, 1, 0.083882, 0.548517, 0.009489, 97.366943, 136.426239, 267.838562, 1.000000, 1.000000, 1.000000, 0, 0},
		{BROOM_ATTACH_INDEX_LEGS, 2712, 1, -0.227535, 0.441837, 0.063686, 285.642974, 30.389324, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0}
	},

	broomAttachmentHands[MAX_BROOM_TYPES][attachData] = {
		{BROOM_ATTACH_INDEX_HANDS, 1778, 5, 0.029648, 0.424844, 0.521361, 161.054992, 11.292262, 167.497879, 1.000000, 1.000000, 1.000000, 0, 0},
		{BROOM_ATTACH_INDEX_HANDS, 18890, 5, 0.040211, -0.072556, -0.201894, 335.325897, 169.472976, 84.052803, 1.000000, 1.000000, 1.000000, 0, 0},
		{BROOM_ATTACH_INDEX_HANDS, 2712, 5, 0.184623, 0.054565, 0.143104, 139.489166, 21.161138, 190.139938, 1.000000, 1.000000, 1.000000, 0, 0}
	},

	broomAttachmentKept[MAX_BROOM_TYPES][attachData] = {
		{BROOM_ATTACH_INDEX_KEPT, 1778, 1, -0.621719, 0.071882, -0.254663, 6.577212, 72.621978, 355.507751, 1.000000, 1.000000, 1.000000, 0, 0},
		{BROOM_ATTACH_INDEX_KEPT, 18890, 1, 0.256874, -0.203487, -0.154861, 355.492279, 88.426437, 4.233493, 1.000000, 1.000000, 1.000000, 0, 0},
		{BROOM_ATTACH_INDEX_KEPT, 2712, 1, -0.076811, -0.216330, -0.229380, 107.010902, 71.767234, 349.938842, 1.000000, 1.000000, 1.000000, 0, 0}
	},
	
	Float:broomPower[MAX_BROOM_TYPES][1] = {
		{0.2},
		{0.4},
		{0.6}
	},
/*----------------------------------------------------------------------------*/
/*
	{VARIABLES}
*/
	broomPlayer[MAX_PLAYERS][broomData],

	i;
/*----------------------------------------------------------------------------*/
/*
	{CALLBACKS}
*/
public OnFilterScriptInit()
{
    MapAndreas_Init(MAP_ANDREAS_MODE_FULL);
    
	print("\n--------------------------------------");
	print("      [HOG] Broom System loaded");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
    for(i = 0; broomData:i < broomData; i++)
	{
		broomPlayer[playerid][broomData:i] = 0;
	}
	
	for(i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
 	{
  		RemovePlayerAttachedObject(playerid, i);
  	}
  	
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_WALK && broomPlayer[playerid][b_IN_HANDS])
    {
        if((broomPlayer[playerid][b_FLYING] = !broomPlayer[playerid][b_FLYING]))
		{
			static type;

			type = broomPlayer[playerid][b_TYPE];

			if(type == INVALID_BROOM_TYPE) return 1;
			
			GetPlayerHealth(playerid, broomPlayer[playerid][b_LIFE][0]);
	  		GetPlayerArmour(playerid, broomPlayer[playerid][b_LIFE][1]);
			
			ApplyAnimation(playerid,"PED","SEAT_idle",1.0,1,0,0,0,0);
			
            SetPlayerAttachedObject(playerid, broomAttachmentLegs[type][a_index], broomAttachmentLegs[type][a_modelid],
				broomAttachmentLegs[type][a_bone], broomAttachmentLegs[type][a_fOffsetX],
				broomAttachmentLegs[type][a_fOffsetY], broomAttachmentLegs[type][a_fOffsetZ],
				broomAttachmentLegs[type][a_fRotX], broomAttachmentLegs[type][a_fRotY],
				broomAttachmentLegs[type][a_fRotZ], broomAttachmentLegs[type][a_fScaleX],
				broomAttachmentLegs[type][a_fScaleY], broomAttachmentLegs[type][a_fScaleZ],
				broomAttachmentLegs[type][a_matcolor1], broomAttachmentLegs[type][a_matcolor2]);

			SetPlayerHealth(playerid, 1000000000.0);
			
			SetTimerEx("FlyBroom", 100, false, "i", playerid);
		}
	}

	return 1;
}
/*----------------------------------------------------------------------------*/
/*
	{MY CALLBACKS}
*/
call::FlyBroom(playerid)
{
    if(!broomPlayer[playerid][b_FLYING])
    {
    	StopBroom(playerid);
    	return;
    }

	if(broomPlayer[playerid][b_FLYING])
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
			new key, ud, lr, Float:x[2], Float:y[2], Float:z;
			static Float:flow[MAX_PLAYERS], bool:add[MAX_PLAYERS] = true;

			GetPlayerKeys(playerid, key, ud, lr);
			GetPlayerVelocity(playerid, x[0], y[0], z);

			if(ud == KEY_UP)
			{
				GetPlayerCameraPos(playerid, x[0], y[0], z);
				GetPlayerCameraFrontVector(playerid, x[1], y[1], z);

				SetPlayerRotCamPos(playerid, x[0] + x[1], y[0] + y[1]);

		    	ApplyAnimation(playerid,"PED","SEAT_idle",1.0,1,0,0,0,0);
		    	
				new Float:value = broomPower[broomPlayer[playerid][b_TYPE]][0];
				
				SetPlayerVelocity(playerid, x[1]*value, y[1]*value, z);
				
				flow[playerid] = 0.0;
				add[playerid] = true;
			}
   			else if(key == KEY_SPRINT)
			{
				SetPlayerVelocity(playerid, 0.0, 0.0, 4.0);
				flow[playerid] = 0.0;
				add[playerid] = true;
			}
			else if(key == KEY_JUMP)
			{
				SetPlayerVelocity(playerid, 0.0, 0.0, -0.1);
				flow[playerid] = 0.0;
				add[playerid] = true;
			}
  			else
			{
				/*REMOVIDO 'MapAndreas':
			    new Float:other_y;
			    
			    
				GetPlayerPos(playerid, x[0], y[0], z);
				MapAndreas_FindZ_For2DCoord(x[0], y[0], other_y);
			
			    if(other_y-1.5 < z < other_y+1.5) goto end;*/
			    
			    if(add[playerid])
				{
					flow[playerid] += 0.01;

					if(flow[playerid] >= 0.05) add[playerid] = false;
				}
				else
				{
				    flow[playerid] -= 0.01;
				    
				    if(flow[playerid] <= -0.01) add[playerid] = true;
				}

				SetPlayerVelocity(playerid, 0.0, 0.0, flow[playerid]);
			}
		}
		//end: - REMOVIDO 'MapAndreas'
        
		SetTimerEx("FlyBroom", 100, false, "i", playerid);
	}
}

call::StopBroom(playerid)
{
    RemovePlayerAttachedObject(playerid, BROOM_ATTACH_INDEX_LEGS);

	static type;

	type = broomPlayer[playerid][b_TYPE];
	
	SetPlayerAttachedObject(playerid, broomAttachmentHands[type][a_index], broomAttachmentHands[type][a_modelid],
		broomAttachmentHands[type][a_bone], broomAttachmentHands[type][a_fOffsetX],
		broomAttachmentHands[type][a_fOffsetY], broomAttachmentHands[type][a_fOffsetZ],
		broomAttachmentHands[type][a_fRotX], broomAttachmentHands[type][a_fRotY],
		broomAttachmentHands[type][a_fRotZ], broomAttachmentHands[type][a_fScaleX],
		broomAttachmentHands[type][a_fScaleY], broomAttachmentHands[type][a_fScaleZ],
		broomAttachmentHands[type][a_matcolor1], broomAttachmentHands[type][a_matcolor2]);
	
	ClearAnimations(playerid);
	
    SetPlayerHealth(playerid, broomPlayer[playerid][b_LIFE][0]);
    SetPlayerArmour(playerid, broomPlayer[playerid][b_LIFE][1]);
}
/*----------------------------------------------------------------------------*/
/*
	{COMPLEMENTS}
*/
SetPlayerRotCamPos(playerid, Float:X, Float:Y)//creator: desconhecido :/
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return _:0.0;

	GetPlayerPos(playerid, pX, pY, pZ);

	if(Y > pY) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

 	return _:ang;
}
/*----------------------------------------------------------------------------*/
/*
	{COMMANDS}
*/
CMD:take(playerid)
{
    if(!broomPlayer[playerid][b_HAVE]) return SendClientMessage(playerid, -1, "|{CD5C5C}ERRO{FFFFFF}| Você não possui uma vassoura!");

    if(broomPlayer[playerid][b_FLYING]) return SendClientMessage(playerid, -1, "|{CD5C5C}ERRO{FFFFFF}| Pare de voar para guardar sua vassoura!");


	if(broomPlayer[playerid][b_IN_HANDS])
    {
        RemovePlayerAttachedObject(playerid, BROOM_ATTACH_INDEX_HANDS);

		static type;

		type = broomPlayer[playerid][b_TYPE];
		
		SetPlayerAttachedObject(playerid, broomAttachmentKept[type][a_index], broomAttachmentKept[type][a_modelid],
			broomAttachmentKept[type][a_bone], broomAttachmentKept[type][a_fOffsetX],
			broomAttachmentKept[type][a_fOffsetY], broomAttachmentKept[type][a_fOffsetZ],
			broomAttachmentKept[type][a_fRotX], broomAttachmentKept[type][a_fRotY],
			broomAttachmentKept[type][a_fRotZ], broomAttachmentKept[type][a_fScaleX],
			broomAttachmentKept[type][a_fScaleY], broomAttachmentKept[type][a_fScaleZ],
			broomAttachmentKept[type][a_matcolor1], broomAttachmentKept[type][a_matcolor2]);
		
		broomPlayer[playerid][b_IN_HANDS] = false;
		return 1;
	}

	RemovePlayerAttachedObject(playerid, BROOM_ATTACH_INDEX_KEPT);//remover vassoura lado

	static type;

	type = broomPlayer[playerid][b_TYPE];
	
	SetPlayerAttachedObject(playerid, broomAttachmentHands[type][a_index], broomAttachmentHands[type][a_modelid],
		broomAttachmentHands[type][a_bone], broomAttachmentHands[type][a_fOffsetX],
		broomAttachmentHands[type][a_fOffsetY], broomAttachmentHands[type][a_fOffsetZ],
		broomAttachmentHands[type][a_fRotX], broomAttachmentHands[type][a_fRotY],
		broomAttachmentHands[type][a_fRotZ], broomAttachmentHands[type][a_fScaleX],
		broomAttachmentHands[type][a_fScaleY], broomAttachmentHands[type][a_fScaleZ],
		broomAttachmentHands[type][a_matcolor1], broomAttachmentHands[type][a_matcolor2]);

    broomPlayer[playerid][b_IN_HANDS] = true;
    
	return 1;
}

CMD:broom(playerid, params[])
{
	static broom_id;

	broom_id = strval(params);

	if(0 > broom_id > 2 || !strlen(params)) return SendClientMessage(playerid, -1, "|{CD5C5C}ERRO{AFAFAF}| Use ids entre 0 e 2");

    broomPlayer[playerid][b_HAVE] = true;
	broomPlayer[playerid][b_TYPE] = broom_id;
	
	if(broomPlayer[playerid][b_FLYING])
	{
	    SetPlayerAttachedObject(playerid, broomAttachmentLegs[broom_id][a_index], broomAttachmentLegs[broom_id][a_modelid],
			broomAttachmentLegs[broom_id][a_bone], broomAttachmentLegs[broom_id][a_fOffsetX],
			broomAttachmentLegs[broom_id][a_fOffsetY], broomAttachmentLegs[broom_id][a_fOffsetZ],
			broomAttachmentLegs[broom_id][a_fRotX], broomAttachmentLegs[broom_id][a_fRotY],
			broomAttachmentLegs[broom_id][a_fRotZ], broomAttachmentLegs[broom_id][a_fScaleX],
			broomAttachmentLegs[broom_id][a_fScaleY], broomAttachmentLegs[broom_id][a_fScaleZ],
			broomAttachmentLegs[broom_id][a_matcolor1], broomAttachmentLegs[broom_id][a_matcolor2]);
	}
	else if(broomPlayer[playerid][b_IN_HANDS])
	{
		SetPlayerAttachedObject(playerid, broomAttachmentHands[broom_id][a_index], broomAttachmentHands[broom_id][a_modelid],
			broomAttachmentHands[broom_id][a_bone], broomAttachmentHands[broom_id][a_fOffsetX],
			broomAttachmentHands[broom_id][a_fOffsetY], broomAttachmentHands[broom_id][a_fOffsetZ],
			broomAttachmentHands[broom_id][a_fRotX], broomAttachmentHands[broom_id][a_fRotY],
			broomAttachmentHands[broom_id][a_fRotZ], broomAttachmentHands[broom_id][a_fScaleX],
			broomAttachmentHands[broom_id][a_fScaleY], broomAttachmentHands[broom_id][a_fScaleZ],
			broomAttachmentHands[broom_id][a_matcolor1], broomAttachmentHands[broom_id][a_matcolor2]);
	}
	else if(!broomPlayer[playerid][b_IN_HANDS] && !broomPlayer[playerid][b_FLYING])
	{
		SetPlayerAttachedObject(playerid, broomAttachmentKept[broom_id][a_index], broomAttachmentKept[broom_id][a_modelid],
			broomAttachmentKept[broom_id][a_bone], broomAttachmentKept[broom_id][a_fOffsetX],
			broomAttachmentKept[broom_id][a_fOffsetY], broomAttachmentKept[broom_id][a_fOffsetZ],
			broomAttachmentKept[broom_id][a_fRotX], broomAttachmentKept[broom_id][a_fRotY],
			broomAttachmentKept[broom_id][a_fRotZ], broomAttachmentKept[broom_id][a_fScaleX],
			broomAttachmentKept[broom_id][a_fScaleY], broomAttachmentKept[broom_id][a_fScaleZ],
			broomAttachmentKept[broom_id][a_matcolor1], broomAttachmentKept[broom_id][a_matcolor2]);
	}

	return 1;
}
