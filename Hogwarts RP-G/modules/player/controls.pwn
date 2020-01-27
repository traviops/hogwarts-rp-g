/*
	Arquivo:
		modules/player/controls.pwn

	Descrição:
		- Módulo responsável por controles importantes do jogador.

	Última atualização:
		15/01/18

	Copyright (C) 2017 Hogwarts RP/G
		(Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
		João "Vithinn" Vitor,
		Renato "Misterix" Venancio)

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
	 * COMMANDS
	 *
	|
	 *
	 * HOOKS
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

/*
 * ENUMERATORS
 ******************************************************************************
 */
enum E_PLAYER_CONTROLS
{
	bool:E_PLAYER_DEATH
}

/*
 * VARIABLES
 ******************************************************************************
 */
static
	
	/// <summary>
	///	Variável para controlar a morte do jogador morreu.</summary>
	playerControls[MAX_PLAYERS][E_PLAYER_CONTROLS];

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined controls_OnGameModeInit
		controls_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		> inicializa o módulo;
	///		> desativa o modo de correr PedAnims.
	/// </summary>

	ModuleInit("player/controls.pwn");
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	#if defined controls_OnPlayerDeath
		controls_OnPlayerDeath(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		> reseta o controle da morte do jogador.
	/// </summary>

	playerControls[playerid][E_PLAYER_DEATH] = false;
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	#if defined controls_OnPlayerRequestClass
		controls_OnPlayerRequestClass(playerid, classid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		> se o jogador for NPC:
	///			|> retorna 1.
	///		> se o jogador estiver morto:
	///			|> faz o controle da morte do jogador.
	/// </summary>

	if(IsPlayerNPC(playerid))
		return 1;

	if(playerControls[playerid][E_PLAYER_DEATH])
		playerControls[playerid][E_PLAYER_DEATH] = false;

	return 1;
}

/*
 * MY CALLBACKS
 ******************************************************************************
 */

/*
 * FUNCTIONS
 ******************************************************************************
 */
/// <summary>
/// Valida se um jogador está morto.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>True se estiver, False se não.</returns>
IsPlayerDeath(playerid)
	return playerControls[playerid][E_PLAYER_DEATH];

/*
 * COMMANDS
 ******************************************************************************
 */

/*
 * HOOKS
 ******************************************************************************
 */
/// <summary>
/// Hook da callback OnGameModeInit.
/// </summary>
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit controls_OnGameModeInit
#if defined controls_OnGameModeInit
	forward controls_OnGameModeInit();
#endif

/// <summary> 
///	Hook da callback OnPlayerDeath.</summary>
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath controls_OnPlayerDeath
#if defined controls_OnPlayerDeath
	forward controls_OnPlayerDeath(playerid, killerid, reason);
#endif

/// <summary>
/// Hook da callback OnPlayerRequestClass.
/// </summary>
#if defined _ALS_OnPlayerRequestClass
	#undef OnPlayerRequestClass
#else
	#define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass controls_OnPlayerRequestClass
#if defined controls_OnPlayerRequestClass
	forward controls_OnPlayerRequestClass(playerid, classid);
#endif