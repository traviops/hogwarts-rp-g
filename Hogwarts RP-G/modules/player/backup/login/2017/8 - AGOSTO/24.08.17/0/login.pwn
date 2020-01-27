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
#include <YSI\y_hooks>
#include <FCNPC>
#include <hogfader>
#include <magicanimation>
/*
 * DEFINITIONS
 ******************************************************************************
 */
#define NPC_LOGIN_SCENARIO_NAME "NPC_LOGIN_CENARIO"

forward	StartFadeOut(playerid);
forward	ShowTextDrawsLoginScreen(playerid, tape);
forward	OnFadeScreenPlayerChanged(playerid, bool:fadeType);

const

	SCENARIO_WEATHER		= 78,
	NPC_LOGIN_SCENARIO_SKIN	= 171,

	LOGIN_VIRTUAL_WORLD = 99,

	MAX_PASSWORD_SIZE	= 20,
	MAX_EMAIL_SIZE		= 64,

	RESEND_MAIL_TIME	= 30,

	MENU_NONE				= -1,
	MENU_HOME				= 0,
	MENU_LOGIN				= 1,
	MENU_REGISTER			= 2,
	MENU_REGISTER_CODE		= 3,
	MENU_LOGIN_INVALID		= 4,
	MENU_REGISTER_INVALID	= 5,

	DIALOG_MENU_REGISTER_USERNAME	=	0,
	DIALOG_MENU_REGISTER_PASSWORD	=	1,
	DIALOG_MENU_REGISTER_EMAIL		=	2,
	DIALOG_MENU_REGISTER_CODE		=	3,
	DIALOG_MENU_REGISTER_CANCEL		=	4,
	DIALOG_MENU_REGISTER_MESSAGE	=	5;
/*
 * ENUMERATORS
 ******************************************************************************
 */
enum E_TEXT_GLOBAL_LOGIN_SCREEN
{
	Text:E_LOGIN_SCREEN_TITLE[3],
	Text:E_LOGIN_SCREEN_BUTTON[3],
	Text:E_LOGIN_SCREEN_TEXT[4]
}

enum E_TEXT_GLOBAL_LOGIN_PLAYER
{
	Text:E_LOGIN_PLAYER_BACKGROUND[11],
	Text:E_LOGIN_PLAYER_BUTTON[4],
	Text:E_LOGIN_PLAYER_ERROR[2]
}

enum E_TEXT_PRIVATE_LOGIN_PLAYER
{
	PlayerText:E_LOGIN_PLAYER_USERNAME,
	PlayerText:E_LOGIN_PLAYER_PASSWORD
}

enum E_TEXT_GLOBAL_REGISTER_PLAYER
{
	Text:E_REGISTER_PLAYER_BACKGROUND[18],
	Text:E_REGISTER_PLAYER_BUTTON[5],
	Text:E_REGISTER_PLAYER_CHECKBOX,
	Text:E_REGISTER_PLAYER_ERROR[2]
}

enum E_TEXT_PRIVATE_REGISTER_PLAYER
{
	PlayerText:E_REGISTER_PLAYER_USERNAME,
	PlayerText:E_REGISTER_PLAYER_PASSWORD,
	PlayerText:E_REGISTER_PLAYER_EMAIL,
	PlayerText:E_REGISTER_PLAYER_TEMP_CODE[7]
}

enum E_NPC_LOGIN_SCENARIO
{
	E_NPC_ID,
	bool:E_NPC_ANIMATING
}

enum E_PLAYER_LOGIN_CONTROL
{
	E_PLAYER_IN_MENU,
	bool:E_PLAYER_MASK_PASSWORD,
	bool:E_PLAYER_REGISTERING,
	bool:E_REGISTER_CHECKBOX_TERMS,
}

enum E_PLAYER_DATA_TEMP
{
	E_PLAYER_PASSWORD_TEMP[MAX_PASSWORD_SIZE + 1],
	E_PLAYER_EMAIL_TEMP[MAX_EMAIL_SIZE],
	E_PLAYER_VERIFICATION_CODE,
	E_PLAYER_EMAIL_SENT_TIME,
	E_PLAYER_EMAIL_CHANGED_TIME
}
/*
 * VARIABLES
 ******************************************************************************
 */
