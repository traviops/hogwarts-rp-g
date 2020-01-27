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
	 * FIXES
	 *
	|
	 *
	 * HOOKS
	 *
	|
*/
/*
 * DEFINITIONS
 ******************************************************************************
 */
forward KickPlayer(playerid);

/*
 * VARIABLES
 ******************************************************************************
 */
/*static
	/// <summary> 
	///	Variável de controle da TextDraw utilizada para fixar bug das transparências.</summary>
	Text:textBugFix;*/

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
public OnPlayerConnect(playerid)
{
	#if defined fixes_OnPlayerConnect
		fixes_OnPlayerConnect(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		- mostra a TextDraw responsável por fixar o bug das transparências
	///		  ao jogador.
	/// </summary>

	if(IsPlayerNPC(playerid))
		return 1;

	FixShowTextDrawTransparency(playerid);

	return 1;
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect fixes_OnPlayerConnect
#if defined fixes_OnPlayerConnect
	forward fixes_OnPlayerConnect(playerid);
#endif*/

/*
 * MY CALLBACKS
 ******************************************************************************
 */
public KickPlayer(playerid)
	return Kick(playerid);

/*
 * FIXES
 ******************************************************************************
 */
/*
	TextDraw Transparency bug fix:
		A transparência de uma TextDraw muitas vezes não é mostrada ao jogador
		por motivo desconhecido. Como solução, basta criar uma TextDraw
		invisível e mostrar para o jogador ao conectar, e as TextDraws
		transparentes serão apresentadas normalmente.
*/
/*/// <summary>
/// Função responsável por criar a TextDraw Fix.
/// </summary>
/// <returns>Não retorna valores.</returns>
static FixCreateTextDrawTransparency()
{
	textBugFix = TextDrawCreate(0.0, 0.0, "fix");
	TextDrawLetterSize(textBugFix, 0.000000, 0.000000);
}

/// <summary>
/// Função responsável por mostrar a TextDraw Fix a um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
static FixShowTextDrawTransparency(playerid)
	TextDrawShowForPlayer(playerid, textBugFix);*/
//-----------------------------------------------------------------------------
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
	SetTimerEx("KickPlayer", 70, false, "i", playerid);
	return 1;
}
#if defined _ALS_Kick
	#undef Kick
#else
	#define _ALS_Kick
#endif
#define Kick KickEx

/*
 * FIXES
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