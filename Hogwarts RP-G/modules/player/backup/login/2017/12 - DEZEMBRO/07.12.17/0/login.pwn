/*
	Arquivo:
		modules/player/login.pwn

	Descrição:
		- Este módulo é direcionado ao login do jogador. Trabalha com uma tela
		de login em TextDraws, com botões Registrar, Entrar, Sobre e Versão.

	Última atualização:
		08/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
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
*/
/*
 * INCLUDES
 ******************************************************************************
 */
//#include <YSI\y_hooks>
#include <FCNPC>
#include <magicanimation>

/*
 * DEFINITIONS
 ******************************************************************************
 */
#define NPC_LOGIN_SCENARIO_NAME "NPC_LOGIN_CENARIO"

forward	ShowTextDrawsLoginScreen(playerid, tape);
forward CheckNameRegisteredResponse(playerid, name[]);

const

	SCENARIO_WEATHER		= 78,
	NPC_LOGIN_SCENARIO_SKIN	= 171,

	LOGIN_MENU_SELECTOR_COLOR = (0x757575FF),

	LOBBY_WEATHER = 78,

	LOGIN_VIRTUAL_WORLD = 99,

	MAX_PASSWORD_SIZE	= 20,
	MAX_EMAIL_SIZE		= 64,
	MAX_LOGIN_ATTEMPTS	= 3,

	RESEND_MAIL_TIME	= 30,

	MENU_NONE				= -1,
	MENU_HOME				= 0,
	MENU_LOGIN				= 1,
	MENU_REGISTER			= 2,
	MENU_REGISTER_CODE		= 3,
	MENU_LOGIN_INVALID		= 4,
	MENU_REGISTER_INVALID	= 5,

	DIALOG_MENU_ONLY_MESSAGE		= 0,
	DIALOG_MENU_CHANGE_USERNAME		= 1,
	DIALOG_MENU_INSERT_PASSWORD		= 2,
	DIALOG_MENU_REGISTER_EMAIL		= 3,
	DIALOG_MENU_REGISTER_CODE		= 4,
	DIALOG_MENU_REGISTER_CANCEL		= 5,
	DIALOG_MENU_RECOVER_PASSWORD	= 6;
/*
 * ENUMERATORS
 ******************************************************************************
 */
/// <summary>
/// Enumeradores das TextDraws globais e privadas.
/// </summary>
enum E_TEXT_GLOBAL_LOGIN_SCREEN
{
	Text:E_LOGIN_SCREEN_TITLE[3],
	Text:E_LOGIN_SCREEN_BUTTON[3],
	Text:E_LOGIN_SCREEN_TEXT[4]
}

enum E_TEXT_GLOBAL_MENU
{
	Text:E_TEXT_BACKGROUND_TITLE,
	Text:E_TEXT_BUTTON_BACK,
	Text:E_TEXT_USERNAME_ICON[3],
	Text:E_TEXT_PASSWORD_ICON[3],
	Text:E_TEXT_BUTTON_USERNAME_CHANGE,
	Text:E_TEXT_BUTTON_PASSWORD_VIEW,
	Text:E_TEXT_LOGIN_MAIN_BACKGROUND,
	Text:E_TEXT_LOGIN_BACKGROUND[3],
	Text:E_TEXT_LOGIN_BUTTON[2],
	Text:E_TEXT_LOGIN_INVALID[2],
	Text:E_TEXT_REGISTER_MAIN_BACKGROUND,
	Text:E_TEXT_REGISTER_BACKGROUND[10],
	Text:E_TEXT_REGISTER_BUTTON[3],
	Text:E_TEXT_REGISTER_TERMS_CHECKBOX,
	Text:E_TEXT_REGISTER_INVALID[2]
}

enum E_TEXT_GLOBAL_LOGIN_PLAYER
{
	Text:E_LOGIN_PLAYER_BACKGROUND[11],
	Text:E_LOGIN_PLAYER_BUTTON[4],
	Text:E_LOGIN_PLAYER_ERROR[2]
}

enum E_TEXT_GLOBAL_REGISTER_PLAYER
{
	Text:E_REGISTER_PLAYER_BACKGROUND[18],
	Text:E_REGISTER_PLAYER_BUTTON[5],
	Text:E_REGISTER_PLAYER_CHECKBOX,
	Text:E_REGISTER_PLAYER_ERROR[2]
}

/*enum E_TEXT_PRIVATE_LOGIN_PLAYER
{
	PlayerText:E_LOGIN_PLAYER_USERNAME,
	PlayerText:E_LOGIN_PLAYER_PASSWORD
}

enum E_TEXT_PRIVATE_REGISTER_PLAYER
{
	PlayerText:E_REGISTER_PLAYER_USERNAME,
	PlayerText:E_REGISTER_PLAYER_PASSWORD,
	PlayerText:E_REGISTER_PLAYER_EMAIL,
	PlayerText:E_REGISTER_PLAYER_TEMP_CODE[7]
}*/
enum E_TEXT_PRIVATE_MENU
{
	PlayerText:E_MENU_PLAYER_USERNAME,
	PlayerText:E_MENU_PLAYER_PASSWORD,
	PlayerText:E_MENU_PLAYER_EMAIL,
	PlayerText:E_MENU_PLAYER_TEMP_CODE[7]
}

/// <summary>
/// Enumerador da variável de controle do NPC do cenário de login.
/// </summary>
enum E_NPC_LOGIN_SCENARIO
{
	E_NPC_ID,
	bool:E_NPC_ANIMATING,
	E_PLAYERS_WATCHING_NPC
}

/// <summary>
/// Enumerador da variável de controle do menu de login do jogador.
/// </summary>
enum E_PLAYER_MENU_LOGIN_CONTROL
{
	E_PLAYER_IN_MENU,
	bool:E_PLAYER_MASK_PASSWORD,
	bool:E_PLAYER_REGISTERING,
	bool:E_REGISTER_CHECKBOX_TERMS,
	E_PLAYER_LOGIN_ATTEMPTS,
	bool:E_PLAYER_IN_SCENARIO
}

/// <summary>
/// Enumerador da variável de dados temporários do jogador.
/// </summary>
enum E_PLAYER_DATA_TEMP
{
	E_PLAYER_PASSWORD_TEMP[MAX_PASSWORD_SIZE + 1],
	E_PLAYER_EMAIL_TEMP[MAX_EMAIL_SIZE],
	E_PLAYER_VERIFICATION_CODE,
	E_PLAYER_EMAIL_SENT_TIME,
	E_PLAYER_EMAIL_CHANGED_TIME
}

/// <summary>
/// Enumerador da variável que armazena as posições do lobby do jogador.
/// </summary>
enum E_LOBBY_POSITION
{
	Float:E_LOBBY_POS_X,
	Float:E_LOBBY_POS_Y,
	Float:E_LOBBY_POS_Z,
	Float:E_LOBBY_ROT
}

/// <summary>
/// Enumerador da variável de controle do lobby do jogador.
/// </summary>
enum E_PLAYER_LOBBY_CONTROL
{
	bool:E_PLAYER_IN_LOBBY,
	bool:E_PLAYER_IN_MENU_CHARACTER
}

enum E_POSITIONS
{
	Float:E_POSITION_X,
	Float:E_POSITION_Y,
	Float:E_POSITION_Z,
	Float:E_POSITION_ROT
}
/*
 * VARIABLES
 ******************************************************************************
 */
new const

	loginScreenPosition[E_POSITIONS] = {319.4734, 8829.8604, 12.9612},
	lobbyPosition[E_LOBBY_POSITION] = {-160.2267, -79.1494, 1003.6990, 90.0000},//{-687.9006, 938.5778, 3322.2449, 0.0},
	positionEnterCharacterMenu[E_POSITIONS] = {-159.70576, -80.53201, 1003.82886},//{-683.48077, 937.07550, 3322.39209},
	outMenuSelectionCharPosition[E_POSITIONS] = {-159.6544, -79.9193, 1003.6917, 180.0000},//{-684.2746, 937.0375, 3322.2380, 270.0},

	loginSoundtrack[3][56] = {
		{"http://hogfiles.000webhostapp.com/hog_sound_track_0.mp3"},
		{"http://hogfiles.000webhostapp.com/hog_sound_track_1.mp3"},
		{"http://hogfiles.000webhostapp.com/hog_sound_track_2.mp3"}
	};