static

	Text:textGlobalLoginScreen[E_TEXT_GLOBAL_LOGIN_SCREEN],

	Text:textGlobalLoginPlayer[E_TEXT_GLOBAL_LOGIN_PLAYER],
	PlayerText:textPrivateLoginPlayer[MAX_PLAYERS char][E_TEXT_PRIVATE_LOGIN_PLAYER],

	Text:textGlobalRegisterPlayer[E_TEXT_GLOBAL_REGISTER_PLAYER],
	PlayerText:textPrivateRegisterPlayer[MAX_PLAYERS char][E_TEXT_PRIVATE_REGISTER_PLAYER],

	Text:textGlobalMenuBack,

	bool:playerInLoginScreen[MAX_PLAYERS char],
	playerLoginControl[MAX_PLAYERS char][E_PLAYER_LOGIN_CONTROL],
	playerDataTemp[MAX_PLAYERS char][E_PLAYER_DATA_TEMP],

	mapBlock,

	npcLoginScenario[E_NPC_LOGIN_SCENARIO],
	playerDeath[MAX_PLAYERS];

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
hook OnGameModeInit()
{
	ModuleInit("player/login.pwn");

	CreateGlobalTDLoginScreen();
	CreateGlobalTDLoginPlayer();
	CreateGlobalTDRegisterPlayer();

	CreateNPCLoginScenario();

	mapBlock = GangZoneCreate(-10000.0, -11000.0, 10000.0, 11000.0);

	return 1;
}

hook OnPlayerConnect(playerid)
{
	playerInLoginScreen[playerid] = true;
	playerDeath[playerid] = false;

	CreatePlayerFade(playerid, true);

	CreatePrivateTDLoginPlayer(playerid);
	CreatePrivateTDRegisterPlayer(playerid);

	ResetPlayerLoginControl(playerid);

	OpenLoginScreenToPlayer(playerid);

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
		HidePlayerTempTDRegisterCode(playerid);

	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(playerInLoginScreen[playerid])
		PositionPlayerLoginScreen(playerid);

	return 1;
}

hook OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
   
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

hook OnPlayerDeath(playerid, killerid, reason)
{
	playerDeath[playerid] = true;

	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][0])//entrar
		ShowPlayerLoginMenu(playerid);

	else if(clickedid == textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][1])//registrar
		ShowPlayerRegisterMenu(playerid);

	else if(clickedid == textGlobalMenuBack && playerLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_NONE)//voltar
	{
		switch(playerLoginControl[playerid][E_PLAYER_IN_MENU])
		{
			case MENU_LOGIN, MENU_LOGIN_INVALID:
				HidePlayerLoginMenu(playerid);

			case MENU_REGISTER, MENU_REGISTER_CODE:
			{
				if(playerLoginControl[playerid][E_PLAYER_REGISTERING])
				{
					CancelSelectTextDraw(playerid);
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CANCEL, DIALOG_STYLE_MSGBOX, "Cancelar registro", "Você tem certeza de que deseja voltar e cancelar o registro?", "Sim", "Não");
				}
				
				if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					HidePlayerTempTDRegisterCode(playerid);
				else
					HidePlayerRegisterMenu(playerid);
			}

			case MENU_REGISTER_INVALID:
				HidePlayerRegisterMenu(playerid);
		}

		ShowPlayerHomeMenu(playerid);
	}

	else if(clickedid == textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0])//alterar username
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", "Nome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
	}
	
	else if(clickedid == textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1])//mostrar/esconder senha
	{
		if(isnull(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]))
			return 1;

		if((playerLoginControl[playerid][E_PLAYER_MASK_PASSWORD] = !playerLoginControl[playerid][E_PLAYER_MASK_PASSWORD]))
		{
			PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], MaskPassword(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]));
		}
		else
			PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]);

		PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD]);
	}

	else if(clickedid == textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2])//registrar
	{
		if(isnull(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP]))
			return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Dados incompletos", WARNING_CHAR "Você precisa inserir uma senha para se registrar!\n\nClique sobre 'senha' para inserir.", "Confirmar", "");
		
		if(isnull(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP]))
			return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Dados incompletos", WARNING_CHAR "Você precisa inserir um email para se registrar!\n\nClique sobre 'email' para inserir.", "Confirmar", "");
		
		if(!playerLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS])
			return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Dados incompletos", WARNING_CHAR "Você precisa aceitar os termos para se registrar!\n\nMarque a opção \"Eu li e concordo com os termos\" para seguir.\nVocê pode ver os termos clicando em 'termos' destacado.", "Confirmar", "");
		
		playerDataTemp[playerid][E_PLAYER_EMAIL_CHANGED_TIME] = playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] = 0;

		SendRegisterMail(playerid);
		HidePlayerRegisterMenu(playerid);
		ShowPlayerTempTDRegisterCode(playerid);
	}

	else if(clickedid == textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4])//checkbox termos
	{
		if((playerLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS] = !playerLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS]))
			TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX]);
		else
			TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX]);
	}

	return 1;
}

