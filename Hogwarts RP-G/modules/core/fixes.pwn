/*
	Arquivo:
		modules/core/fixes.pwn

	Descrição:
		- Este módulo é responsável pela correção de diferentes bugs do SA-MP.

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
	 * DEFINITIONS
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
	 * FIXES
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
	#if defined fixes_OnGameModeInit
		fixes_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicializa o módulo.
	/// </summary>

	ModuleInit("core/fixes.pwn");

	return 1;
}

/*
 * MY CALLBACKS
 ******************************************************************************
 */
/// <summary>
/// Timer para kickar um jogador específico.
/// Intervalo: 70 ms.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Retorna sempre 1.</returns>
timer KickPlayer[70](playerid)
	return Kick(playerid);

/*
 * FIXES
 ******************************************************************************
 */
/*
	Kick Time fix:
		Ao kickar um jogador utilizando a função padrão Kick, mensagens cliente
		ou dialogs enviados antes da função não são mostrados ao jogador. Com
		isso, esse hook chama a função Kick 70ms após ser chamada.
*/
/// <summary>
/// Hook da função Kick que atrasa a mesma 70ms.
/// </summary>
/// <returns>Retorna sempre 1.</returns>
KickEx(playerid)
{
	defer KickPlayer(playerid);
	return 1;
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
#define OnGameModeInit fixes_OnGameModeInit
#if defined fixes_OnGameModeInit
	forward fixes_OnGameModeInit();
#endif
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Hook da função Kick.
/// </summary>
#if defined _ALS_Kick
	#undef Kick
#else
	#define _ALS_Kick
#endif
#define Kick KickEx