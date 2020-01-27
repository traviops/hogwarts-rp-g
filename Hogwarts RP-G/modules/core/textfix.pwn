/*
	Arquivo:
		modules/core/textdrawfix.pwn

	Descrição:
		- Este módulo é responsável pela correção de um bug específico da
		TextDraw.

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
	 * VARIABLES
	 *
	|
	 *
	 * NATIVE CALLBACKS
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
 * VARIABLES
 ******************************************************************************
 */
static
	/// <summary>
	///	Variável de controle da TextDraw utilizada para fixar bug das transparências.</summary>
	Text:textBugFix;

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined textdrawfix_OnGameModeInit
		textdrawfix_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicializa o módulo;
	///		- cria a TextDraw responsável por fixar o bug das transparências.
	/// </summary>

	ModuleInit("core/textfix.pwn");

	FixCreateTextDrawTransparency();

	return 1;
}

public OnPlayerConnect(playerid)
{
	#if defined textdrawfix_OnPlayerConnect
		textdrawfix_OnPlayerConnect(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		- se o jogador for um NPC: retorna 1;
	///		- mostra a TextDraw responsável por fixar o bug das transparências
	///		  ao jogador.
	/// </summary>

	if(IsPlayerNPC(playerid))
		return 1;

	FixShowTextDrawTransparency(playerid);

	return 1;
}

/*
 * FIXES
 ******************************************************************************
 */
/// <summary>
/// Função responsável por criar a TextDraw Fix.
/// A transparência de uma TextDraw muitas vezes não é mostrada ao jogador por
/// motivo desconhecido. Como solução, basta criar uma TextDraw invisível e
/// mostrar para o jogador ao conectar, e as TextDraws transparentes serão
/// apresentadas normalmente.
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
	TextDrawShowForPlayer(playerid, textBugFix);

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
#define OnGameModeInit textdrawfix_OnGameModeInit
#if defined textdrawfix_OnGameModeInit
	forward textdrawfix_OnGameModeInit();
#endif

/// <summary>
/// Hook da callback OnPlayerConnect.
/// </summary>
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect textdrawfix_OnPlayerConnect
#if defined textdrawfix_OnPlayerConnect
	forward textdrawfix_OnPlayerConnect(playerid);
#endif