static

	Text:textGhostFixBug,
	Text:textGlobalLoginScreen[E_TEXT_GLOBAL_LOGIN_SCREEN],

	Text:textGlobalMenu[E_TEXT_GLOBAL_MENU],

	PlayerText:textPrivateMenu[MAX_PLAYERS][E_TEXT_PRIVATE_MENU],
	//PlayerText:textPrivateLoginPlayer[MAX_PLAYERS char][E_TEXT_PRIVATE_LOGIN_PLAYER],
	//PlayerText:textPrivateRegisterPlayer[MAX_PLAYERS char][E_TEXT_PRIVATE_REGISTER_PLAYER],

	bool:playerInLoginScreen[MAX_PLAYERS],
	playerMenuLoginControl[MAX_PLAYERS][E_PLAYER_MENU_LOGIN_CONTROL],
	playerLobbyControl[MAX_PLAYERS][E_PLAYER_LOBBY_CONTROL],
	playerDataTemp[MAX_PLAYERS][E_PLAYER_DATA_TEMP],

	mapBlock,

	npcLoginScenario[E_NPC_LOGIN_SCENARIO],
	playerDeath[MAX_PLAYERS];

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined login_OnGameModeInit
		login_OnGameModeInit();
	#endif

	ModuleInit("player/login.pwn");

	CreateGlobalTDLoginScreen();
	CreateGlobalTDMenu();

	CreateNPCLoginScenario();

	mapBlock = GangZoneCreate(-10000.0, -11000.0, 10000.0, 11000.0);

	return 1;
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit login_OnGameModeInit
#if defined login_OnGameModeInit
	forward login_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
	#if defined login_OnPlayerConnect
		login_OnPlayerConnect(playerid);
	#endif

	if(IsPlayerNPC(playerid))
		return 1;

	PlaySoundtrack(playerid);

	playerInLoginScreen[playerid] = true;
	playerDeath[playerid] = false;

	TextDrawShowForPlayer(playerid, textGhostFixBug);

	CreatePlayerFade(playerid, true);

	CreatePrivateTDMenu(playerid);

	ResetPlayerLoginControl(playerid);

	ResetPlayerLobbyControl(playerid);

	OpenLoginScreenToPlayer(playerid);

	return 1;
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect login_OnPlayerConnect
#if defined login_OnPlayerConnect
	forward login_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	#if defined login_OnPlayerDisconnect
		login_OnPlayerDisconnect(playerid, reason);
	#endif

	if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
		HidePlayerTempTDRegisterCode(playerid);

	npcLoginScenario[E_PLAYERS_WATCHING_NPC]--;

	return 1;
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect login_OnPlayerDisconnect
#if defined login_OnPlayerDisconnect
	forward login_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerSpawn(playerid)
{
	#if defined login_OnPlayerSpawn
		login_OnPlayerSpawn(playerid);
	#endif

	if(IsPlayerNPC(playerid))
		return 1;

	if(playerInLoginScreen[playerid])
		PositionPlayerLoginScreen(playerid);

	return 1;
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn login_OnPlayerSpawn
#if defined login_OnPlayerSpawn
	forward login_OnPlayerSpawn(playerid);
#endif

public OnPlayerRequestClass(playerid, classid)
{
	#if defined login_OnPlayerRequestClass
		login_OnPlayerRequestClass(playerid, classid);
	#endif

	if(IsPlayerNPC(playerid))
		return 1;
   
	if(playerInLoginScreen[playerid])
	{
		TogglePlayerSpectating(playerid, 1);
		return 1;
	}

	if(playerDeath[playerid])
		playerDeath[playerid] = false;
	else
		SpawnPlayer(playerid);

	return 1;
}
#if defined _ALS_OnPlayerRequestClass
	#undef OnPlayerRequestClass
#else
	#define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass login_OnPlayerRequestClass
#if defined login_OnPlayerRequestClass
	forward login_OnPlayerRequestClass(playerid, classid);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	#if defined login_OnPlayerDeath
		login_OnPlayerDeath(playerid, killerid, reason);
	#endif

	playerDeath[playerid] = true;

	return 1;
}
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath login_OnPlayerDeath
#if defined login_OnPlayerDeath
	forward login_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	#if defined login_OnPlayerClickTextDraw
		login_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#endif

	if(_:clickedid == INVALID_TEXT_DRAW || playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_NONE)
		return 1;

	if(clickedid == textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0])//entrar
		ShowPlayerLoginMenu(playerid);

	else if(clickedid == textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1])//registrar
		ShowPlayerRegisterMenu(playerid);

	else if(clickedid == textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2])//sobre
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, DIALOG_BTN_ABOUT_CAPTION, DIALOG_BTN_ABOUT_INFO, DIALOG_BTN_ABOUT_BUTTON, "");
	}

	else if(clickedid == textGlobalMenu[E_TEXT_BUTTON_BACK] && playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_NONE)//voltar
	{
		switch(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU])
		{
			case MENU_LOGIN, MENU_LOGIN_INVALID:
				HidePlayerLoginMenu(playerid);

			case MENU_REGISTER, MENU_REGISTER_CODE:
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
				{
					CancelSelectTextDraw(playerid);
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CANCEL, DIALOG_STYLE_MSGBOX, "Cancelar registro", "Você tem certeza de que deseja voltar e cancelar o registro?", "Sim", "Não");
				}
				
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					HidePlayerTempTDRegisterCode(playerid);
				else
					HidePlayerRegisterMenu(playerid);
			}

			case MENU_REGISTER_INVALID:
				HidePlayerRegisterMenu(playerid);
		}

		ShowPlayerHomeMenu(playerid);
	}

	else if(clickedid == textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE])//alterar username
	{
		CancelSelectTextDraw(playerid);

		if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN)
			ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", "Nome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
		else
			ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Logar em outra conta", "Conta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
	}
	
	else if(clickedid == textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW])//mostrar/esconder senha
	{
		if(isnull(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]))
			return 1;

		if((playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD] = !playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD]))
			PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], MaskPassword(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]));
		else
			PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]);

		PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);
	}

	else if(clickedid == textGlobalMenu[E_TEXT_LOGIN_BUTTON][1])//recuperar senha
	{
		CancelSelectTextDraw(playerid);

		if(gettime() - playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] < RESEND_MAIL_TIME)
			return ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Recuperar senha", "Aguarde para usar esta função novamente, um email recém foi enviado para você.", "Confirmar", "");

		ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD, DIALOG_STYLE_INPUT, "Recuperar senha", "Para recuperar sua senha, insira abaixo o email utilizado na criação de sua conta.", "Próximo", "Voltar");
	}

	else if(clickedid == textGlobalMenu[E_TEXT_LOGIN_BUTTON][0])//logar
	{
		if(isnull(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]))
			return ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Insira sua senha", WARNING_CHAR "Você precisa inserir sua senha para logar!\n\nClique sobre 'senha' para inserir.", "Confirmar", "");
		
		if(LoadPlayerAccount(playerid, playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]))
		{
			HidePlayerLoginMenu(playerid);
			SetPlayerFade(playerid, FADE_TYPE_IN, 50, MODULE_LOGIN, FADE_WAITING_LOGIN_SCREEN);
		}
		else
		{
			playerMenuLoginControl[playerid][E_PLAYER_LOGIN_ATTEMPTS]++;

			if(playerMenuLoginControl[playerid][E_PLAYER_LOGIN_ATTEMPTS] >= MAX_LOGIN_ATTEMPTS)
			{
				SendClientMessageFormat(playerid, COLOR_RED, MESSAGE_LOGIN_FAIL_KICK, MAX_LOGIN_ATTEMPTS);
				Kick(playerid);
			}
			else
				SendClientMessageFormat(playerid, COLOR_RED, MESSAGE_LOGIN_FAIL, playerMenuLoginControl[playerid][E_PLAYER_LOGIN_ATTEMPTS], MAX_LOGIN_ATTEMPTS);
		}
	}

	else if(clickedid == textGlobalMenu[E_TEXT_REGISTER_BUTTON][0])//registrar
	{
		if(isnull(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]))
			return ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Dados incompletos", WARNING_CHAR "Você precisa inserir uma senha para se registrar!\n\nClique sobre 'senha' para inserir.", "Confirmar", "");
		
		if(isnull(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP]))
			return ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Dados incompletos", WARNING_CHAR "Você precisa inserir um email para se registrar!\n\nClique sobre 'email' para inserir.", "Confirmar", "");
		
		if(!playerMenuLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS])
			return ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Dados incompletos", WARNING_CHAR "Você precisa aceitar os termos para se registrar!\n\nMarque a opção \"Eu li e concordo com os termos\" para seguir.\nVocê pode ver os termos clicando em 'termos' destacado.", "Confirmar", "");
		
		playerDataTemp[playerid][E_PLAYER_EMAIL_CHANGED_TIME] = playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] = 0;

		SendRegisterMail(playerid);
		HidePlayerRegisterMenu(playerid);
		ShowPlayerTempTDRegisterCode(playerid);
	}

	else if(clickedid == textGlobalMenu[E_TEXT_REGISTER_BUTTON][1])//termos
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, DIALOG_TEMRS_CAPTION, DIALOG_TEMRS_INFO, DIALOG_TEMRS_BUTTON, "");
	}

	else if(clickedid == textGlobalMenu[E_TEXT_REGISTER_BUTTON][2])//checkbox termos
	{
		if((playerMenuLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS] = !playerMenuLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS]))
			TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX]);
		else
			TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX]);
	}

	return 1;
}
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw login_OnPlayerClickTextDraw
#if defined login_OnPlayerClickTextDraw
	forward login_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