hook OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	/*if(playertextid == textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME])
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", "Nome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));
	}*/

	if(playertextid == textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD])
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_PASSWORD, DIALOG_STYLE_INPUT, "Inserir senha", "Insira uma senha com no mínimo 3 e no máximo %d caracteres.\n\n{E84F33}OBS{BCD2EE}: O " GetModeName " utiliza criptografia hash em senhas de ponta-a-ponta,\nde maneira que nem mesmo os desenvolvedores terão acesso a sua senha.", "Confirmar", "Voltar", MAX_PASSWORD_SIZE);
	}

	else if(playertextid == textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL])
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Inserir email", "Insira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Confirmar", "Voltar");
	}

	else if(playertextid == textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2])//inserir código
	{
		CancelSelectTextDraw(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CODE, DIALOG_STYLE_INPUT, "Inserir código de verificação", "Insira abaixo o código de verificação recebido para concluir o registro.\n\n{E84F33}OBS¹{BCD2EE}: Caso não tenha recebido o email, clique em voltar e selecione a\nopção 'reenviar' para enviar novamente.\n\n{E84F33}OBS²{BCD2EE}: Se digitou o email errado, clique em voltar e selecione a opção\n'email' para alterar.", "Continuar", "Voltar");
	}

	else if(playertextid == textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3])//reenviar email
	{
		CancelSelectTextDraw(playerid);

		if(gettime() - playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] < RESEND_MAIL_TIME)
			return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Aguarde para reenviar email", "Aguarde para enviar um email novamente. Normalmente\nos emails são enviados em menos de 1 minuto.\n\nCaso não o encontre em sua caixa de entrada, verifique\na caixa de spam!", "Confirmar", "");

		SendRegisterMail(playerid);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Email reenviado", "Foi enviado um email com um novo código de verificação!\n\nCaso não o encontre em sua caixa de entrada, verifique a\ncaixa de spam!", "Confirmar", "");
	}

	else if(playertextid == textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5])//alterar email
	{
		CancelSelectTextDraw(playerid);

		if(gettime() - playerDataTemp[playerid][E_PLAYER_EMAIL_CHANGED_TIME] < RESEND_MAIL_TIME)
			return ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Aguarde para alterar email", "Aguarde para alterar seu email novamente. Um email já foi enviado\npara {E84F33}%s{BCD2EE}, cheque sua caixa de entrada e spam.", "Confirmar", "", playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP]);

		ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", "Insira abaixo um novo email válido que você tenha acesso.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
	}

	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_MENU_REGISTER_USERNAME:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext) || !(3 <= strlen(inputtext) <= 20))
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Você deve inserir algum nome de 3 a 20 caracteres.\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));

			if(!IsValidPlayerName(inputtext))
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Nome inválido! Caracteres aceitos: A a Z, 0 a 9 e _(underline).\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));

			if(!strcmp(inputtext, GetNameOfPlayer(playerid), true, MAX_PLAYER_NAME))
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_USERNAME, DIALOG_STYLE_INPUT, "Alterar nome", WARNING_CHAR "Você já está utilizando esse nome!\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.", "Confirmar", "Voltar", GetNameOfPlayer(playerid));

			if(!playerLoginControl[playerid][E_PLAYER_REGISTERING])
				playerLoginControl[playerid][E_PLAYER_REGISTERING] = true;

			SetPlayerName(playerid, inputtext);

			PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], inputtext);
			PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME]);

			SelectTextDraw(playerid, 0x757575FF);
			return 1;
		}
		case DIALOG_MENU_REGISTER_PASSWORD:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext) || !(3 <= strlen(inputtext) <= MAX_PASSWORD_SIZE))
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_PASSWORD, DIALOG_STYLE_INPUT, "Inserir senha", WARNING_CHAR "Senha inválida! A senha deve conter entre 3 a %d caracteres.\n\n{E84F33}OBS{BCD2EE}: O " GetModeName " utiliza criptografia hash em senhas de ponta-a-ponta,\nde maneira que nem mesmo os desenvolvedores terão acesso a sua senha.", "Confirmar", "Voltar", MAX_PASSWORD_SIZE);

			if(!playerLoginControl[playerid][E_PLAYER_REGISTERING])
				playerLoginControl[playerid][E_PLAYER_REGISTERING] = true;

			format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, inputtext);

			PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], ((playerLoginControl[playerid][E_PLAYER_MASK_PASSWORD]) ? (MaskPassword(inputtext)) : (inputtext)));
			PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD]);

			SelectTextDraw(playerid, 0x757575FF);
			return 1;
		}
		case DIALOG_MENU_REGISTER_EMAIL:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			if(isnull(inputtext))
			{
				if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", WARNING_CHAR "Caixa de texto vazia! Insira algum email.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
				else
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Inserir email", WARNING_CHAR "Caixa de texto vazia! Insira algum email.\n\nInsira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Confirmar", "Voltar");
			}

			if(!IsValidEmail(inputtext))
			{
				if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", WARNING_CHAR "Email inválido! Caracteres aceitos: A a Z, 0 a 9, @(arroba), _(underline), .(ponto) e -(hífen).\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
				else
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Inserir email", WARNING_CHAR "Email inválido! Caracteres aceitos: A a Z, 0 a 9, @(arroba), _(underline), .(ponto) e -(hífen).\n\nInsira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Confirmar", "Voltar");
			}

			if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
			{
				if(!strcmp(inputtext, playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], true, MAX_EMAIL_SIZE))
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Alterar email", WARNING_CHAR "Você já está usando este email! Insira outro.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.", "Alterar", "Voltar");
			}

			if(!playerLoginControl[playerid][E_PLAYER_REGISTERING])
				playerLoginControl[playerid][E_PLAYER_REGISTERING] = true;

			format(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], MAX_EMAIL_SIZE, inputtext);

			if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
			{
				SendRegisterMail(playerid);
				return ShowPlayerDialogFormat(playerid, DIALOG_MENU_REGISTER_MESSAGE, DIALOG_STYLE_MSGBOX, "Email alterado", "Seu email foi alterado para {E84F33}%s{BCD2EE}.\n\nFoi enviado um email com um novo código de verificação.", "Confirmar", "", inputtext);
			}

			PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], inputtext);
			PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL]);

			SelectTextDraw(playerid, 0x757575FF);
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
			
			fadeIn(playerid, 50);
		}
		case DIALOG_MENU_REGISTER_CANCEL:
		{
			if(!response)
				return SelectTextDraw(playerid, 0x757575FF);

			SelectTextDraw(playerid, 0x757575FF);

			HidePlayerRegisterMenu(playerid);
			ShowPlayerHomeMenu(playerid);
		}
		case DIALOG_MENU_REGISTER_MESSAGE:
			return SelectTextDraw(playerid, 0x757575FF);

	}
	return 1;
}
/*
 * MY CALLBACKS
 ******************************************************************************
 */
