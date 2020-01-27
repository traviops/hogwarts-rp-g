/*
	Arquivo:
		modules/player/spawn.pwn

	Descrição:
		- Este módulo é direcionado ao spawn do jogador.

	Última atualização:
		11/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
		Renato "Misterix" Venancio)

	Esqueleto do código:
	|
	 *
	 * NATIVE CALLBACKS
	 *
	|
	 *
	 * FUNCTIONS
	 *
	|
	 *
	 * HOOKS
	 *
	|
*/
/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined spawn_OnGameModeInit
		spawn_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo.
	/// </summary>

	ModuleInit("player/spawn.pwn");
	return 1;
}

/*
 * FUNCTIONS
 ******************************************************************************
 */
/// <summary>
/// Seta o spawn de um jogador específico, com especificações.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="skinid">ID da skin.</param>
/// <param name="interiorid">ID do interior.</param>
/// <param name="posX">Posição X.</param>
/// <param name="posY">Posição Y.</param>
/// <param name="posZ">Posição Z.</param>
/// <param name="angle">Rotação do ângulo.</param>
/// <param name="teamid">ID do time.</param>
/// <returns>Não retorna valores.</returns>
stock SetPlayerToSpawn(playerid, skinid, interiorid, Float:posX, Float:posY, Float:posZ, Float:angle, teamid = NO_TEAM)
{
	SetPlayerInterior(playerid, interiorid);

	SetSpawnInfo(playerid, teamid, skinid, posX, posY, posZ, angle, 0, 0, 0, 0, 0, 0);

	SpawnPlayer(playerid);
}

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
#define OnGameModeInit spawn_OnGameModeInit
#if defined spawn_OnGameModeInit
	forward spawn_OnGameModeInit();
#endif