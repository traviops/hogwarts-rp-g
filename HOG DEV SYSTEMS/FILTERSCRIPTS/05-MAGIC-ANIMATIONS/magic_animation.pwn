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
	 * NATIVE CALLBACKS
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
	 * COMMANDS
	 *
	|
*/
#include <a_samp>
#include <zcmd>
/*
 *****************************************************************************
 */
#define call:%0(%1) forward %0(%1); public %0(%1)
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
	print("\n-----------------------------------------");
	print("      [HOG] Magic Animation loaded");
	print("-----------------------------------------\n");

	return 1;
}

public OnPlayerSpawn(playerid)
{
	LoadAnimations(playerid);
    
	return 1;
}
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
LoadAnimations(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
}
/*
 *****************************************************************************
 */
CMD:float(playerid)
{
	if(floatingPlayer[playerid])
	{
		StopFloatPlayer(playerid);
		return 1;
	}
	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_in", 4.1, 0, 0, 0, 1, 0);

	StartFloatPlayer(playerid);
	return 1;
}