public OnPlayerHideCursor(playerid, hovercolor)
{
	if(playerLoginControl[playerid][E_PLAYER_IN_MENU] != MENU_NONE)//voltar
	{
		switch(playerLoginControl[playerid][E_PLAYER_IN_MENU])
		{
			case MENU_LOGIN, MENU_LOGIN_INVALID:
				HidePlayerLoginMenu(playerid);

			case MENU_REGISTER, MENU_REGISTER_CODE:
			{
				if(playerLoginControl[playerid][E_PLAYER_REGISTERING])
					return ShowPlayerDialog(playerid, DIALOG_MENU_REGISTER_CANCEL, DIALOG_STYLE_MSGBOX, "Cancelar registro", "Você tem certeza de que deseja voltar e cancelar o registro?", "Sim", "Não");
				
				if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_CODE)
					HidePlayerTempTDRegisterCode(playerid);
				else
					HidePlayerRegisterMenu(playerid);
			}

			case MENU_REGISTER_INVALID:
				HidePlayerRegisterMenu(playerid);

			case MENU_HOME:
				return SelectTextDraw(playerid, 0x757575FF);
		}

		ShowPlayerHomeMenu(playerid);
		SelectTextDraw(playerid, 0x757575FF);
	}

	return 1;
}

public StartFadeOut(playerid)
	fadeOut(playerid, 50);

public ShowTextDrawsLoginScreen(playerid, tape)
{
	switch(tape)
	{
		case 0:
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1]),
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2]),
			playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_HOME;
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
			TextDrawShowForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3]);
	}

	if(tape != 4) SetTimerEx("ShowTextDrawsLoginScreen", 200, false, "ii", playerid, tape + 1);
}

public OnFadeScreenPlayerChanged(playerid, bool:fadeType)
{
	if(fadeType == FADE_OUT)
		ShowTextDrawsLoginScreen(playerid, 0);
}
/*
 * FUNCTIONS
 ******************************************************************************
 */