#if defined OnPlayerClickPlayerTextDraw
    #undef OnPlayerClickTextDraw
    #define OnPlayerClickTextDraw MP2_OPCTDraw
    forward MP2_OPCTDraw(playerid, Text:clickedid);
#endif

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	#if defined log_OnPlayerClickPlayerTextDraw
		log_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
	#endif

	if(playertextid == textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD])//inserir senha
	{
		CancelSelectTextDraw(playerid);

		if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN)
			ShowPlayerDialogFormat(playerid, DIALOG_MENU_INSERT_PASSWORD, (playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD]) ? (DIALOG_STYLE_PASSWORD) : (DIALOG_STYLE_INPUT), "Inserir senha", "Insira uma senha com no mínimo 3 e no máximo %d caracteres.\n\n{E84F33}OBS{BCD2EE}: O " GetModeName " utiliza criptografia hash em senhas de ponta-a-ponta,\nde maneira que nem mesmo os desenvolvedores terão acesso a sua senha.", "Confirmar", "Voltar", MAX_PASSWORD_SIZE);
		else
			ShowPlayerDialogFormat(playerid, DIALOG_MENU_INSERT_PASSWORD, (playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD]) ? (DIALOG_STYLE_PASSWORD) : (DIALOG_STYLE_INPUT), "Inserir senha", "Insira sua senha abaixo. Caso errar mais que %d vezes, será kickado.", "Confirmar", "Voltar", MAX_LOGIN_ATTEMPTS);
	}

	else if(playertextid == textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL])//inserir email
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Inserir email", "Insira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Confirmar", "Voltar");
	}

	else if(playertextid == textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2])//inserir código
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CODE, DIALOG_STYLE_INPUT, "Inserir código de verificação", "Insira abaixo o código de verificação recebido para concluir o registro.\n\n{E84F33}OBS¹{BCD2EE}: Caso não tenha recebido o email, clique em voltar e selecione a\nopção 'reenviar' para enviar novamente.\n\n{E84F33}OBS²{BCD2EE}: Se digitou o email errado, clique em voltar e selecione a opção\n'email' para alterar.", "Continuar", "Voltar");
	}

	else if(playertextid == textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3])//reenviar email
	{
		CancelSelectTextDraw(playerid);

		if(gettime() - playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] < RESEND_MAIL_TIME)
			return ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Aguarde para reenviar email", "Aguarde para enviar um email novamente. Normalmente\nos emails são enviados em menos de 1 minuto.\n\nCaso não o encontre em sua caixa de entrada, verifique\na caixa de spam!", "Confirmar", "");

		SendRegisterMail(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Email reenviado", "Foi enviado um email com um novo código de verificação!\n\nCaso não o encontre em sua caixa de entrada, verifique a\ncaixa de spam!", "Confirmar", "");
	}

	else if(playertextid == textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5])//alterar email
	{
		CancelSelectTextDraw(playerid);

		if(gettime() - playerDataTemp[playerid][E_PLAYER_EMAIL_CHANGED_TIME] < RESEND_MAIL_TIME)
			return ShowPlayerDialogFormat(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Aguarde para alterar email", "Aguarde para alterar seu email novamente. Um email já foi enviado\npara {E84F33}%s{BCD2EE}, cheque sua caixa de entrada e spam.", "Confirmar", "", playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP]);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", "Insira abaixo um novo email válido que você tenha acesso.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
	}

	return 1;
}
#if defined ALS_OnPlayerClickPlayerTextDraw
	#undef OnPlayerClickPlayerTextDraw
#else
	#define ALS_OnPlayerClickPlayerTextDraw
