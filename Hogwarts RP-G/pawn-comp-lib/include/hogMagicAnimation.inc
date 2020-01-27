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
forward	OutAnimationNPCFloat(npcid);
forward	AnimationNPCFloat(npcid, bool:step);
forward	AnimationPlayerFloat(playerid, step);
forward	OutAnimationPlayerFloat(playerid);
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

public OnPlayerDisconnect(playerid, reason)
{
	#if defined ma_OnPlayerDisconnect
		ma_OnPlayerDisconnect(playerid, reason);
	#endif

	ResetFloatConfiguration(playerid);

	return 1;
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect ma_OnPlayerDisconnect
#if defined ma_OnPlayerDisconnect
	forward ma_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerSpawn(playerid)
{
	#if defined ma_OnPlayerSpawn
		ma_OnPlayerSpawn(playerid);
	#endif

	LoadPlayerAnimations(playerid);
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

	if(IsPlayerNPC(playerid)) return 1;

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
public OutAnimationNPCFloat(npcid)
{
	ResetFloatConfiguration(npcid);

	FCNPC_ApplyAnimation(npcid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 0, 1);
}

public AnimationNPCFloat(npcid, bool:step)
{
	if(playerMagicAnimation[npcid][E_PLAYER_FLOATING])
	{
		static animIndex;

		FCNPC_GetAnimation(npcid, animIndex);

		if(animIndex != 372)
			FCNPC_SetAnimation(npcid, 372, 4.1, 0, 0, 0, 1, 0);

		FCNPC_SetVelocity(npcid, 0.0, 0.0, (step) ? (0.01) : (-0.01), true);

		if(playerMagicAnimation[npcid][E_PLAYER_REQUIRED_STOP])
		{
			if(playerMagicAnimation[npcid][E_PLAYER_FLOW_VALUE] <= -0.009)
			{
				playerMagicAnimation[npcid][E_PLAYER_REQUIRED_STOP] = playerMagicAnimation[npcid][E_PLAYER_FLOATING] = false;

				FCNPC_ApplyAnimation(npcid, "COP_AMBIENT", "Coplook_out", 4.1, 0, 0, 0, 1, 600);

				SetTimerEx("OutAnimationNPCFloat", 600, false, "i", npcid);
				return;
			}
		}
		
		SetTimerEx("AnimationNPCFloat", 1000, false, "ii", npcid, !step);
	}
}

public AnimationPlayerFloat(playerid, step)
{
	if(step >= 13) step = 0;

	if(!IsPlayerInAnyVehicle(playerid) && playerMagicAnimation[playerid][E_PLAYER_FLOATING])
	{
		if(playerMagicAnimation[playerid][E_PLAYER_AFK_CHECK] > 2)
		{
			if(step != 7) SetPlayerVelocity(playerid, 0.0, 0.0, 0.0);

			step = 7;

			goto call_again;
		}
		static animIndex;

		animIndex = GetPlayerAnimationIndex(playerid);

		if(!animIndex || animIndex == 1132 || animIndex == 1133)
			ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_in", 4.1, 0, 0, 0, 1, 0);

		SetPlayerVelocity(playerid, 0.0, 0.0, (step < 7) ? (0.045) : (-0.0007));

		if(playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP])
		{
			if(playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] <= -0.009)
			{
				playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP] = playerMagicAnimation[playerid][E_PLAYER_FLOATING] = false;

				ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_out", 4.1, 0, 0, 0, 1, 600);

				SetTimerEx("OutAnimationPlayerFloat", 600, false, "i", playerid);

				return;
			}
		}

		playerMagicAnimation[playerid][E_PLAYER_AFK_CHECK]++;

		call_again:
		
		SetTimerEx("AnimationPlayerFloat", 100, false, "ii", playerid, step + 1);
	}
}

public OutAnimationPlayerFloat(playerid)
{
	ResetFloatConfiguration(playerid);

	ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 0, 1, 1);
}
/*
 * FUNCTIONS
 ******************************************************************************
 */
stock StartFloatNPC(npcid)
{
	static Float:pos[3];

	ResetFloatConfiguration(npcid);

	playerMagicAnimation[npcid][E_PLAYER_FLOATING] = true;

	FCNPC_GetPosition(npcid, pos[0], pos[1], pos[2]);
	FCNPC_SetPosition(npcid, pos[0], pos[1], pos[2] + 0.5);

	SetTimerEx("AnimationNPCFloat", 1000, false, "ib", npcid, true);
}

stock StopFloatNPC(npcid)
	playerMagicAnimation[npcid][E_PLAYER_REQUIRED_STOP] = false;

stock StartFloatPlayer(playerid)
{
	ResetFloatConfiguration(playerid);

	playerMagicAnimation[playerid][E_PLAYER_FLOATING] = true;

	AnimationPlayerFloat(playerid, 0);
}

stock StopFloatPlayer(playerid)
	playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP] = true;

stock ResetFloatConfiguration(playerid)
{
	playerMagicAnimation[playerid][E_PLAYER_FLOATING] = playerMagicAnimation[playerid][E_PLAYER_REQUIRED_STOP] = false;
	playerMagicAnimation[playerid][E_PLAYER_FLOW_ADD] = true;
	playerMagicAnimation[playerid][E_PLAYER_FLOW_VALUE] = 0.0;
	playerMagicAnimation[playerid][E_PLAYER_AFK_CHECK] = 0;
}
//----------------------------------------------------------------
stock LoadPlayerAnimations(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
}

stock LoadNPCAnimations(npcid)
{
	FCNPC_ApplyAnimation(npcid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0);
	FCNPC_ApplyAnimation(npcid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0);
}
//---------------------------
stock StartMagicAnimation(playerid)
{
	if(playerMagicAnimation[playerid][E_PLAYER_FLOATING]) return false;

	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_in", 4.1, 0, 0, 0, 1, 0);

	StartFloatPlayer(playerid);

	return true;
}

stock StopMagicAnimation(playerid)
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