SendRegisterMail(playerid)
{
	playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE] = random(8999) + 1000;
	playerDataTemp[playerid][E_PLAYER_EMAIL_SENT_TIME] = gettime();

	SendEmail(MAILER_SENDER, playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], GetModeName, MailRegisterCode(GetNameOfPlayer(playerid), playerDataTemp[playerid][E_PLAYER_VERIFICATION_CODE]));
}
/*
-----------------------------------------------------------------------------*/
ResetPlayerLoginControl(playerid)
{
	playerLoginControl[playerid][E_PLAYER_MASK_PASSWORD] = true;
	playerLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS] = false;
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
/*OutPlayerOfScenario(playerid)
{
	static i;

	for(i = 0; i < 4; i++)
	{
		TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][i]);

		if(i < 3)
			TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][i]),
			TextDrawHideForPlayer(playerid, textGlobalLoginScreen[E_LOGIN_SCREEN_BUTTON][i]);
	}

	playerInLoginScreen[playerid] = false;

	CancelSelectTextDraw(playerid);

	SetCameraBehindPlayer(playerid);

	TogglePlayerSpectating(playerid, 0);

    SetPlayerVirtualWorld(playerid, 0);

    SetPlayerInterior(playerid, 11);

	TogglePlayerControllable(playerid, true);

	SetPlayerToSpawn(playerid);
}*/
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
}
//---------------------------
ShowPlayerLoginMenu(playerid)
{
	HidePlayerHomeMenu(playerid);

	if(!IsPlayerRegistred(playerid))
	{
		TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0]);
		TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1]);
		TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2]);
		TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0]);
		TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1]);
		TextDrawShowForPlayer(playerid, textGlobalMenuBack);

		playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_LOGIN_INVALID;
		return;
	}

	static i;

	for(i = 0; i < 11; i++)
	{
		if(i == 9)
			TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2]);
		else if(i < 4 && i != 2)
			TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][i]);

		TextDrawShowForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][i]);
	}

	TextDrawShowForPlayer(playerid, textGlobalMenuBack);

	PlayerTextDrawSetString(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], GetNameOfPlayer(playerid));
	PlayerTextDrawSetString(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], "senha");

	PlayerTextDrawShow(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME]);
	PlayerTextDrawShow(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD]);

	playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_LOGIN;
}

HidePlayerLoginMenu(playerid)
{
	if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_LOGIN_INVALID)
	{
		TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0]);
		TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1]);
		TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2]);
		TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0]);
		TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1]);
		TextDrawHideForPlayer(playerid, textGlobalMenuBack);

		playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
		return;
	}

	static i;

	for(i = 0; i < 11; i++)
	{
		if(i < 4)
			TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][i]);

		TextDrawHideForPlayer(playerid, textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][i]);
	}

	TextDrawHideForPlayer(playerid, textGlobalMenuBack);

	PlayerTextDrawHide(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME]);
	PlayerTextDrawHide(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD]);

	playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
}
//------------------------------
ShowPlayerRegisterMenu(playerid)
{
	HidePlayerHomeMenu(playerid);

	if(IsPlayerRegistred(playerid))
	{
		TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0]);
		TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1]);
		TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2]);
		TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0]);
		TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1]);
		TextDrawShowForPlayer(playerid, textGlobalMenuBack);

		playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_REGISTER_INVALID;
		return;
	}

	static i;

	for(i = 0; i < 18; i++)
	{
		if(i == 8)
			TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2]);
		else if(i < 5 && i != 2)
			TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][i]);

		TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][i]);
	}

	TextDrawShowForPlayer(playerid, textGlobalMenuBack);

	PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], GetNameOfPlayer(playerid));
	PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], "senha");
	PlayerTextDrawSetString(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], "email");

	PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME]);
	PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD]);
	PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL]);

	format(playerDataTemp[playerid][E_PLAYER_PASSWORD_TEMP], MAX_PASSWORD_SIZE, "");
	format(playerDataTemp[playerid][E_PLAYER_EMAIL_TEMP], MAX_EMAIL_SIZE, "");

	playerLoginControl[playerid][E_REGISTER_CHECKBOX_TERMS] = playerLoginControl[playerid][E_PLAYER_REGISTERING] = false;

	playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_REGISTER;
}