#endif
#define OnPlayerClickPlayerTextDraw log_OnPlayerClickPlayerTextDraw
#if defined log_OnPlayerClickPlayerTextDraw
	forward log_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#if defined login_OnDialogResponse
		login_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#endif

	switch(dialogid)
	{
		case DIALOG_MENU_ONLY_MESSAGE:
			return SelectTextDraw(playerid, 0x757575FF);

		case DIALOG_MENU_CHANGE_USERNAME:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(!(3 <= strlen(inputtext) <= 20))
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN)
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Você deve inserir algum nome de 3 a 20 caracteres.\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
				else
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Logar em outra conta", WARNING_CHAR "Nome de usuário inválido! O nome contém de\n3 a 20 caracteres.\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
			}

			if(!IsValidPlayerName(inputtext))
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN)
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Nome inválido! Caracteres aceitos: A a Z, 0 a 9 e _(underline).\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
				else
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Logar em outra conta", WARNING_CHAR "Nome de usuário inválido! O nome contém caracteres inválidos.\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
			}

			if(!strcmp(inputtext, GetNameOfPlayer(playerid), true, MAX_PLAYER_NAME))
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN)
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Você já está utilizando esse nome!\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
				else
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Logar em outra conta", WARNING_CHAR "Você já está utilizando esse nome usuário!\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
			}

			if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN && !playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
				playerMenuLoginControl[playerid][E_PLAYER_REGISTERING] = true;

			CheckNameAlreadyRegistered(playerid, inputtext);
			return 1;
		}

		case DIALOG_MENU_INSERT_PASSWORD:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(!(3 <= strlen(inputtext) <= MAX_PASSWORD_SIZE))
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN)
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_INSERT_PASSWORD, (playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD]) ? (DIALOG_STYLE_PASSWORD) : (DIALOG_STYLE_INPUT), "Inserir senha", WARNING_CHAR "Senha inválida! A senha deve conter entre 3 a %d caracteres.\n\n{E84F33}OBS{BCD2EE}: O " GetModeName " utiliza criptografia hash em senhas de ponta-a-ponta,\nde maneira que nem mesmo os desenvolvedores terão acesso a sua senha.", "Confirmar", "Voltar", MAX_PASSWORD_SIZE);
				else
					return ShowPlayerDialogFormat(playerid, DIALOG_MENU_INSERT_PASSWORD, (playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD]) ? (DIALOG_STYLE_PASSWORD) : (DIALOG_STYLE_INPUT), "Inserir senha", WARNING_CHAR "Senha inválida! As senhas possuem no mínimo 3 caracteres.\n\nInsira sua senha abaixo. Caso errar mais que %d vezes, será kickado.", "Confirmar", "Voltar", MAX_LOGIN_ATTEMPTS);
			}

			if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_LOGIN && !playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
				playerMenuLoginControl[playerid][E_PLAYER_REGISTERING] = true;

			format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, inputtext);
			
			PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], ((playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD]) ? (MaskPassword(inputtext)) : (inputtext)));
			PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);

			SelectTextDraw(playerid, 0x757575FF);
			return 1;
		}

		case DIALOG_MENU_REGISTER_EMAIL:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext))
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", WARNING_CHAR "Caixa de texto vazia! Insira algum email.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
				else
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Inserir email", WARNING_CHAR "Caixa de texto vazia! Insira algum email.\n\nInsira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Confirmar", "Voltar");
			}

			if(!IsValidEmail(inputtext))
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", WARNING_CHAR "Email inválido! Caracteres aceitos: A a Z, 0 a 9, @(arroba), _(underline), .(ponto) e -(hífen).\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
				else
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Inserir email", WARNING_CHAR "Email inválido! Caracteres aceitos: A a Z, 0 a 9, @(arroba), _(underline), .(ponto) e -(hífen).\n\nInsira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Confirmar", "Voltar");
			}

			if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
			{
				if(!strcmp(inputtext, playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], true, MAX_EMAIL_SIZE))
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", WARNING_CHAR "Você já está usando este email! Insira outro.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
			}

			if(!playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
				playerMenuLoginControl[playerid][E_PLAYER_REGISTERING] = true;

			format(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], MAX_EMAIL_SIZE, inputtext);

			if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
			{
				SendRegisterMail(playerid);
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Email alterado", "Seu email foi alterado para {E84F33}%s{BCD2EE}.\n\nFoi enviado um email com um novo código de verificação.", "Confirmar", "", inputtext);
			}

			PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], ConvertEmailToText(inputtext));
			PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL]);

			SelectTextDraw(playerid, 0x757575FF);
			return 1;
		}

		case DIALOG_MENU_REGISTER_CODE:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CODE, DIALOG_STYLE_INPUT, "Inserir código de verificação", WARNING_CHAR "Caixa de texto vazia! Insira o código de verificação para concluir o registro.\n\n{E84F33}OBS¹{BCD2EE}: Caso não tenha recebido o email, clique em voltar e selecione a opção\n'reenviar' para enviar novamente.\n\n{E84F33}OBS²{BCD2EE}: Se digitou o email errado, clique em voltar e selecione a opção 'email'\npara alterar.", "Continuar", "Voltar");

			if(playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE] != strval(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CODE, DIALOG_STYLE_INPUT, "Inserir código de verificação", WARNING_CHAR "Código de verificação inválido! Insira o código correto para concluir\no registro.\n\n{E84F33}OBS¹{BCD2EE}: Caso não tenha recebido o email, clique em voltar e selecione a\nopção 'reenviar' para enviar novamente.\n\n{E84F33}OBS²{BCD2EE}: Se digitou o email errado, clique em voltar e selecione a opção\n'email' para alterar.", "Continuar", "Voltar");

			RegisterPlayerAccount(playerid, playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP],  playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP]);

			HidePlayerTempTDRegisterCode(playerid);

			SendClientMessage(playerid, COLOR_GREEN, MESSAGE_REGISTER_COMPLETED);
			
			SetPlayerFade(playerid, FADE_TYPE_IN, 50, MODULE_LOGIN, FADE_WAITING_LOGIN_SCREEN);
			return 1;
		}

		case DIALOG_MENU_REGISTER_CANCEL:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			SelectTextDraw(playerid, 0x757575FF);

			HidePlayerRegisterMenu(playerid);
			ShowPlayerHomeMenu(playerid);
			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD, DIALOG_STYLE_INPUT, "Recuperar senha", WARNING_CHAR "Caixa de texto vazia!\n\nPara recuperar sua senha, insira abaixo o email utilizado na criação de sua conta.", "Próximo", "Voltar");

			if(!strcmp(inputtext, GetPlayerAccountEmail(playerid), .length = MAX_EMAIL_SIZE))
				ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 1, DIALOG_STYLE_MSGBOX, "Recuperar senha", "Enviaremos um código de verificação para o seu email, e você deverá informar o\ncódigo recebido. Em seguida, você poderá redefinir sua senha e fazer seu login.\n\nDeseja prosseguir?", "Próximo", "Voltar");
			else
				ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD, DIALOG_STYLE_INPUT, "Recuperar senha", WARNING_CHAR "Email incorreto!\n\nPara recuperar sua senha, insira abaixo o email utilizado na criação de sua conta.", "Próximo", "Voltar");

			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD + 1:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, "");

			PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], "senha");
			PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);

			SendRecoverPasswordMail(playerid);

			ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 2, DIALOG_STYLE_INPUT, "Recuperar senha", "Um email foi enviado com o código de verificação.\n\nInsira o código recebido abaixo.", "Próximo", "Voltar");
			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD + 2:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 2, DIALOG_STYLE_INPUT, "Recuperar senha", WARNING_CHAR "Caixa de texto vazia!\n\nInsira o código de verificação para prosseguir.", "Próximo", "Voltar");

			if(playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE] != strval(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 2, DIALOG_STYLE_INPUT, "Recuperar senha", WARNING_CHAR "Código de verificação inválido!\n\nInsira o código de verificação para prosseguir.", "Próximo", "Voltar");

			ShowPlayerDialogFormat(playerid, DIALOG_MENU_RECOVER_PASSWORD + 3, DIALOG_STYLE_PASSWORD, "Recuperar senha", "Código de verificação correto!\n\nInsira sua nova senha abaixo, de 3 a %d caracteres.", "Próximo", "Voltar", MAX_PASSWORD_SIZE);
			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD + 3:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(!(3 <= strlen(inputtext) <= MAX_PASSWORD_SIZE))
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_RECOVER_PASSWORD + 3, DIALOG_STYLE_PASSWORD, "Recuperar senha", WARNING_CHAR "Senha inválida! A senha deve conter entre 3 a %d caracteres.\n\nInsira sua nova senha abaixo para prosseguir.", "Próximo", "Voltar", MAX_PASSWORD_SIZE);

			format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, inputtext);

			ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 4, DIALOG_STYLE_PASSWORD, "Recuperar senha", "Insira novamente sua senha para confirmar.", "Confirmar", "Voltar");
			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD + 4:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			change_password:

			if(!isnull(inputtext) && !strcmp(inputtext, playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], .length = MAX_PASSWORD_SIZE))
			{
				ChangePlayerPassword(playerid, inputtext);

				ShowPlayerDialog(playerid, DIALOG_MENU_ONLY_MESSAGE, DIALOG_STYLE_MSGBOX, "Recuperar senha", "Senha alterada com sucesso! Você já pode fazer seu login.", "Confirmar", "");
			}
			else
				ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 5, DIALOG_STYLE_PASSWORD, "Recuperar senha", WARNING_CHAR "As senhas não combinam!\n\nInsira novamente sua senha para confirmar.", "Confirmar", "Opções");

			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD + 5:
		{
			if(response)
				goto change_password;

			ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 6, DIALOG_STYLE_LIST, "Recuperar senha", "Inserir outra senha\nCancelar recuperação\nVoltar", "Selecionar", "");
			return 1;
		}

		case DIALOG_MENU_RECOVER_PASSWORD + 6:
		{
			switch(listitem)
			{
				case 0:
					ShowPlayerDialogFormat(playerid, DIALOG_MENU_RECOVER_PASSWORD + 3, DIALOG_STYLE_PASSWORD, "Recuperar senha", "Insira sua nova senha abaixo, de 3 a %d caracteres.", "Próximo", "Voltar", MAX_PASSWORD_SIZE);
				case 1:
				{
					format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, inputtext);
					SelectTextDraw(playerid, 0x757575FF);
				}
				case 2:
					ShowPlayerDialog(playerid, DIALOG_MENU_RECOVER_PASSWORD + 5, DIALOG_STYLE_PASSWORD, "Recuperar senha", WARNING_CHAR "As senhas não combinam!\n\nInsira novamente sua senha para confirmar.", "Confirmar", "Opções");
			}
			return 1;
		}

	}
	return 1;
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse login_OnDialogResponse
#if defined login_OnDialogResponse
	forward login_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#if defined login_OnPlayerKeyStateChange
		login_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif

	if((newkeys & KEY_CTRL_BACK) && !(oldkeys & KEY_CTRL_BACK))
	{
		if(playerInLoginScreen[playerid] && (playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_HOME || playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_NONE))
			SelectTextDraw(playerid, 0x757575FF);
	}
	else if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK))
		PlayerCharacterMenu(playerid);

	return 1;
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange login_OnPlayerKeyStateChange
#if defined login_OnPlayerKeyStateChange
	forward login_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnPlayerHideCursor(playerid, hovercolor)
{
	if(playerInLoginScreen[playerid])
		return SendClientMessage(playerid, COLOR_YELLOW, MESSAGE_CURSOR_HIDED_IN_LOGIN);

	if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_NONE)//voltar
	{
		switch(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU])
		{
			case MENU_LOGIN, MENU_LOGIN_INVALID:
				HidePlayerLoginMenu(playerid);

			case MENU_REGISTER, MENU_REGISTER_CODE:
			{
				if(playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CANCEL, DIALOG_STYLE_MSGBOX, "Cancelar registro", "Você tem certeza de que deseja voltar e cancelar o registro?", "Sim", "Não");
				
				if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					HidePlayerTempTDRegisterCode(playerid);
				else
					HidePlayerRegisterMenu(playerid);
			}

			case MENU_REGISTER_INVALID:
				HidePlayerRegisterMenu(playerid);
		}

		ShowPlayerHomeMenu(playerid);
		SelectTextDraw(playerid, 0x757575FF);
	}

	return 1;
}
/*
 * MY CALLBACKS
 ******************************************************************************
 */
