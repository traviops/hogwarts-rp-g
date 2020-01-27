/*
	Projeto(Projeto_tradução)
		- Descrição.

		Versão: 1.0.0
		Última atualização: 00/00/00

	Copyright (C) 2017 Hogwarts RP/G
		(Bruno "Bruno13" Travi,
		Adejair "Adejair_Junior" Júnior,
		Renato "Misterix" Venancio)

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Esqueleto do código:
	|
	 *
	 * INCLUDES
	 *
	|
	 *
	 * DEFINITIONS
	 *
	|
	 *
	 * ENUMERATORS
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
/*
 * INCLUDES
 ******************************************************************************
 */

/*
 * DEFINITIONS
 ******************************************************************************
 */
#if !defined SendClientMessageEx
	#define SendClientMessageEx(%0,%1,%2,%3) format(stringF, sizeof(stringF),%2,%3) && SendClientMessage(%0, %1, stringF)//ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[]) 
#endif

#if !defined call
	#define call:%0(%1) forward %0(%1); public %0(%1)
#endif
/*
 * ENUMERATORS
 ******************************************************************************
 */
enum E_PLAYER_MAGIC_ANIMATION
{
	E_PLAYER_AFK_CHECK,
	bool:E_PLAYER_FLOATING,
	bool:E_PLAYER_REQUIRED_STOP,
	bool:E_PLAYER_FLOW_ADD,
	Float:E_PLAYER_FLOW_VALUE
}
/*
 * VARIABLES
 ******************************************************************************
 */
static
	playerMagicAnimation[MAX_PLAYERS][E_PLAYER_MAGIC_ANIMATION];
/*
 * HOOKS
 ******************************************************************************
 */
public OnFilterScriptInit()
{
	#if defined ma_OnFilterScriptInit
        ma_OnFilterScriptInit();
    #endif

	print("    > [inc] magicAnimation.inc loaded\n");

	return 1;
}
#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit ma_OnFilterScriptInit
#if defined ma_OnFilterScriptInit
    forward ma_OnFilterScriptInit();
#endif

public OnPlayerConnect(playerid)
{
	#if defined ma_OnPlayerConnect
        ma_OnPlayerConnect(playerid);
    #endif

	ResetFloatConfiguration(playerid);

	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect ma_OnPlayerConnect
#if defined ma_OnPlayerConnect
    forward ma_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn(playerid)
{
	#if defined ma_OnPlayerSpawn
        ma_OnPlayerSpawn(playerid);
    #endif

	MALoadAnimations(playerid);
	return 1;
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn ma_OnPlayerSpawn
#if defined ma_OnPlayerSpawn
    forward ma_OnPlayerSpawn(playerid);
#endif

public OnPlayerUpdate(playerid)
{
	#if defined ma_OnPlayerUpdate
        ma_OnPlayerUpdate(playerid);
    #endif

	if(playerMagicAnimation[playerid][E_PLAYER_FLOATING])
		playerMagicAnimation[playerid][E_PLAYER_AFK_CHECK] = 0;
	
	return 1;
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate ma_OnPlayerUpdate
#if defined ma_OnPlayerUpdate
    forward ma_OnPlayerUpdate(playerid);
#endif
/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */

/*
 * MY CALLBACKS
 ******************************************************************************
 */
call:AnimationPlayerFloat(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid) && playerMagicAnimation[playerid][E_PLAYER_FLOATING])
	{
		if(playerMagicAnimation[playerid][E_PLAYER_AFK_CHECK] != 0) goto call_again;

		if(playerMagicAnimation[playerid][E_PLAYER_FLOW_ADD])
		{
			playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] += 0.01;

			if(playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] >= 0.05) playerMagicAnimation[playerid][E_PLAYER_FLOW_ADD] = false;
		}
		else
		{
			playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] -= 0.01;
				    
			if(playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] <= -0.01) playerMagicAnimation[playerid][E_PLAYER_FLOW_ADD] = true;
		}

		SetPlayerVelocity(playerid, 0.0, 0.0, playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE]);

		if(playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP])
		{
			if(playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] <= -0.009)
			{
				playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP] = false;

				ApplyAnimation(playerid, #COP_AMBIENT, #Coplook_out, 4.1, 0, 0, 0, 1, 600);

				SetTimerEx("OutAnimationPlayerFloat", 600, false, "i", playerid);

				return;
			}
		}

		playerMagicAnimation[playerid][E_PLAYER_AFK_CHECK]++;

		call_again:
        
		SetTimerEx("AnimationPlayerFloat", 100, false, "i", playerid);
	}
}

call:OutAnimationPlayerFloat(playerid)
{
	ResetFloatConfiguration(playerid);

	ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 0, 1, 1);
}
/*
 * FUNCTIONS
 ******************************************************************************
 */
ResetFloatConfiguration(playerid)
{
	playerMagicAnimation[playerid][E_PLAYER_FLOATING] = playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP] = false;
	playerMagicAnimation[playerid][E_PLAYER_FLOW_ADD] = true;
	playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] = 0.0;
}

StartFloatPlayer(playerid)
{
	ResetFloatConfiguration(playerid);

	playerMagicAnimation[playerid][E_PLAYER_FLOATING] = true;

	AnimationPlayerFloat(playerid);
}

StopFloatPlayer(playerid) playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP] = true;
//-----------------------------------------------------------------------------
MALoadAnimations(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
}
//-----------------------------------------------------------------------------
StartMagicAnimation(playerid)
{
	if(playerMagicAnimation[playerid][E_PLAYER_FLOATING]) return false;

	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_in", 4.1, 0, 0, 0, 1, 0);

	StartFloatPlayer(playerid);

	return true;
}

StopMagicAnimation(playerid)
{
	if(!playerMagicAnimation[playerid][E_PLAYER_FLOATING]) return false;
	
	StopFloatPlayer(playerid);

	return true;
}
/*
 * COMPLEMENTS
 ******************************************************************************
 */

/*
 * COMMANDS
 ******************************************************************************
 */