HidePlayerRegisterMenu(playerid)
{
	if(playerLoginControl[playerid][E_PLAYER_IN_MENU] == MENU_REGISTER_INVALID)
	{
		TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0]);
		TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1]);
		TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2]);
		TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0]);
		TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1]);
		TextDrawHideForPlayer(playerid, textGlobalMenuBack);

		playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
		return;
	}

	static i;

	for(i = 0; i < 18; i++)
	{
		if(i < 5)
			TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][i]);

		TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][i]);
	}

	TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX]);

	TextDrawHideForPlayer(playerid, textGlobalMenuBack);

	PlayerTextDrawHide(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME]);
	PlayerTextDrawHide(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD]);
	PlayerTextDrawHide(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL]);

	playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
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
	if(!FCNPC_IsValid(NPC_LOGIN_SCENARIO))
		return printf(" <!> Erro ao parar animação mágica do NPC_LOGIN_SCENARIO");

	if(!npcLoginScenario[E_NPC_ANIMATING])
		return false;
	
	npcLoginScenario[E_NPC_ANIMATING] = false;

	StopFloatNPC(npcid);

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
	SetPlayerPos(playerid, 319.4734, 8829.8604, 12.9612);

	TogglePlayerControllable(playerid, false);

	SelectTextDraw(playerid, 0x757575FF/*0xDDDDDDAA*/);

	LoadPlayerLoginScenario(playerid);

	SetTimerEx("StartFadeOut", 3000, false, "i", playerid);
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
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][0], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1] = TextDrawCreate(369.058837, 141.583312, "ogwarts");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0.406587, 1.920830);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], -1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][1], 0);

	textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2] = TextDrawCreate(431.646972, 155.000030, "rp/g");
	TextDrawLetterSize(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0.152941, 1.144997);
	TextDrawAlignment(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 1);
	TextDrawColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], -1523963137);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0);
	TextDrawSetOutline(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0);
	TextDrawBackgroundColor(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 255);
	TextDrawFont(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 2);
	TextDrawSetProportional(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 1);
	TextDrawSetShadow(textGlobalLoginScreen[E_LOGIN_SCREEN_TITLE][2], 0);

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

	textGlobalLoginScreen[E_LOGIN_SCREEN_TEXT][3] = TextDrawCreate(446.705780, 293.250091, ConvertToGameText("versão ~r~~h~1~w~.~r~~h~0~w~.~r~~h~0~w~~h~a"));
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

CreateGlobalTDLoginPlayer()
{
	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0] = TextDrawCreate(333.234893, 171.333251, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 173.294021, 129.083374);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], -1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][0], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1] = TextDrawCreate(333.235229, 171.333145, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 173.294021, 28.749980);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], -1523963137);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][1], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2] = TextDrawCreate(340.823425, 176.583267, "ENTRAR");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 0.299293, 1.716665);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], -1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 2);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][2], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3] = TextDrawCreate(360.528839, 227.333312, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 130.470581, 0.750002);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], -1717986817);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][3], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4] = TextDrawCreate(345.940765, 210.416641, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], -1717986817);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][4], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5] = TextDrawCreate(349.235046, 213.916610, "hud:radar_gangG");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 8.588225, 10.666678);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 255);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][5], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0] = TextDrawCreate(479.117767, 214.499893, "hud:radar_modGarage");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 9.529397, 10.083333);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], -1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], 0);
	TextDrawSetSelectable(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][0], true);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6] = TextDrawCreate(360.528900, 256.499786, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 130.470581, 0.750002);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], -1717986817);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][6], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7] = TextDrawCreate(345.940826, 239.583297, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], -1717986817);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][7], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8] = TextDrawCreate(344.529205, 238.999908, "");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 18.941146, 18.833345);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 255);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 0);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 5);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 0);
	TextDrawSetPreviewModel(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 19804);
	TextDrawSetPreviewRot(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][8], 0.000000, 0.000000, 0.000000, 1.000000);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1] = TextDrawCreate(479.117523, 243.666625, "hud:radar_mafiaCasino");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 9.529397, 10.083333);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], -1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], 0);
	TextDrawSetSelectable(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][1], true);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2] = TextDrawCreate(345.941162, 268.749938, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 49.058811, 22.916677);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], -1523963137);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], 0);
	TextDrawSetSelectable(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][2], true);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9] = TextDrawCreate(370.941009, 274.000030, "logar");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 2);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], -1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 2);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][9], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3] = TextDrawCreate(396.822906, 282.166717, "esqueceu_sua_senha?");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 0.153411, 1.016664);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 469.000000, 8.000000);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], -1717986817);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 2);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], 0);
	TextDrawSetSelectable(textGlobalLoginPlayer[E_LOGIN_PLAYER_BUTTON][3], true);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10] = TextDrawCreate(396.293670, 290.916748, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 72.588211, 0.750002);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], -1717986817);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_BACKGROUND][10], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0] = TextDrawCreate(339.381866, 208.666610, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 161.000000, 85.000000);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 1);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], -1523963137);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 4);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][0], 0);

	textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1] = TextDrawCreate(419.667541, 239.583404, ConvertToGameText("Você_precisa_se_registrar_para~n~poder_logar!"));
	TextDrawLetterSize(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 2);
	TextDrawColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], -1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 0);
	TextDrawSetOutline(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 0);
	TextDrawBackgroundColor(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 255);
	TextDrawFont(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 2);
	TextDrawSetProportional(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 1);
	TextDrawSetShadow(textGlobalLoginPlayer[E_LOGIN_PLAYER_ERROR][1], 0);

	textGlobalMenuBack = TextDrawCreate(493.338867, 171.916732, "<");
	TextDrawLetterSize(textGlobalMenuBack, 0.292706, 2.848334);
	TextDrawTextSize(textGlobalMenuBack, 504.000000, 18.000000);
	TextDrawAlignment(textGlobalMenuBack, 1);
	TextDrawColor(textGlobalMenuBack, -1);
	TextDrawSetShadow(textGlobalMenuBack, 0);
	TextDrawSetOutline(textGlobalMenuBack, 0);
	TextDrawBackgroundColor(textGlobalMenuBack, 255);
	TextDrawFont(textGlobalMenuBack, 0);
	TextDrawSetProportional(textGlobalMenuBack, 1);
	TextDrawSetShadow(textGlobalMenuBack, 0);
	TextDrawSetSelectable(textGlobalMenuBack, true);
}