public CheckNameRegisteredResponse(playerid, name[])
{
	new rows;

	cache_get_row_count(rows);

	if(rows > 0)
	{
		if(playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
			return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Este nome de usuário já está registrado! Use outro.\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
	}
	else
	{
		if(!playerMenuLoginControl[playerid][E_PLAYER_REGISTERING])
			return ShowPlayerDialogFormat(playerid, DIALOG_MENU_CHANGE_USERNAME, DIALOG_STYLE_INPUT, "Logar em outra conta", WARNING_CHAR "Este nome de usuário não está registrado!\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
	}

	
	SetPlayerName(playerid, name);
			
	PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], name);
	PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME]);

	SelectTextDraw(playerid, 0x757575FF);
	return 1;
}

public ShowTextDrawsLoginScreen(playerid, tape)
{
	switch(tape)
	{
		case 0:
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2]);
		case 1:
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0]);
		case 2:
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1]);
		case 3:
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2]);
		case 4:
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3]),
			playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_HOME;
	}

	if(tape != 4) SetTimerEx("ShowTextDrawsLoginScreen", 200, false, "ii", playerid, tape + 1);
}

FadeScreenCallFunctions(playerid, fadeType, fadeWaitingType)
{
	if(fadeType == FADE_TYPE_OUT)
	{
		switch(fadeWaitingType)
		{
			case FADE_WAITING_LOGIN_SCREEN:
			{
				if(playerInLoginScreen[playerid])
					ShowTextDrawsLoginScreen(playerid, 0);
				else
				{
					TogglePlayerControllable(playerid, true);

					if(playerMenuLoginControl[playerid][E_PLAYER_IN_SCENARIO])
						npcLoginScenario[E_PLAYERS_WATCHING_NPC]--;

					if(npcLoginScenario[E_PLAYERS_WATCHING_NPC] < 1)
						StopNPCMagicAnimation();

					playerMenuLoginControl[playerid][E_PLAYER_IN_SCENARIO] = false;
				}
			}
			case FADE_WAITING_MENU_CHARACTER:
			{
				if(playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER])
					ShowMenuSelectionCharacter(playerid);
			}
			case FADE_WAITING_OUT_MENU_CHARACTER:
			{
				if(playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER])
				{
					UnfreezePlayer(playerid, true);

					playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER] = false;
					playerLobbyControl[playerid][E_PLAYER_IN_LOBBY] = true;
				}
			}
		}
	}
	else
	{
		switch(fadeWaitingType)
		{
			case FADE_WAITING_LOGIN_SCREEN:
			{
				if(playerInLoginScreen[playerid])
					PutPlayerInLobby(playerid);
			}
			case FADE_WAITING_MENU_CHARACTER:
			{
				if(playerLobbyControl[playerid][E_PLAYER_IN_LOBBY])
					PutPlayerInCharacterMenu(playerid);
			}
			case FADE_WAITING_OUT_MENU_CHARACTER:
			{
				if(playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER])
				{
					OutSelectionCharacterScenario(playerid);

					TogglePlayerControllable(playerid, false);

					SetPlayerInterior(playerid, 1);
					SetPlayerPos(playerid, outMenuSelectionCharPosition[E_POSITION_X], outMenuSelectionCharPosition[E_POSITION_Y], outMenuSelectionCharPosition[E_POSITION_Z]);
					SetPlayerFacingAngle(playerid, outMenuSelectionCharPosition[E_POSITION_ROT]);
					SetCameraBehindPlayer(playerid);

					SetTimerEx("SetPlayerFade", 500, false, "iiiii", playerid, FADE_TYPE_OUT, 50, MODULE_LOGIN, FADE_WAITING_OUT_MENU_CHARACTER);
				}
			}
		}
	}
}
/*
 * FUNCTIONS
 ******************************************************************************
 */

/*
-----------------------------------------------------------------------------*/
static PlaySoundtrack(playerid)
{
	PlayAudioStreamForPlayer(playerid, loginSoundtrack[random(3)], 0, 0, 0);

	for(new i; i < 100; i++) SendClientMessage(playerid, COLOR_DEFAULT, "");
}
/*
-----------------------------------------------------------------------------*/
ConvertEmailToText(email[])
{
	new emailOutput[MAX_EMAIL_SIZE + 1],
		i;

	format(emailOutput, MAX_EMAIL_SIZE, email);

	for(i = 0; i < MAX_EMAIL_SIZE; i++)
	{
		if(emailOutput[i] == '@')
			emailOutput[i] = ']';
	}

	return emailOutput;
}

SendRecoverPasswordMail(playerid)
{
	playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE] = random(8999) + 1000;
	playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] = gettime();
	SendEmailSMTP(GetModeName, MAILER_SENDER, MAILER_PASS, GetPlayerAccountEmail(playerid), "Recuperar senha", MailRecoverPasswordCode(GetNameOfPlayer(playerid), playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE]));
}

SendRegisterMail(playerid)
{
	playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE] = random(8999) + 1000;
	playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] = gettime();

	SendEmailSMTP(GetModeName, MAILER_SENDER, MAILER_PASS, playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], "Registrar conta", MailRegisterCode(GetNameOfPlayer(playerid), playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE]));
}
/*
-----------------------------------------------------------------------------*/
ResetPlayerLobbyControl(playerid)
{
	playerLobbyControl[playerid][E_PLAYER_IN_LOBBY] = playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER] = false;
}

