/*
	Arquivo:
		modules/core/textdrawcontrol.pwn

	Descrição:
		- Este módulo é direcionado ao controle das TextDraws globais e
		privadas.

	Última atualização:
		20/08/17

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
	 * HOOKS
	 *
	|
*/
/*
 * DEFINITIONS
 ******************************************************************************
 */
forward OnPlayerHideCursor(playerid, hovercolor, moduleCalled);

const
	
	/// <summary>
	///	Variável para armazenar o limite de textdraws globais.</summary>
	LIMIT_GLOBAL_TEXTDRAWS		= 2048,

	/// <summary>
	///	Variável para armazenar o tempo de espera para enviar informações sobre
	///	as textdraws ao console após o módulo iniciar.</summary>
	TIME_SEND_TEXTDRAWS_INFO	= 500;

/*
 * ENUMERATORS
 ******************************************************************************
 */
/// <summary>
///	Enumerador da variável 'textDrawData[E_TEXTDRAW_DATA]'.</summary>
enum E_TEXTDRAW_DATA
{
	E_TEXTDRAW_GLOBAL_COUNT,
	E_TEXTDRAW_PLAYER_COUNT
}

/// <summary>
///	Enumerador da variável 'playerTextDrawData[MAX_PLAYERS][E_PLAYER_TEXTDRAW_DATA]'.</summary>
enum E_PLAYER_TEXTDRAW_DATA
{
	E_TEXTDRAW_HOVERCOLOR,
	bool:E_TEXTDRAW_CURSOR_STATE,
	E_TEXTDRAW_CURSOR_MODULE_CALLED
}

/*
 * VARIABLES
 ******************************************************************************
 */
static

	/// <summary>
	///	Variável para armazenar o total de textdraws globais/privadas criadas.</summary>
	textDrawData[E_TEXTDRAW_DATA],

	/// <summary>
	///	Variável para controlar os atributos do cursor.</summary>
	playerTextDrawData[MAX_PLAYERS][E_PLAYER_TEXTDRAW_DATA];

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined textdrawcontrol_OnGameModeInit
		textdrawcontrol_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		> inicializa o módulo;
	/// </summary>

	ModuleInit("core/textdrawcontrol.pwn");
	return 1;
}

public OnPlayerConnect(playerid)
{
	#if defined textdrawcontrol_OnPlayerConnect
		textdrawcontrol_OnPlayerConnect(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		> reseta a variável de controle do cursor.
	/// </summary>

	playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_STATE] = false;
	playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_MODULE_CALLED] = INVALID_MODULE_ID;
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	#if defined tdcontrol_OnPlayerClickTextDraw
		tdcontrol_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		> se a textdraw clicada for inválida e cursor estiver ativo:
	///			|> chama a callback responsável por avisar quando o jogador tecla ESC.
	/// </summary>

	if(_:clickedid == INVALID_TEXT_DRAW && playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_STATE])
	{
		CallLocalFunction("OnPlayerHideCursor", "iii", playerid, playerTextDrawData[playerid][E_TEXTDRAW_HOVERCOLOR], playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_MODULE_CALLED]);
	}

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
/// Obtém o número total de textdraws globais criadas.
/// </summary>
/// <returns>Total de textdraws globais.</returns>
stock GetTotalGlobalTextDraws()
	return textDrawData[E_TEXTDRAW_GLOBAL_COUNT];

/// <summary>
/// Obtém o número total de textdraws privadas criadas.
/// </summary>
/// <returns>Total de textdraws privadas.</returns>
stock GetTotalPlayerTextDraws()
	return textDrawData[E_TEXTDRAW_PLAYER_COUNT];
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Cria uma textdraw e soma o número total de textdraws globais criadas.
/// </summary>
/// <param name="x">Posição X da textdraw.</param>
/// <param name="y">Posição Y da textdraw.</param>
/// <param name="text">Texto da textdraw.</param>
/// <returns>ID da textdraw criada.</returns>
Text:TextDrawCreateEx(Float:x, Float:y, text[])
{
	if(textDrawData[E_TEXTDRAW_GLOBAL_COUNT] >= MAX_TEXT_DRAWS)
		return Text:INVALID_TEXT_DRAW;

	new Text:textID;

	textDrawData[E_TEXTDRAW_GLOBAL_COUNT]++;

	textID = TextDrawCreate(x, y, text);

	return textID;
}