CreatePrivateTDLoginPlayer(playerid)
{
	textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME] = CreatePlayerTextDraw(playerid, 364.352478, 213.333374, "username");
	PlayerTextDrawLetterSize(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 477.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 1);
	PlayerTextDrawColor(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 255);
	PlayerTextDrawFont(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], 0);
	//PlayerTextDrawSetSelectable(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_USERNAME], true);

	textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD] = CreatePlayerTextDraw(playerid, 364.352661, 242.499969, "senha");
	PlayerTextDrawTextSize(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 477.000000, 13.000000);
	PlayerTextDrawLetterSize(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 0.213174, 1.109997);
	PlayerTextDrawAlignment(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 1);
	PlayerTextDrawColor(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 255);
	PlayerTextDrawFont(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateLoginPlayer[playerid][E_LOGIN_PLAYER_PASSWORD], true);
}

CreateGlobalTDRegisterPlayer()
{
	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0] = TextDrawCreate(333.234893, 171.333251, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 173.409774, 166.000000);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1] = TextDrawCreate(333.235229, 171.333145, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 173.294021, 28.749980);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], -1523963137);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2] = TextDrawCreate(340.823425, 176.583267, "REGISTRAR");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 0.299293, 1.716665);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3] = TextDrawCreate(360.528839, 227.333312, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 130.470581, 0.750002);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][3], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4] = TextDrawCreate(345.940765, 210.416641, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][4], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5] = TextDrawCreate(349.235046, 213.916610, "hud:radar_gangG");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 8.588225, 10.666678);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 255);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][5], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0] = TextDrawCreate(479.117767, 214.499893, "hud:radar_modGarage");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 9.529397, 10.083333);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], 0);
	TextDrawSetSelectable(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][0], true);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6] = TextDrawCreate(360.528900, 256.499786, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 130.470581, 0.750002);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][6], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7] = TextDrawCreate(345.940826, 239.583297, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][7], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8] = TextDrawCreate(344.529205, 238.999908, "");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 18.941146, 18.833345);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 255);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 0);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 5);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 0);
	TextDrawSetPreviewModel(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 19804);
	TextDrawSetPreviewRot(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][8], 0.000000, 0.000000, 0.000000, 1.000000);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1] = TextDrawCreate(479.117523, 243.666625, "hud:radar_mafiaCasino");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 9.529397, 10.083333);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], 0);
	TextDrawSetSelectable(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][1], true);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2] = TextDrawCreate(345.941223, 306.083923, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 71.000000, 23.000000);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], -1523963137);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], 0);
	TextDrawSetSelectable(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][2], true);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9] = TextDrawCreate(381.717254, 311.333984, "REGISTRAR");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 2);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][9], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3] = TextDrawCreate(358.872833, 291.500549, "Eu li e concordo com os ~l~termos.");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 0.229779, 1.069162);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 481.000000, 8.000000);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], -1523963137);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 1);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], 0);
	TextDrawSetSelectable(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][3], true);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10] = TextDrawCreate(360.528900, 285.666839, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 130.470581, 0.750002);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][10], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11] = TextDrawCreate(345.940826, 268.750061, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 15.647047, 17.666675);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][11], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12] = TextDrawCreate(347.928527, 273.416412, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 11.699995, 8.000000);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 255);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 0);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][12], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13] = TextDrawCreate(351.844879, 271.083343, "/");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 0.520407, 0.958333);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][13], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14] = TextDrawCreate(355.593139, 271.083343, "/");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], -0.520174, 0.958333);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][14], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15] = TextDrawCreate(352.781890, 281.583129, "/");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], -0.280292, -0.552500);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][15], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16] = TextDrawCreate(354.656036, 281.583129, "/");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 0.280995, -0.552500);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][16], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4] = TextDrawCreate(350.626037, 293.250122, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 7.000000, 7.000000);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], 0);
	TextDrawSetSelectable(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BUTTON][4], true);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17] = TextDrawCreate(452.192108, 300.250335, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 26.000000, 0.499998);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], -1717986817);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][17], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX] = TextDrawCreate(351.831481, 294.416687, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 4.750000, 4.449985);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], -1523963137);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_CHECKBOX], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0] = TextDrawCreate(339.381866, 208.666610, "LD_SPAC:white");
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 0.000000, 0.000000);
	TextDrawTextSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 161.000000, 121.000000);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 1);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], -1523963137);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 4);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0], 0);

	textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1] = TextDrawCreate(420.136077, 251.833297, ConvertToGameText("Esta conta já está registrada.~n~Use o botao ~l~Entrar~w~ no menu~n~para fazer o login."));
	TextDrawLetterSize(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 0.223995, 1.209164);
	TextDrawAlignment(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 2);
	TextDrawColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], -1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 0);
	TextDrawSetOutline(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 0);
	TextDrawBackgroundColor(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 255);
	TextDrawFont(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 2);
	TextDrawSetProportional(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 1);
	TextDrawSetShadow(textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][1], 0);
}