ResetPlayerLoginControl(playerid)
{
	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
	playerMenuLoginControl[playerid][E_PLAYER_MASK_PASSWORD] = true;
	playerMenuLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS] = playerMenuLoginControl[playerid][E_PLAYER_IN_SCENARIO] = false;
	playerMenuLoginControl[playerid][E_PLAYER_LOGIN_ATTEMPTS] = 0;
}
/*
-----------------------------------------------------------------------------*/
MaskPassword(password[])
{
	new mask[MAX_PASSWORD_SIZE + 1],
		i;

	for(i = 0; i < strlen(password); i++)
		mask[i] = ']';

	return mask;
}
/*
-----------------------------------------------------------------------------*/
PlayerCharacterMenu(playerid)
{
	if(GetPlayerFadeWaiting(playerid) == FADE_WAITING_MENU_CHARACTER ||
		playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER])
		return;

	if(IsPlayerInRangeOfPoint(playerid, 1.0, positionEnterCharacterMenu[E_POSITION_X], positionEnterCharacterMenu[E_POSITION_Y], positionEnterCharacterMenu[E_POSITION_Z]))
	{
		//playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER] = true;

		FreezePlayer(playerid);

		playerLobbyControl[playerid][E_PLAYER_IN_LOBBY] = true;

		SetPlayerFade(playerid, FADE_TYPE_IN, 50, MODULE_LOGIN, FADE_WAITING_MENU_CHARACTER);
	}
}

PutPlayerInCharacterMenu(playerid)
{
	playerLobbyControl[playerid][E_PLAYER_IN_LOBBY] = false;
	playerLobbyControl[playerid][E_PLAYER_IN_MENU_CHARACTER] = true;

	LoadSelectionCharacterScenario(playerid);

	SetTimerEx("SetPlayerFade", 500, false, "iiiii", playerid, FADE_TYPE_OUT, 50, MODULE_LOGIN, FADE_WAITING_MENU_CHARACTER);
}

RemovePlayerCharacterMenu(playerid)
{
	HideMenuSelectionCharacter(playerid);

	SetPlayerFade(playerid, FADE_TYPE_IN, 50, MODULE_LOGIN, FADE_WAITING_OUT_MENU_CHARACTER);
}

PutPlayerInLobby(playerid)
{
	for(new i; i < 3; i++)
		TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][i]);

	playerInLoginScreen[playerid] = false;

	playerLobbyControl[playerid][E_PLAYER_IN_LOBBY] = true;

	CancelSelectTextDraw(playerid);

	SetPlayerWeather(playerid, LOBBY_WEATHER);

	SetPlayerPos(playerid, lobbyPosition[E_LOBBY_POS_X], lobbyPosition[E_LOBBY_POS_Y], lobbyPosition[E_LOBBY_POS_Z]);
	SetPlayerFacingAngle(playerid, lobbyPosition[E_LOBBY_ROT]);

	//SetPlayerToSpawn(playerid, 171, 1, lobbyPosition[E_LOBBY_POS_X], lobbyPosition[E_LOBBY_POS_Y], lobbyPosition[E_LOBBY_POS_Z], lobbyPosition[E_LOBBY_ROT]);

	SetPlayerVirtualWorld(playerid, random(5000));
		
	SetCameraBehindPlayer(playerid);

	//SetPlayerVirtualWorld(playerid, random(5000));

	//SetPlayerInterior(playerid, 1);

	//TogglePlayerControllable(playerid, false);

	SetTimerEx("SetPlayerFade", 500, false, "iiiii", playerid, FADE_TYPE_OUT, 50, MODULE_LOGIN, FADE_WAITING_LOGIN_SCREEN);
}
/*
-----------------------------------------------------------------------------*/
ShowPlayerHomeMenu(playerid)
{
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0]),
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0]);
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1]),
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1]);
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2]),
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2]);
	TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3]);

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_HOME;
}

HidePlayerHomeMenu(playerid)
{
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0]),
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0]);
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1]),
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1]);
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2]),
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2]);
	TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3]);

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
}
//---------------------------
ShowPlayerLoginMenu(playerid)
{
	HidePlayerHomeMenu(playerid);

	if(!IsPlayerRegistred(playerid))
	{
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_INVALID][0]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_INVALID][1]);

		playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_LOGIN_INVALID;
		return;
	}

	static i;
	
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW]);

	for(i = 0; i < 3; i++)
	{
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_USERNAME_ICON][i]),
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_PASSWORD_ICON][i]);

		if(i < 2)
			TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BUTTON][i]),
			TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][i + 1]);
	}

	PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], GetNameOfPlayer(playerid));
	PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], "senha");

	PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME]);
	PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);

	format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, "");
	format(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], MAX_EMAIL_SIZE, "");

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_LOGIN;
}

HidePlayerLoginMenu(playerid)
{
	if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_LOGIN_INVALID)
	{
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_INVALID][0]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_INVALID][1]);

		playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
		return;
	}

	static i;

	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW]);

	for(i = 0; i < 3; i++)
	{
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_USERNAME_ICON][i]),
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_PASSWORD_ICON][i]);
		
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][i]);

		if(i < 2)
			TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_LOGIN_BUTTON][i]);
	}

	PlayerTextDrawHide(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME]);
	PlayerTextDrawHide(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
}
//------------------------------
ShowPlayerRegisterMenu(playerid)
{
	HidePlayerHomeMenu(playerid);

	if(IsPlayerRegistred(playerid))
	{
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_INVALID][0]);
		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_INVALID][1]);

		playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_REGISTER_INVALID;
		return;
	}

	static i;

	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW]);

	for(i = 0; i < 9; i++)
	{
		if(i < 3)
			TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_USERNAME_ICON][i]),
			TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_PASSWORD_ICON][i]),
			TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BUTTON][i]);

		TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][i + 1]);
	}

	PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], GetNameOfPlayer(playerid));
	PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], "senha");
	PlayerTextDrawSetString(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], "email");

	PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME]);
	PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);
	PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL]);

	format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, "");
	format(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], MAX_EMAIL_SIZE, "");

	playerMenuLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS] = playerMenuLoginControl[playerid][E_PLAYER_REGISTERING] = false;

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_REGISTER;
}

HidePlayerRegisterMenu(playerid)
{
	if(playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_INVALID)
	{
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_INVALID][0]);
		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_INVALID][1]);

		playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
		return;
	}

	static i;

	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX]);

	for(i = 0; i < 10; i++)
	{
		if(i < 3)
			TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_USERNAME_ICON][i]),
			TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_PASSWORD_ICON][i]),
			TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BUTTON][i]);

		TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][i]);
	}

	PlayerTextDrawHide(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME]);
	PlayerTextDrawHide(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD]);
	PlayerTextDrawHide(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL]);

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
}
/*
-------------------------------------------------------------------------------*/
CreateNPCLoginScenario()
{
	npcLoginScenario[E_NPC_ANIMATING] = false;

	npcLoginScenario[E_NPC_ID] = FCNPC_Create(NPC_LOGIN_SCENARIO_NAME);

	if(npcLoginScenario[E_NPC_ID] == INVALID_PLAYER_ID)
		return print(" <!> Erro ao criar NPC_LOGIN_SCENARIO");

	if(!FCNPC_Spawn(npcLoginScenario[E_NPC_ID], NPC_LOGIN_SCENARIO_SKIN, 324.2294, 8824.7646, 14.3335))
		return print(" <!> Erro ao spawnar NPC_LOGIN_SCENARIO");

	FCNPC_SetAngle(npcLoginScenario[E_NPC_ID], 41.4946);
	FCNPC_SetInterior(npcLoginScenario[E_NPC_ID], 0);
	FCNPC_SetVirtualWorld(npcLoginScenario[E_NPC_ID], LOGIN_VIRTUAL_WORLD);

	LoadNPCAnimations(npcLoginScenario[E_NPC_ID]);

	return true;
}

StartNPCMagicAnimation()
{
	if(!FCNPC_IsValid(npcLoginScenario[E_NPC_ID]))
		return printf(" <!> Erro ao iniciar animação mágica do NPC_LOGIN_SCENARIO");

	if(npcLoginScenario[E_NPC_ANIMATING])
		return false;

	npcLoginScenario[E_NPC_ANIMATING] = true;

	LoadNPCAnimations(npcLoginScenario[E_NPC_ID]);

	StartFloatNPC(npcLoginScenario[E_NPC_ID]);

	return true;
}

