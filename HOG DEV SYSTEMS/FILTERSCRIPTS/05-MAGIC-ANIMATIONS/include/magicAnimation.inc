/*
	|
	 *
	 * INCLUDES
	 *
	|
	 *
	 * DEFINES
	 *
	|
	 *
	 * VARIABLES
	 *
	|
	 *
	 * HOOK NATIVE CALLBACKS
	 *
	|
	 *
	 * MY CALLBACKS
	 *
	|
	 *
	 * FUNCTIONS
	 *
	|
	 *
	 * COMPLEMENTS
	 *
	|
	 *
	 * INC FUNCTIONS
	 *
	|
*/
//#include <hook>//hook:
/*
 *****************************************************************************
 */
#if !defined call
	#define call:%1(%2) forward %1(%2); public %1(%2)
#endif
#define SendClientMessageEx(%0,%1,%2,%3) static stringf[256]; format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
/*
 *****************************************************************************
 */
static 
	bool:floatingPlayer[MAX_PLAYERS],
	bool:requiredStopPlayer[MAX_PLAYERS];
/*
 *****************************************************************************
 */
public OnFilterScriptInit()
{
	#if defined h_OnFilterScriptInit
        h_OnFilterScriptInit();
    #endif

	print("\n-----------------------------------------");
	print("      [INC] Magic Animation loaded");
	print("-----------------------------------------\n");

	return 1;
}
#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit h_OnFilterScriptInit
#if defined h_OnFilterScriptInit
    forward h_OnFilterScriptInit();
#endif

public OnPlayerConnect(playerid)
{
	#if defined h_OnPlayerConnect
        h_OnPlayerConnect(playerid);
    #endif

	ResetFloatConfiguration(playerid);

	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect h_OnPlayerConnect
#if defined h_OnPlayerConnect
    forward h_OnPlayerConnect(playerid);
#endif
/*public OnPlayerSpawn(playerid)
{
	#if defined h_OnPlayerSpawn
        h_OnPlayerSpawn(playerid);
    #endif

	LoadAnimations(playerid);
    
	return 1;
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn h_OnPlayerSpawn
#if defined h_OnPlayerSpawn
    forward h_OnPlayerSpawn(playerid);
#endif*/
/*
 *****************************************************************************
 */
call:AnimationPlayerFloat(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid) && floatingPlayer[playerid])
	{
		static 
			Float:flow[MAX_PLAYERS],
			bool:add[MAX_PLAYERS] = true;

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

		if(requiredStopPlayer[playerid])
		{
			if(flow[playerid] <= -0.009)
			{
				requiredStopPlayer[playerid] = false;

				ApplyAnimation(playerid, #COP_AMBIENT, #Coplook_out, 4.1, 0, 0, 0, 1, 600);

				SetTimerEx("OutAnimationPlayerFloat", 600, false, "i", playerid);

				return;
			}
		}
        
		SetTimerEx("AnimationPlayerFloat", 100, false, "i", playerid);
	}
}

call:OutAnimationPlayerFloat(playerid)
{
	ResetFloatConfiguration(playerid);

	ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 0, 1, 1);
}
/*
 *****************************************************************************
 */
ResetFloatConfiguration(playerid)
{
	floatingPlayer[playerid] = requiredStopPlayer[playerid] = false;
}

StartFloatPlayer(playerid)
{
	ResetFloatConfiguration(playerid);

	floatingPlayer[playerid] = true;

	AnimationPlayerFloat(playerid);
}

StopFloatPlayer(playerid) requiredStopPlayer[playerid] = true;
/*
 *****************************************************************************
 */
MA_LoadAnimations(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
}
/*
 *****************************************************************************
 */
StartMagicAnimation(playerid)
{
	if(floatingPlayer[playerid]) return false;

	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_in", 4.1, 0, 0, 0, 1, 0);

	StartFloatPlayer(playerid);

	return true;
}
StopMagicAnimation(playerid)
{
	if(!floatingPlayer[playerid]) return false;
	
	StopFloatPlayer(playerid);

	return true;
}