CreatePrivateTDRegisterPlayer(playerid)
{
	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME] = CreatePlayerTextDraw(playerid, 364.352478, 213.333374, "username");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 477.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 1);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], 0);
	//PlayerTextDrawSetSelectable(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_USERNAME], true);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD] = CreatePlayerTextDraw(playerid, 364.352661, 242.499969, "senha");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 477.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 1);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_PASSWORD], true);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL] = CreatePlayerTextDraw(playerid, 364.352661, 271.666870, "EMAIL");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 490.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 1);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_EMAIL], true);
}

ShowPlayerTempTDRegisterCode(playerid)
{
	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0] = CreatePlayerTextDraw(playerid, 420.136077, 213.916732, ConvertToGameText("Seu registro está quase~n~completo!~n~para_prosseguir_insira_abaixo~n~o_código_de_confirmação_que~n~foi_enviado_para_seu_email."));
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 0.223995, 1.209164);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 2);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], -1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][0], 0);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1] = CreatePlayerTextDraw(playerid, 400.822326, 286.832946, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 39.000000, 0.400000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 1);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 4);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][1], 0);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2] = CreatePlayerTextDraw(playerid, 420.107391, 276.333190, ConvertToGameText("código"));
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 0.213174, 1.109997);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 10.000000, 38.000000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 2);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][2], true);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3] = CreatePlayerTextDraw(playerid, 400.871582, 290.333099, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 39.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 1);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 4);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][3], true);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4] = CreatePlayerTextDraw(playerid, 420.250122, 290.916168, "reenviar");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 0.182605, 1.104167);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 2);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], -1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][4], 0);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5] = CreatePlayerTextDraw(playerid, 400.871582, 304.916625, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 39.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 1);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], -1717986817);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 4);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], 0);
	PlayerTextDrawSetSelectable(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][5], true);

	textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6] = CreatePlayerTextDraw(playerid, 420.250122, 305.499725, "email");
	PlayerTextDrawLetterSize(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 0.182605, 1.104167);
	PlayerTextDrawAlignment(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 2);
	PlayerTextDrawColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], -1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 0);
	PlayerTextDrawSetOutline(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 0);
	PlayerTextDrawBackgroundColor(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 255);
	PlayerTextDrawFont(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 2);
	PlayerTextDrawSetProportional(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 1);
	PlayerTextDrawSetShadow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][6], 0);

	TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0]);
	TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1]);
	TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2]);
	TextDrawShowForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0]);
	TextDrawShowForPlayer(playerid, textGlobalMenuBack);

	for(new i; i < 7; i++)
		PlayerTextDrawShow(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][i]);

	playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_REGISTER_CODE;
}

HidePlayerTempTDRegisterCode(playerid)
{
	for(new i; i < 7; i++)
		PlayerTextDrawDestroy(playerid, textPrivateRegisterPlayer[playerid][E_REGISTER_PLAYER_TEMP_CODE][i]);

	TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][0]);
	TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][1]);
	TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_BACKGROUND][2]);
	TextDrawHideForPlayer(playerid, textGlobalRegisterPlayer[E_REGISTER_PLAYER_ERROR][0]);
	TextDrawHideForPlayer(playerid, textGlobalMenuBack);

	playerLoginControl[playerid][E_PLAYER_IN_MENU] = MENU_NONE;
}