/// <summary>
/// Destrói uma textdraw específica e diminui o número total de textdraws
/// globais criadas.
/// </summary>
/// <param name="text">ID da textdraw.</param>
/// <returns>Não retorna valores específicos.</returns>
stock TextDrawDestroyEx(Text:text)
{
	textDrawData[E_TEXTDRAW_GLOBAL_COUNT]--;

	return TextDrawDestroy(text);
}
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Cria uma textdraw e soma o número total de textdraws privadas criadas.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="x">Posição X da textdraw.</param>
/// <param name="y">Posição Y da textdraw.</param>
/// <param name="text">Texto da textdraw.</param>
/// <returns>ID da textdraw criada.</returns>
PlayerText:CreatePlayerTextDrawEx(playerid, Float:x, Float:y, text[])
{
	if(textDrawData[E_TEXTDRAW_PLAYER_COUNT] >= MAX_PLAYER_TEXT_DRAWS)
		return PlayerText:INVALID_TEXT_DRAW;

	static PlayerText:playerTextID;

	textDrawData[E_TEXTDRAW_PLAYER_COUNT]++;

	playerTextID = CreatePlayerTextDraw(playerid, x, y, text);

	return playerTextID;
}

/// <summary>
/// Destrói uma textdraw específica e diminui o número total de textdraws
/// privadas criadas.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="text">ID da textdraw.</param>
/// <returns>Não retorna valores específicos.</returns>
stock PlayerTextDrawDestroyEx(playerid, PlayerText:text)
{
	textDrawData[E_TEXTDRAW_PLAYER_COUNT]--;

	return PlayerTextDrawDestroy(playerid, text);
}
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Mostra o cursor a um jogador específico e faz controle do estado do cursor.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="hovercolor">Cor RGBA da textdraw quando passar com o mouse.</param>
/// <returns>Não retorna valores específicos.</returns>
SelectTextDrawEx(playerid, hovercolor, modelCalled)
{
	playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_STATE] = true;
	playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_MODULE_CALLED] = modelCalled;

	return SelectTextDraw(playerid, hovercolor);
}

/// <summary>
/// Esconde o cursor de um jogador específico e faz controle do estado do
/// cursor.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores específicos.</returns>
CancelSelectTextDrawEx(playerid)
{
	playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_STATE] = false;
	playerTextDrawData[playerid][E_TEXTDRAW_CURSOR_MODULE_CALLED] = INVALID_MODULE_ID;

	return CancelSelectTextDraw(playerid);
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
#define OnGameModeInit textdrawcontrol_OnGameModeInit
#if defined textdrawcontrol_OnGameModeInit
	forward textdrawcontrol_OnGameModeInit();
#endif

/// <summary>
/// Hook da callback OnPlayerConnect.
/// </summary>
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect textdrawcontrol_OnPlayerConnect
#if defined textdrawcontrol_OnPlayerConnect
	forward textdrawcontrol_OnPlayerConnect(playerid);
#endif

/// <summary>
/// Hook da callback OnPlayerClickTextDraw.
/// </summary>
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw tdcontrol_OnPlayerClickTextDraw
#if defined tdcontrol_OnPlayerClickTextDraw
	forward tdcontrol_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Hook da função TextDrawCreate.
/// </summary>
#if defined _ALS_TextDrawCreate
	#undef TextDrawCreate
#else
	#define _ALS_TextDrawCreate
#endif
#define TextDrawCreate TextDrawCreateEx

/// <summary>
/// Hook da função TextDrawDestroy.
/// </summary>
#if defined _ALS_TextDrawDestroy
	#undef TextDrawDestroy
#else
	#define _ALS_TextDrawDestroy
#endif
#define TextDrawDestroy TextDrawDestroyEx

/// <summary>
/// Hook da função CreatePlayerTextDraw.
/// </summary>
#if defined _ALS_CreatePlayerTextDraw
	#undef CreatePlayerTextDraw
#else
	#define _ALS_CreatePlayerTextDraw
#endif
#define CreatePlayerTextDraw CreatePlayerTextDrawEx

/// <summary>
/// Hook da função PlayerTextDrawDestroy.
/// </summary>
#if defined _ALS_PlayerTextDrawDestroy
	#undef PlayerTextDrawDestroy
#else
	#define _ALS_PlayerTextDrawDestroy
#endif
#define PlayerTextDrawDestroy PlayerTextDrawDestroyEx

/// <summary>
/// Hook da função SelectTextDraw.
/// </summary>
#if defined _ALS_SelectTextDraw
	#undef SelectTextDraw
#else
	#define _ALS_SelectTextDraw
#endif
#define SelectTextDraw SelectTextDrawEx

/// <summary>
/// Hook da função CancelSelectTextDraw.
/// </summary>
#if defined _ALS_CancelSelectTextDraw
	#undef CancelSelectTextDraw
#else
	#define _ALS_CancelSelectTextDraw
#endif
#define CancelSelectTextDraw CancelSelectTextDrawEx