StopNPCMagicAnimation()
{
	if(!FCNPC_IsValid(npcLoginScenario[E_NPC_ID]))
		return printf(" <!> Erro ao parar animação mágica do NPC_LOGIN_SCENARIO");

	if(!npcLoginScenario[E_NPC_ANIMATING])
		return false;
	
	npcLoginScenario[E_NPC_ANIMATING] = false;

	StopFloatNPC(npcLoginScenario[E_NPC_ID]);

	return true;
}
/*
-------------------------------------------------------------------------------*/
LoadPlayerLoginScenario(playerid)
{
	if(npcLoginScenario[E_NPC_ID] == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_RED, MESSAGE_ERROR_LOAD_SCENARIO);

	if(!npcLoginScenario[E_NPC_ANIMATING])
		StartNPCMagicAnimation();

	playerMenuLoginControl[playerid][E_PLAYER_IN_SCENARIO] = true;

	npcLoginScenario[E_PLAYERS_WATCHING_NPC]++;

	return true;
}
/*
-------------------------------------------------------------------------------*/
OpenLoginScreenToPlayer(playerid)
{
	TogglePlayerSpectating(playerid, 0);

	SetSpawnInfo(playerid, 0, 171, 324.2294, 8824.7646, 14.3335, 41.4946, 0, 0, 0, 0, 0, 0);

	SpawnPlayer(playerid);
}

PositionPlayerLoginScreen(playerid)
{
	GangZoneShowForPlayer(playerid, mapBlock, 0x000000FF);

	SetPlayerWeather(playerid, SCENARIO_WEATHER);
	SetPlayerVirtualWorld(playerid, LOGIN_VIRTUAL_WORLD);
	SetPlayerCameraPos(playerid, 321.521942, 8827.158203, 13.316607 + 1.4);
	SetPlayerCameraLookAt(playerid, 324.171295, 8824.163085, 13.204122 + 1.4);
	SetPlayerPos(playerid, loginScreenPosition[E_POSITION_X], loginScreenPosition[E_POSITION_Y], loginScreenPosition[E_POSITION_Z]);
	SetPlayerInterior(playerid, 1);

	TogglePlayerControllable(playerid, false);

	SelectTextDraw(playerid, LOGIN_MENU_SELECTOR_COLOR/*0xDDDDDDAA*/);

	LoadPlayerLoginScenario(playerid);

	SetTimerEx("SetPlayerFade", 3000, false, "iiiii", playerid, FADE_TYPE_OUT, 50, MODULE_LOGIN, FADE_WAITING_LOGIN_SCREEN);
}
/*
-------------------------------------------------------------------------------*/
CreateGlobalTDLoginScreen()
{
	textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0] = TextDrawCreate(345.529327, 118.833290, "H");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1.053176, 5.006666);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], -1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 256);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1] = TextDrawCreate(369.058837, 141.583312, "ogwarts");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0.406587, 1.920830);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], -1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 1);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 256);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2] = TextDrawCreate(431.646972, 155.000030, "rp/g");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0.152941, 1.144997);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], -1523963137);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 256);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0);

	textGhostFixBug = TextDrawCreate(431.646972, 155.000030, "ghost");
	TextDrawLetterSize(textGhostFixBug, 0.152941, 1.144997);
	TextDrawAlignment(textGhostFixBug, 1);
	TextDrawColor(textGhostFixBug, 0x00000000);
	TextDrawSetShadow(textGhostFixBug, 0);
	TextDrawSetOutline(textGhostFixBug, 1);
	TextDrawBackgroundColor(textGhostFixBug, 256);
	TextDrawFont(textGhostFixBug, 0);
	TextDrawSetProportional(textGhostFixBug, 1);
	TextDrawSetShadow(textGhostFixBug, 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0] = TextDrawCreate(333.764434, 79.166687, "-");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 9.116230, 19.636692);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], -1523963178);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 1);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][0], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0] = TextDrawCreate(397.294097+1.0, 180.666748, "Entrar");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 0.426822, 2.224164);
	TextDrawTextSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 25.000000, 100.000000);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 2);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], -1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], 0);
	TextDrawSetSelectable(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0], true);

	textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1] = TextDrawCreate(333.764434, 121.166725, "-");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 9.116230, 19.636692);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], -1523963178);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 1);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][1], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1] = TextDrawCreate(397.294097+1.0, 223.833328-1.0, "registrar");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 0.426822, 2.224164);
	TextDrawTextSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 25.000000, 100.000000);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 2);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], -1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], 0);
	TextDrawSetSelectable(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1], true);

	textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2] = TextDrawCreate(333.764434, 160.833358, "-");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 9.116230, 19.636692);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], -1523963178);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 1);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][2], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2] = TextDrawCreate(397.294097+1.0, 262.916748, "sobre");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 0.426822, 2.224164);
	TextDrawTextSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 22.000000, 100.000000);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 2);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], -1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], 0);
	TextDrawSetSelectable(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][2], true);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3] = TextDrawCreate(446.705780, 293.250091, ConvertToGameText("versão ~r~~h~" #VERSION_MAJOR "~w~.~r~~h~" #VERSION_MINOR "~w~.~r~~h~" #VERSION_BUILD "~w~~h~" #VERSION_RELEASE_ABBREV));
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 0.141644, 0.777495);
	TextDrawTextSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 490.000000, 8.000000);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 3);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], -1/*-1378294017*/);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], 0);
	TextDrawSetSelectable(textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3], true);
}

CreateGlobalTDMenu()
{
	textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND] = TextDrawCreate(333.234893, 171.333251, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 173.294021, 129.083374);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_MAIN_BACKGROUND], 0);

	textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND] = TextDrawCreate(333.234893, 171.333251, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 173.409774, 166.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND], 0);

	textGlobalMenu[E_TEXT_BACKGROUND_TITLE] = TextDrawCreate(333.235229, 171.333145, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 173.294021, 28.749980);
	TextDrawAlignment(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BACKGROUND_TITLE], 0);

	textGlobalMenu[E_TEXT_BUTTON_BACK] = TextDrawCreate(493.338867, 171.916732, "<");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_BUTTON_BACK], 0.292706, 2.848334);
	TextDrawTextSize(textGlobalMenu[E_TEXT_BUTTON_BACK], 504.000000, 18.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_BUTTON_BACK], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_BUTTON_BACK], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BUTTON_BACK], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_BUTTON_BACK], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_BUTTON_BACK], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_BUTTON_BACK], 0);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_BUTTON_BACK], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BUTTON_BACK], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_BUTTON_BACK], true);

	textGlobalMenu[E_TEXT_USERNAME_ICON][0] = TextDrawCreate(360.528839, 227.333312, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 130.470581, 0.750000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_USERNAME_ICON][0], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_USERNAME_ICON][0], 0);

	textGlobalMenu[E_TEXT_USERNAME_ICON][1] = TextDrawCreate(345.940765, 210.416641, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_USERNAME_ICON][1], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_USERNAME_ICON][1], 0);

	textGlobalMenu[E_TEXT_USERNAME_ICON][2] = TextDrawCreate(349.235046, 213.916610, "hud:radar_gangG");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 8.588225, 10.666678);
	TextDrawAlignment(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 255);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_USERNAME_ICON][2], 0);

	textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE] = TextDrawCreate(479.117767, 214.499893, "hud:radar_modGarage");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 9.529397, 10.083333);
	TextDrawAlignment(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_BUTTON_USERNAME_CHANGE], true);

	textGlobalMenu[E_TEXT_PASSWORD_ICON][0] = TextDrawCreate(360.528900, 256.499786, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 130.470581, 0.750000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_PASSWORD_ICON][0], 0);

	textGlobalMenu[E_TEXT_PASSWORD_ICON][1] = TextDrawCreate(345.940826, 239.583297, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_PASSWORD_ICON][1], 0);

	textGlobalMenu[E_TEXT_PASSWORD_ICON][2] = TextDrawCreate(344.529205, 238.999908, "");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 18.941146, 18.833345);
	TextDrawAlignment(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 255);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 0);
	TextDrawFont(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 5);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 0);
	TextDrawSetPreviewModel(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 19804);
	TextDrawSetPreviewRot(textGlobalMenu[E_TEXT_PASSWORD_ICON][2], 0.000000, 0.000000, 0.000000, 1.000000);

	textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW] = TextDrawCreate(479.117523, 243.666625, "hud:radar_mafiaCasino");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 9.529397, 10.083333);
	TextDrawAlignment(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_BUTTON_PASSWORD_VIEW], true);
	/*
	------------------------------------------------------------------------------------------------------------*/
	textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0] = TextDrawCreate(340.823425, 176.583267, "ENTRAR");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 0.299293, 1.716665);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][0], 0);

	textGlobalMenu[E_TEXT_LOGIN_BUTTON][0] = TextDrawCreate(345.941162, 268.749938, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 49.058811, 22.916677);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_LOGIN_BUTTON][0], true);

	textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1] = TextDrawCreate(370.941009, 274.000030, "logar");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 2);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][1], 0);

	textGlobalMenu[E_TEXT_LOGIN_BUTTON][1] = TextDrawCreate(396.822906, 282.166717, "esqueceu_sua_senha?");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 0.153411, 1.016664);
	TextDrawTextSize(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 469.000000, 8.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_LOGIN_BUTTON][1], true);

	textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2] = TextDrawCreate(396.293670, 290.916748, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 72.588211, 0.750000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_BACKGROUND][2], 0);

	textGlobalMenu[E_TEXT_LOGIN_INVALID][0] = TextDrawCreate(339.381866, 208.666610, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 161.000000, 85.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_INVALID][0], 0);

	textGlobalMenu[E_TEXT_LOGIN_INVALID][1] = TextDrawCreate(419.667541, 239.583404, ConvertToGameText("Você_precisa_se_registrar_para~n~poder_logar!"));
	TextDrawLetterSize(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 2);
	TextDrawColor(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_LOGIN_INVALID][1], 0);
	/*
	------------------------------------------------------------------------------------------------------------*/
	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0] = TextDrawCreate(340.823425, 176.583267, "REGISTRAR");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 0.299293, 1.716665);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0], 0);

	textGlobalMenu[E_TEXT_REGISTER_BUTTON][0] = TextDrawCreate(345.941223, 306.083923, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 71.000000, 23.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_REGISTER_BUTTON][0], true);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1] = TextDrawCreate(381.717254, 311.333984, "REGISTRAR");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 2);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][1], 0);

	textGlobalMenu[E_TEXT_REGISTER_BUTTON][1] = TextDrawCreate(358.872833, 291.500549, "Eu li e concordo com os ~l~termos.");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 0.229779, 1.069162);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 481.000000, 8.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 1);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_REGISTER_BUTTON][1], true);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2] = TextDrawCreate(360.528900, 285.666839, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 130.470581, 0.750000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][2], 0);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3] = TextDrawCreate(345.940826, 268.750061, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][3], 0);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4] = TextDrawCreate(347.928527, 273.416412, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 11.699995, 8.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 255);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 0);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][4], 0);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5] = TextDrawCreate(351.844879, 271.083343, "/");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 0.520407, 0.958333);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][5], 0);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6] = TextDrawCreate(355.593139, 271.083343, "/");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], -0.520174, 0.958333);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][6], 0);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7] = TextDrawCreate(352.781890, 281.583129, "/");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], -0.280292, -0.552500);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][7], 0);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8] = TextDrawCreate(354.656036, 281.583129, "/");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 0.280995, -0.552500);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][8], 0);

	textGlobalMenu[E_TEXT_REGISTER_BUTTON][2] = TextDrawCreate(350.626037, 293.250122, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 7.000000, 7.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], 0);
	TextDrawSetSelectable(textGlobalMenu[E_TEXT_REGISTER_BUTTON][2], true);

	textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9] = TextDrawCreate(452.192108, 300.250335, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 26.000000, 0.499998);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], -1717986817);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][9], 0);

	textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX] = TextDrawCreate(351.831481, 294.416687, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 4.750000, 4.449985);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_TERMS_CHECKBOX], 0);

	textGlobalMenu[E_TEXT_REGISTER_INVALID][0] = TextDrawCreate(339.381866, 208.666610, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 161.000000, 121.000000);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 1);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], -1523963137);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 4);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_INVALID][0], 0);

	textGlobalMenu[E_TEXT_REGISTER_INVALID][1] = TextDrawCreate(420.136077, 251.833297, ConvertToGameText("Esta conta já está registrada.~n~Use o botão ~l~Entrar~w~ no menu~n~para fazer o login."));
	TextDrawLetterSize(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 2);
	TextDrawColor(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], -1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 0);
	TextDrawSetOutline(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 0);
	TextDrawBackgroundColor(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 255);
	TextDrawFont(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 2);
	TextDrawSetProportional(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 1);
	TextDrawSetShadow(textGlobalMenu[E_TEXT_REGISTER_INVALID][1], 0);
}

CreatePrivateTDMenu(playerid)
{
	textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME] = CreatePlayerTextDraw(playerid, 364.352478, 213.333374, "username");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 477.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 1);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], 0);
	//PlayerTextDrawSetSelectable(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_USERNAME], true);

	textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD] = CreatePlayerTextDraw(playerid, 364.352661, 242.499969, "senha");
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 477.000000, 13.000000);
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 0.213174, 1.109997);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 1);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_PASSWORD], true);

	textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL] = CreatePlayerTextDraw(playerid, 364.352661, 271.666870, "EMAIL");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 490.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 1);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_EMAIL], true);
}

ShowPlayerTempTDRegisterCode(playerid)
{
	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0] = CreatePlayerTextDraw(playerid, 420.136077, 213.916732, ConvertToGameText("Seu registro está quase~n~completo!~n~para_prosseguir_insira_abaixo~n~o_código_de_confirmação_que~n~foi_enviado_para_seu_email."));
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 0.223995, 1.209164);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 2);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], -1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][0], 0);

	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1] = CreatePlayerTextDraw(playerid, 400.822326, 286.832946, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 39.000000, 0.400000);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 1);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 4);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][1], 0);

	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2] = CreatePlayerTextDraw(playerid, 420.107391, 276.333190, ConvertToGameText("código"));
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 10.000000, 38.000000);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 2);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][2], true);

	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3] = CreatePlayerTextDraw(playerid, 400.871582, 290.333099, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 39.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 1);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 4);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][3], true);

	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4] = CreatePlayerTextDraw(playerid, 420.250122, 290.916168, "reenviar");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 0.182605, 1.104167);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 2);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], -1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][4], 0);

	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5] = CreatePlayerTextDraw(playerid, 400.871582, 304.916625, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 39.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 1);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 4);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][5], true);

	textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6] = CreatePlayerTextDraw(playerid, 420.250122, 305.499725, "email");
	PlayerTextDrawLetterSize(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 0.182605, 1.104167);
	PlayerTextDrawAlignment(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 2);
	PlayerTextDrawColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], -1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 255);
	PlayerTextDrawFont(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][6], 0);

	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
	TextDrawShowForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_INVALID][0]);

	for(new i; i < 7; i++)
		PlayerTextDrawShow(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][i]);

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_REGISTER_CODE;
}

HidePlayerTempTDRegisterCode(playerid)
{
	for(new i; i < 7; i++)
		PlayerTextDrawDestroy(playerid, textPrivateMenu[playerid][E_MENU_PLAYER_TEMP_CODE][i]);

	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_MAIN_BACKGROUND]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BACKGROUND_TITLE]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_BACKGROUND][0]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_BUTTON_BACK]);
	TextDrawHideForPlayer(playerid, textGlobalMenu[E_TEXT_REGISTER_INVALID][0]);

	playerMenuLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
}