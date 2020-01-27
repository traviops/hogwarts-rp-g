/*
	Character System(Sistema de personagens)
		- Descrição.

	Copyright (C) 2016  Bruno Travi(Bruno13) Hogwarts RP/G

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
 |INCLUDES|
*/
#include <a_samp>
#include <zcmd>
/*
 *****************************************************************************
*/
/*
 |DEFINITIONS|
*/
//MACROS:
stock stringf[256];
#define SendClientMessageEx(%0,%1,%2,%3) format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
#define call:%0(%1) forward %0(%1); public %0(%1)

//DEFINITIONS:
#define CONVERSATION_TYPE_SPEECH	0
#define CONVERSATION_TYPE_RESPONSE	1

#define MAX_CHARACTERS_SLOTS		5

#define ACCOUNT_TYPE_NORMAL			3
#define ACCOUNT_TYPE_PREMIUM		5

#define CONFIG_RESET_SLOT			0
#define CONFIG_SET_CHAR_SLOT		1
#define CONFIG_BLOCK_SLOT			2

#define STATE_EMPTY					0
#define STATE_CREATED				1
#define STATE_BLOCKED				2

#define INVALID_CHAR_SLOT			-1

#define DIALOG_SLOT_MESSAGE			19888
/*
 *****************************************************************************
*/
/*
 |ENUMERATORS|
*/
enum E_ACTORS_CONVERSATION
{
	E_ANIM_LIB[12],
	E_ANIM_NAME[15],
	E_ANIM_COMPLETION_TIME,
	E_CONVERSATION_TYPE
}
enum E_TEXT_CHAR_SELECTION_GLOBAL
{
	Text:E_HEADER[2],
	Text:E_CHAR_SLOT[MAX_CHARACTERS_SLOTS],
	Text:E_BUTTON_EDIT,
	Text:E_BUTTON_EDIT_TEXT,
	Text:E_BUTTON_EXIT,
	Text:E_BUTTON_EXIT_TEXT,
	Text:E_BUTTON_TRASH,
	Text:E_BUTTON_TRASH_TEXT,
	Text:E_BUTTON_TRASH_ICON,
	Text:E_BUTTON_DELETE[MAX_CHARACTERS_SLOTS]
}
enum E_TEXT_CHAR_SELECTION_PRIVATE
{
	PlayerText:E_CHAR_SLOT_SKIN[MAX_CHARACTERS_SLOTS],
	PlayerText:E_CHAR_SLOT_NAME[MAX_CHARACTERS_SLOTS],
	PlayerText:E_CHAR_SLOT_LAST_ACESS[MAX_CHARACTERS_SLOTS]
}
const
	size_E_CHAR_NAME = MAX_CHARACTERS_SLOTS * MAX_PLAYER_NAME,
	size_E_CHAR_LAST_ACESS = MAX_CHARACTERS_SLOTS * 5;

enum E_PLAYER_CHARACTERS
{
	E_ACCOUNT_TYPE,//TOTAL SLOTS
	E_CHAR_STATE[MAX_CHARACTERS_SLOTS],
	E_CHAR_SKIN[MAX_CHARACTERS_SLOTS],
	E_CHAR_NAME[size_E_CHAR_NAME],
	E_CHAR_LAST_ACESS[size_E_CHAR_LAST_ACESS]//0 - dia | 1 - mês | 2 - ano | 3 - hora | 4 - min
}

#define E_CHAR_NAME][%1][%2] E_CHAR_NAME][((%1)*MAX_PLAYER_NAME)+(%2)]
#define E_CHAR_LAST_ACESS][%1][%2] E_CHAR_LAST_ACESS][((%1)*5)+(%2)]

enum E_TEXT_SELECTED_CONTROL
{
	E_CHAR_SLOT,
	bool:E_BUTTON_EDIT
}
/*
 *****************************************************************************
*/
/*
 |VARIABLES|
*/
new
	/// <summary> 
	///	Variável para armazenamento dos IDs dos atores criados.</summary>
	actorScenario[2],

	/// <summary> 
	///	Variáveis de controle das TextDraws Globais/Privadas.</summary>
	Text:textCharSelectionGlobal[E_TEXT_CHAR_SELECTION_GLOBAL],
	PlayerText:textCharSelectionPrivate[MAX_PLAYERS][E_TEXT_CHAR_SELECTION_PRIVATE],

	/// <summary> 
	///	Variável de controle da TextDraw utilizada para fixar bug das transparências.</summary>
	Text:textBugFix,

	/// <summary>
	/// Variável para controle das TextDraws selecionadas, isso incluí tanto slots quanto botões.</summary>
	textSelectedControl[MAX_PLAYERS][E_TEXT_SELECTED_CONTROL],

	bool:cursorState[MAX_PLAYERS],

	/// <summary> 
	///	Variável de controle de todos personagens do jogador.</summary>
	playerCharacters[MAX_PLAYERS][E_PLAYER_CHARACTERS],

	/// <summary> 
	///	Matriz com animações que serão aplicadas aos atores.</summary>
	actorsConvesation[][E_ACTORS_CONVERSATION] = {
		{"COP_AMBIENT", "Coplook_think", 3812, CONVERSATION_TYPE_RESPONSE},//338
		{"GANGS", "Invite_No", 3453, CONVERSATION_TYPE_RESPONSE},//602
		{"GANGS", "Invite_Yes", 4130, CONVERSATION_TYPE_RESPONSE},//603
		{"GANGS", "prtial_gngtlkA", 4501, CONVERSATION_TYPE_SPEECH},//607
		{"GANGS", "prtial_gngtlkB", 6570, CONVERSATION_TYPE_SPEECH},//608
		{"GANGS", "prtial_gngtlkC", 7306, CONVERSATION_TYPE_SPEECH},//609
		{"GANGS", "prtial_gngtlkD", 3417, CONVERSATION_TYPE_SPEECH},//610
		{"GANGS", "prtial_gngtlkE", 3140, CONVERSATION_TYPE_SPEECH},//611
		{"GANGS", "prtial_gngtlkF", 5182, CONVERSATION_TYPE_SPEECH},//612
		{"GANGS", "prtial_gngtlkG", 6771, CONVERSATION_TYPE_SPEECH},//613
		{"GANGS", "prtial_gngtlkH", 6000, CONVERSATION_TYPE_SPEECH},//614
		{"OTB", "wtchrace_lose", 4526, CONVERSATION_TYPE_RESPONSE},//966
		{"ped", "IDLE_chat", 6804, CONVERSATION_TYPE_SPEECH},//1195
		{"PLAYIDLES", "strleg", 4052, CONVERSATION_TYPE_RESPONSE}//1307
	};
/*
 *****************************************************************************
*/
hook_SelectTextDraw(playerid, hovercolor)
{
	SelectTextDraw(playerid, hovercolor);
	cursorState[playerid] = true;
}
#if defined _ALS_SelectTextDraw
	#undef SelectTextDraw
#else
	#define _ALS_SelectTextDraw
#endif
#define SelectTextDraw hook_SelectTextDraw

hook_CancelSelectTextDraw(playerid)
{
	cursorState[playerid] = false;
    CancelSelectTextDraw(playerid);
}
#if defined _ALS_CancelSelectTextDraw
	#undef CancelSelectTextDraw
#else
	#define _ALS_CancelSelectTextDraw
#endif
#define CancelSelectTextDraw hook_CancelSelectTextDraw
/*
 *****************************************************************************
*/
/*
 |NATIVE CALLBACKS|
*/
public OnFilterScriptInit()
{
	/// <summary>
	/// Nesta callback:
	///		- cria todas TextDraws Globais utilizadas pelo menu Seleção de Personagem.
	///		- cria objetos globais do cenário;
	///		- cria os atores do cenário;
	///		- imprime aviso de carregamento no console.
	/// </summary>

	textBugFix = TextDrawCreate(0.0, 0.0, "fix");
    TextDrawLetterSize(textBugFix, 0.000000, 0.000000);

	CreateGlobalTDCharSelection();

	CreateScenarioGlobal();
	CreateScenarioActors();

	print("\n-----------------------------------------");
	print("      [HOG] Character System loaded");
	print("-----------------------------------------\n");

	return 1;
}
public OnPlayerConnect(playerid)
{
	/// <summary>
	/// Nesta callback:
	///		- mostra TextDraw responsável por fixar o bug das transparências.
	///		- cria todas TextDraws Privadas utilizadas pelo menu Seleção de Personagem.
	///		- cria objetos privados do cenário.
	///		- configura os valores dos personagens do player(valores iniciais para testes).
	/// </summary>

	TextDrawShowForPlayer(playerid, textBugFix);

	CreatePrivateTDCharSelection(playerid);

	CreateScenarioPrivate(playerid);

	ConfigureMenuSelectionCharacter(playerid);

	ConfigureCharactersValues(playerid);

	return 1;
}
public OnPlayerSpawn(playerid)
{
	/// <summary>
	/// Nesta callback:
	///		- carrega o cenário ao jogador.
	/// </summary>

	LoadScenario(playerid);

	ShowMenuSelectionCharacter(playerid);

	return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW && cursorState[playerid])
	{
	    //esc pressed
	}

	if(clickedid == textCharSelectionGlobal[E_BUTTON_EDIT])
	{
		if((textSelectedControl[playerid][E_BUTTON_EDIT] = !textSelectedControl[playerid][E_BUTTON_EDIT]))
		{
			TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH]);
			TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH_TEXT]);
			TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH_ICON]);

			for(new i; i < 5; i++) TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_DELETE][i]);
		}
		else
		{
			TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH]);
			TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH_TEXT]);
			TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH_ICON]);

			for(new i; i < 5; i++) TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_DELETE][i]);
		}
	}

	for(new i; i < MAX_CHARACTERS_SLOTS; i++)
	{
		if(clickedid == textCharSelectionGlobal[E_CHAR_SLOT][i])
		{
			if(playerCharacters[playerid][E_CHAR_STATE][i] == STATE_BLOCKED)
			{
				CancelSelectTextDraw(playerid);

				ShowPlayerDialog(playerid, DIALOG_SLOT_MESSAGE, DIALOG_STYLE_MSGBOX, "Slot bloqueado", "Este slot está bloqueado. Para saber como adquirí-lo acesse:\n\tMinha conta > planos premium", "Confirmar", "");
			}
		}
	}
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SLOT_MESSAGE)
	{
		SelectTextDraw(playerid, 0xDDDDDD40);
	}

	return 1;
}
/*
 *****************************************************************************
*/
/*
 |MY CALLBACKS|
*/
/// <summary>
/// Timer para aplicar as animações aos atores, de maneira
/// animações randômicas sejam aplicadas e não parem de rodar.
/// Intervalo: Definido pela matriz 'actorsConversation'
/// </summary>
/// <param name="actorID">ID do ator a ser aplicado a animação.</param>
/// <param name="conversationType">Tipo da posição do ator na conversa.</param>
/// <returns>Não retorna valores.</returns>
call:ActorConversation(actorID, conversationType)
{
	new index,
		randomAnimation,
		validAnimations[sizeof(actorsConvesation)];

	for(new i = 0; i < sizeof(actorsConvesation); i++)
	{
		if(actorsConvesation[i][E_CONVERSATION_TYPE] == conversationType)
		{
			validAnimations[index] = i;
			index++;
		}
	}
	randomAnimation = random(index);

	randomAnimation = validAnimations[randomAnimation];

	ApplyActorAnimation(actorScenario[actorID], actorsConvesation[randomAnimation][E_ANIM_LIB], actorsConvesation[randomAnimation][E_ANIM_NAME], 4.1, 0, 1, 1, 1, 1);

	SetTimerEx("ActorConversation", actorsConvesation[randomAnimation][E_ANIM_COMPLETION_TIME], false, "ii", actorID, conversationType);
}
/*
 *****************************************************************************
*/
/*
 |FUNCTIONS|
*/
///	<summary>
/// Cria todas as Textdraws Globais do menu Seleção de Personagem.
/// </summary>
/// <returns>Não retorna valores.</returns>
CreateGlobalTDCharSelection()
{
	textCharSelectionGlobal[E_HEADER][0] = TextDrawCreate(-94.058837, 141.583404, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_HEADER][0], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_HEADER][0], 316.352752, 25.250009);
	TextDrawAlignment(textCharSelectionGlobal[E_HEADER][0], 1);
	TextDrawColor(textCharSelectionGlobal[E_HEADER][0], -1523963137);
	TextDrawSetShadow(textCharSelectionGlobal[E_HEADER][0], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_HEADER][0], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_HEADER][0], 255);
	TextDrawFont(textCharSelectionGlobal[E_HEADER][0], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_HEADER][0], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_HEADER][0], 0);

	textCharSelectionGlobal[E_HEADER][1] = TextDrawCreate(4.823533, 146.249984, "Selecionar Personagem");
	TextDrawLetterSize(textCharSelectionGlobal[E_HEADER][1], 0.400000, 1.600000);
	TextDrawAlignment(textCharSelectionGlobal[E_HEADER][1], 1);
	TextDrawColor(textCharSelectionGlobal[E_HEADER][1], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_HEADER][1], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_HEADER][1], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_HEADER][1], 255);
	TextDrawFont(textCharSelectionGlobal[E_HEADER][1], 2);
	TextDrawSetProportional(textCharSelectionGlobal[E_HEADER][1], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_HEADER][1], 0);

	textCharSelectionGlobal[E_CHAR_SLOT][0] = TextDrawCreate(12.764693, 179.500015, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_CHAR_SLOT][0], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_CHAR_SLOT][0], 209.529342, 40.999992);
	TextDrawAlignment(textCharSelectionGlobal[E_CHAR_SLOT][0], 1);
	TextDrawColor(textCharSelectionGlobal[E_CHAR_SLOT][0], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][0], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_CHAR_SLOT][0], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_CHAR_SLOT][0], 255);
	TextDrawFont(textCharSelectionGlobal[E_CHAR_SLOT][0], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_CHAR_SLOT][0], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][0], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_CHAR_SLOT][0], true);

	textCharSelectionGlobal[E_CHAR_SLOT][1] = TextDrawCreate(12.764693, 222.666702, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_CHAR_SLOT][1], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_CHAR_SLOT][1], 209.529342, 40.999992);
	TextDrawAlignment(textCharSelectionGlobal[E_CHAR_SLOT][1], 1);
	TextDrawColor(textCharSelectionGlobal[E_CHAR_SLOT][1], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][1], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_CHAR_SLOT][1], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_CHAR_SLOT][1], 255);
	TextDrawFont(textCharSelectionGlobal[E_CHAR_SLOT][1], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_CHAR_SLOT][1], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][1], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_CHAR_SLOT][1], true);

	textCharSelectionGlobal[E_CHAR_SLOT][2] = TextDrawCreate(12.764693, 265.833374, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_CHAR_SLOT][2], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_CHAR_SLOT][2], 209.529342, 40.999992);
	TextDrawAlignment(textCharSelectionGlobal[E_CHAR_SLOT][2], 1);
	TextDrawColor(textCharSelectionGlobal[E_CHAR_SLOT][2], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][2], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_CHAR_SLOT][2], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_CHAR_SLOT][2], 255);
	TextDrawFont(textCharSelectionGlobal[E_CHAR_SLOT][2], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_CHAR_SLOT][2], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][2], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_CHAR_SLOT][2], true);

	textCharSelectionGlobal[E_CHAR_SLOT][3] = TextDrawCreate(12.764693, 309.000061, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_CHAR_SLOT][3], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_CHAR_SLOT][3], 209.529342, 40.999992);
	TextDrawAlignment(textCharSelectionGlobal[E_CHAR_SLOT][3], 1);
	TextDrawColor(textCharSelectionGlobal[E_CHAR_SLOT][3], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][3], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_CHAR_SLOT][3], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_CHAR_SLOT][3], 255);
	TextDrawFont(textCharSelectionGlobal[E_CHAR_SLOT][3], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_CHAR_SLOT][3], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][3], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_CHAR_SLOT][3], true);

	textCharSelectionGlobal[E_CHAR_SLOT][4] = TextDrawCreate(12.764693, 352.166748, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_CHAR_SLOT][4], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_CHAR_SLOT][4], 209.529342, 40.999992);
	TextDrawAlignment(textCharSelectionGlobal[E_CHAR_SLOT][4], 1);
	TextDrawColor(textCharSelectionGlobal[E_CHAR_SLOT][4], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][4], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_CHAR_SLOT][4], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_CHAR_SLOT][4], 255);
	TextDrawFont(textCharSelectionGlobal[E_CHAR_SLOT][4], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_CHAR_SLOT][4], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_CHAR_SLOT][4], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_CHAR_SLOT][4], true);

	textCharSelectionGlobal[E_BUTTON_EDIT] = TextDrawCreate(12.764693, 395.333435, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_EDIT], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_EDIT], 209.529342, 15.916650);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_EDIT], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_EDIT], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EDIT], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_EDIT], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_EDIT], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_EDIT], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_EDIT], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EDIT], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_EDIT], true);

	textCharSelectionGlobal[E_BUTTON_EDIT_TEXT] = TextDrawCreate(118.235298, 397.083374, "editar");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 0.186351, 1.179998);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 2);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 2);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EDIT_TEXT], 0);

	textCharSelectionGlobal[E_BUTTON_EXIT] = TextDrawCreate(12.764693, 413.416564, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_EXIT], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_EXIT], 209.529342, 15.916650);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_EXIT], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_EXIT], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EXIT], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_EXIT], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_EXIT], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_EXIT], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_EXIT], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EXIT], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_EXIT], true);

	textCharSelectionGlobal[E_BUTTON_EXIT_TEXT] = TextDrawCreate(118.235298, 414.583221, "sair");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 0.186351, 1.179998);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 2);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 2);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_EXIT_TEXT], 0);

	textCharSelectionGlobal[E_BUTTON_TRASH] = TextDrawCreate(228.294281, 395.333221, "LD_SPAC:white");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_TRASH], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_TRASH], 37.293998, 15.916650);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_TRASH], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_TRASH], 70);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_TRASH], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_TRASH], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_TRASH], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_TRASH], 4);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_TRASH], 0);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_TRASH], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_TRASH], true);

	textCharSelectionGlobal[E_BUTTON_TRASH_TEXT] = TextDrawCreate(249.529022, 397.083129, "lixeira");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 0.186351, 1.179998);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 2);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 2);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_TRASH_TEXT], 0);

	textCharSelectionGlobal[E_BUTTON_TRASH_ICON] = TextDrawCreate(219.353042, 393.000183, "");
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 0.000000, 0.000000);
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 17.999980, 19.416666);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 0);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 5);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 0);
	TextDrawSetPreviewModel(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 1328);
	TextDrawSetPreviewRot(textCharSelectionGlobal[E_BUTTON_TRASH_ICON], 337.000000, 0.000000, 0.000000, 1.000000);

	textCharSelectionGlobal[E_BUTTON_DELETE][0] = TextDrawCreate(223.599533, 189.416641, "x");
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_DELETE][0], 233.000000, 15.000000);
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_DELETE][0], 0.400000, 1.600000);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_DELETE][0], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_DELETE][0], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][0], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_DELETE][0], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_DELETE][0], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_DELETE][0], 1);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_DELETE][0], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][0], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_DELETE][0], true);

	textCharSelectionGlobal[E_BUTTON_DELETE][1] = TextDrawCreate(223.599533, 232.583328, "x");
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_DELETE][1], 233.000000, 15.000000);
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_DELETE][1], 0.400000, 1.600000);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_DELETE][1], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_DELETE][1], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][1], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_DELETE][1], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_DELETE][1], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_DELETE][1], 1);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_DELETE][1], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][1], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_DELETE][1], true);

	textCharSelectionGlobal[E_BUTTON_DELETE][2] = TextDrawCreate(223.599533, 275.750183, "x");
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_DELETE][2], 233.000000, 15.000000);
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_DELETE][2], 0.400000, 1.600000);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_DELETE][2], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_DELETE][2], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][2], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_DELETE][2], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_DELETE][2], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_DELETE][2], 1);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_DELETE][2], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][2], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_DELETE][2], true);

	textCharSelectionGlobal[E_BUTTON_DELETE][3] = TextDrawCreate(223.599533, 318.916870, "x");
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_DELETE][3], 233.000000, 15.000000);
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_DELETE][3], 0.400000, 1.600000);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_DELETE][3], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_DELETE][3], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][3], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_DELETE][3], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_DELETE][3], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_DELETE][3], 1);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_DELETE][3], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][3], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_DELETE][3], true);

	textCharSelectionGlobal[E_BUTTON_DELETE][4] = TextDrawCreate(223.599533, 362.083557, "x");
	TextDrawTextSize(textCharSelectionGlobal[E_BUTTON_DELETE][4], 233.000000, 15.000000);
	TextDrawLetterSize(textCharSelectionGlobal[E_BUTTON_DELETE][4], 0.400000, 1.600000);
	TextDrawAlignment(textCharSelectionGlobal[E_BUTTON_DELETE][4], 1);
	TextDrawColor(textCharSelectionGlobal[E_BUTTON_DELETE][4], -1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][4], 0);
	TextDrawSetOutline(textCharSelectionGlobal[E_BUTTON_DELETE][4], 0);
	TextDrawBackgroundColor(textCharSelectionGlobal[E_BUTTON_DELETE][4], 255);
	TextDrawFont(textCharSelectionGlobal[E_BUTTON_DELETE][4], 1);
	TextDrawSetProportional(textCharSelectionGlobal[E_BUTTON_DELETE][4], 1);
	TextDrawSetShadow(textCharSelectionGlobal[E_BUTTON_DELETE][4], 0);
	TextDrawSetSelectable(textCharSelectionGlobal[E_BUTTON_DELETE][4], true);
}
///	<summary>
/// Cria todas as Textdraws Privadas do menu Seleção de Personagem.
/// </summary>
/// <returns>Não retorna valores.</returns>
CreatePrivateTDCharSelection(playerid)
{
	textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0] = CreatePlayerTextDraw(playerid, 6.647084, 177.166687, "");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 46.705848, 44.499980);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 5);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 171);
	PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][0], 0.000000, 0.000000, 0.000000, 1.045655);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0] = CreatePlayerTextDraw(playerid, 45.764713, 183.583312, "Bruno Travi Teixeira");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0] = CreatePlayerTextDraw(playerid, 45.764713, 198.166580, "Acessado por ultimo as 16:20 de_00/00/00");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 0.186351, 1.179998);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], -5963521);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 2);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1] = CreatePlayerTextDraw(playerid, 6.647084, 220.333374, "");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 46.705848, 44.499980);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 5);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 171);
	PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][1], 0.000000, 0.000000, 0.000000, 1.045655);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1] = CreatePlayerTextDraw(playerid, 45.764713, 226.750000, "Bruno Travi Teixeira");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1] = CreatePlayerTextDraw(playerid, 45.764713, 241.333267, "Acessado por ultimo as 16:20 de_00/00/00");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 0.186351, 1.179998);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], -5963521);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 2);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2] = CreatePlayerTextDraw(playerid, 6.647084, 263.500061, "");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 46.705848, 44.499980);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 5);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 171);
	PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][2], 0.000000, 0.000000, 0.000000, 1.045655);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2] = CreatePlayerTextDraw(playerid, 45.764713, 269.916687, "Bruno Travi Teixeira");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2] = CreatePlayerTextDraw(playerid, 45.764713, 284.499969, "Acessado por ultimo as 16:20 de_00/00/00");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 0.186351, 1.179998);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], -5963521);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 2);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3] = CreatePlayerTextDraw(playerid, 6.647084, 306.666748, "");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 46.705848, 44.499980);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 5);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 171);
	PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][3], 0.000000, 0.000000, 0.000000, 1.045655);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3] = CreatePlayerTextDraw(playerid, 45.764713, 313.083374, "Bruno Travi Teixeira");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3] = CreatePlayerTextDraw(playerid, 45.764713, 327.666656, "Acessado por ultimo as 16:20 de_00/00/00");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 0.186351, 1.179998);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], -5963521);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 2);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4] = CreatePlayerTextDraw(playerid, 6.647084, 349.833435, "");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 46.705848, 44.499980);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 5);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 171);
	PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][4], 0.000000, 0.000000, 0.000000, 1.045655);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4] = CreatePlayerTextDraw(playerid, 45.764713, 356.250061, "Bruno Travi Teixeira");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4] = CreatePlayerTextDraw(playerid, 45.764713, 370.833343, "Acessado por ultimo as 16:20 de_00/00/00");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0.186351, 1.179998);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], -5963521);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 2);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0);
}
//--------------------
/// <summary>
/// Cria os objetos globais do cenário de apresentação do personagem.
/// </summary>
/// <returns>Não retorna valores.</returns>
CreateScenarioGlobal()
{
	CreateObject(14390, 1254.05969, -775.77258, 1086.24707,   0.00000, 0.00000, -90.00000);
	CreateObject(14390, 1252.07983, -771.75250, 1086.24707,   0.00000, 0.00000, -90.00000);
	CreateObject(19377, 1273.71692, -792.10327, 1082.92444,   0.00000, 90.00000, 0.00000);
	CreateObject(14399, 1271.29700, -788.77606, 1083.00781,   0.00000, 0.00000, -180.00000);
}
/// <summary>
/// Cria os objetos privados do cenário de apresentação do personagem.
/// </summary>
/// <param name="playerid">ID do jogador ao qual deve ser aplicado as funções privadas.</param>
/// <returns>Não retorna valores.</returns>
CreateScenarioPrivate(playerid)
{
	RemoveBuildingForPlayer(playerid, 2292, 1268.7813, -796.3672, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1268.7891, -795.8828, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2104, 1273.2891, -795.0000, 1083.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2229, 1272.2266, -794.5313, 1083.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1268.7891, -794.9063, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2296, 1277.2813, -794.6875, 1083.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1788, 1278.1172, -794.8281, 1083.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1788, 1278.1172, -794.8281, 1083.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 2229, 1279.8359, -794.9453, 1083.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1268.7891, -793.9219, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2028, 1276.2266, -793.5313, 1083.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1268.7891, -792.9453, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1275.2266, -791.4766, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1274.2500, -791.4766, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2292, 1273.7656, -791.4766, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1278.1719, -791.4766, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1277.1875, -791.4766, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1276.2109, -791.4766, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2292, 1279.6484, -791.4688, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2292, 1268.7813, -791.4609, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1269.2656, -791.4609, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2291, 1270.2500, -791.4609, 1083.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2292, 1271.7266, -791.4609, 1083.0000, 0.25);
}
//--------------------
/// <summary>
/// Carrega e seta um jogador específico no cenário de apresentação
/// do personagem.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
LoadScenario(playerid)
{
	SetPlayerInterior(playerid, 5);
	SetPlayerPos(playerid, 1276.4379,-794.2152,1084.1719);
	SetPlayerFacingAngle(playerid, 272.9013);
	SetPlayerSkin(playerid, 171);

	TogglePlayerControllable(playerid, false);

	SetPlayerCameraPos(playerid, 1278.5630, -794.0517, 1084.3660);
	SetPlayerCameraLookAt(playerid, 1277.5581, -794.0945, 1084.2833);
}
/// <summary>
/// Cria os atores do cenário de apresentação do personagem.
/// </summary>
/// <returns>Não retorna valores.</returns>
CreateScenarioActors()
{
	actorScenario[0] = CreateActor(171, 1273.0809, -793.1731, 1084.1718, 0.6119);
	actorScenario[1] = CreateActor(171, 1273.0214, -792.4755, 1084.1611, 185.7939);

	LoadActorAnimations();

	LoadActorsConversation();
}
//-------------------------------
/// <summary>
/// Carrega todas livrarias de animações usadas pelos atores.
/// </summary>
/// <param name="actorID">ID do ator a ser carregado. -1 se for para todos.</param>
/// <returns>Não retorna valores.</returns>
LoadActorAnimations(actorID = -1)
{
	if(!~actorID)
	{
		for(new i, actors = GetActorPoolSize(); i <= actors; i++)
		{
			LoadActorAnimations(i);
		}
		return;
	}

	ApplyActorAnimation(actorID, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyActorAnimation(actorID, "GANGS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyActorAnimation(actorID, "OTB", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyActorAnimation(actorID, "ped", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyActorAnimation(actorID, "PLAYIDLES", "null", 0.0, 0, 0, 0, 0, 0);
}
/// <summary>
/// Carrega e da início a conversação entre 2 atores do cenário.
/// </summary>
/// <returns>Não retorna valores.</returns>
LoadActorsConversation()
{
	new idSpeech = random(2);//id 0 ou 1

	ActorConversation(idSpeech, CONVERSATION_TYPE_SPEECH);
	ActorConversation(!idSpeech, CONVERSATION_TYPE_RESPONSE);
}
//---------------------------------
/// <summary>
/// Configura valores específicos(definidos para testes) dos Personagens.
/// *Função temporária. 
/// </summary>
/// <param name="playerid">ID do jogador a se setar esses valores.</param>
/// <returns>Não retorna valores.</returns>
ConfigureCharactersValues(playerid)
{
	playerCharacters[playerid][E_ACCOUNT_TYPE] = ACCOUNT_TYPE_NORMAL;

	new i;

	for(i = 0; i < playerCharacters[playerid][E_ACCOUNT_TYPE]; i++)
		ConfigureCharacterSlot(playerid, CONFIG_RESET_SLOT, i),
		UpdateTDCharacterSlot(playerid, i);

	for(i = playerCharacters[playerid][E_ACCOUNT_TYPE]; i < ACCOUNT_TYPE_PREMIUM; i++)
		ConfigureCharacterSlot(playerid, CONFIG_BLOCK_SLOT, i),
		UpdateTDCharacterSlot(playerid, i);
}
/// <summary>
/// Configura um Personagem específico de um jogador específico
/// através de seu slot.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="configureType">Tipo da configuração a ser aplicada no slot do personagem. (CONFIG_REST_SLOT|CONFIG_SET_CHAR_SLOT|CONFIG_BLOCK_SLOT)</param>
/// <param name="slotID">ID do slot do Personagem.</param>
/// <param name="auxValue">Variável auxiliar para armazenar o id da skin do personagem passada quando configureType for CONFIG_SET_CHAR_SLOT.</param>
/// <param name="auxString">Variável auxiliar para armazenar o nome do personagem passado quando configureType for CONFIG_SET_CHAR_SLOT.</param>
/// <returns>Não retorna valores.</returns>
ConfigureCharacterSlot(playerid, configureType, slotID, auxValue = -1, auxString[MAX_PLAYER_NAME] = "")
{
	switch(configureType)
	{
		case CONFIG_RESET_SLOT:
		{
			playerCharacters[playerid][E_CHAR_STATE][slotID] = STATE_EMPTY;
			playerCharacters[playerid][E_CHAR_SKIN][slotID] = 19134;//create char icon
			playerCharacters[playerid][E_CHAR_NAME][slotID] = EOS;

			for(new i; i < 5; i++) playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][i] = 0;

		}
		case CONFIG_SET_CHAR_SLOT:
		{
			playerCharacters[playerid][E_CHAR_STATE][slotID] = STATE_CREATED;
			playerCharacters[playerid][E_CHAR_SKIN][slotID] = auxValue;

			format(playerCharacters[playerid][E_CHAR_NAME][slotID], sizeof(auxString), auxString);

			for(new i; i < 5; i++) playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][i] = 0;
		}
		case CONFIG_BLOCK_SLOT:
		{
			playerCharacters[playerid][E_CHAR_STATE][slotID] = STATE_BLOCKED;
			playerCharacters[playerid][E_CHAR_SKIN][slotID] = 19804;//block slot icon
			playerCharacters[playerid][E_CHAR_NAME][slotID] = EOS;

			for(new i; i < 5; i++) playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][i] = 0;
		}
	}
}
//----------------------------------
/// <summary>
/// Mostra o menu de Seleção de Personagem a um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
ShowMenuSelectionCharacter(playerid)
{
	new i;

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_HEADER][0]);
	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_HEADER][1]);

	for(i = 0; i < 5; i++) TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_CHAR_SLOT][i]);

	for(i = 0; i < 5; i++)
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][i]),
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][i]),
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][i]);

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EDIT]);
	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EDIT_TEXT]);

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EXIT]);
	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EXIT_TEXT]);

	SelectTextDraw(playerid, 0xDDDDDD40);//0xDDDDDDAA
}
/// <summary>
/// Reseta configurações do menu de Seleção de Personagem de um jogador
/// específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
ConfigureMenuSelectionCharacter(playerid)
{
	textSelectedControl[playerid][E_CHAR_SLOT] = INVALID_CHAR_SLOT;
	
	textSelectedControl[playerid][E_BUTTON_EDIT] = false;
}
//---------------------------------------------------------------
/// <summary>
/// Atualiza as informações da TextDraw de um Personagem específico
/// (através do slotID) de um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="slotID">ID do slot do Personagem.</param>
/// <param name="showChanges">True para mostrar modificações, False para não.</param>
/// <returns>Não retorna valores.</returns>
UpdateTDCharacterSlot(playerid, slotID, bool:showChanges = false)
{
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], -5963521);
	switch(playerCharacters[playerid][E_CHAR_STATE][slotID])
	{
		case STATE_EMPTY:
		{
			PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], playerCharacters[playerid][E_CHAR_SKIN][slotID]);
			PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 0.000000, 0.000000, 90.000000, 1.045655);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], -1);

			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], "Novo personagem");
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], -1);

			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], "Criar novo personagem");
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], -1378294017);
		}
		case STATE_CREATED:
		{
			new string[43];

			PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], playerCharacters[playerid][E_CHAR_SKIN][slotID]);
			PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 0.000000, 0.000000, 0.000000, 1.045655);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], -1);
			
			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], playerCharacters[playerid][E_CHAR_NAME][slotID]);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], -1);
			
			format(string, sizeof(string), "Acessado por ultimo as %02d:%02d de %02d/%02d/%d", playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][0],playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][1], playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][2],playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][3],playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][4]);
			
			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], string);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], -1378294017);
		}
		case STATE_BLOCKED:
		{
			PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], playerCharacters[playerid][E_CHAR_SKIN][slotID]);
			PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 0.000000, 0.000000, 0.000000, 1.045655);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 255);

			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], "BLOQUEADO");
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], 255);
			
			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], ConvertToGameText("Este slot não está disponível."));
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], 255);
		}
	}

	if(showChanges)
	{
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID]);
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID]);
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID]);
	}
}
/*
 *****************************************************************************
*/
/*
 |COMPLEMENTS|
*/
ConvertToGameText(in[])
{
    new i, string[256];
    for(i = 0; in[i]; ++i)
    {
        string[i] = in[i];
        switch(string[i])
        {
            case 0xC0 .. 0xC3: string[i] -= 0x40;
            case 0xC7 .. 0xC9: string[i] -= 0x42;
            case 0xD2 .. 0xD5: string[i] -= 0x44;
            case 0xD9 .. 0xDC: string[i] -= 0x47;
            case 0xE0 .. 0xE3: string[i] -= 0x49;
            case 0xE7 .. 0xEF: string[i] -= 0x4B;
            case 0xF2 .. 0xF5: string[i] -= 0x4D;
            case 0xF9 .. 0xFC: string[i] -= 0x50;
            case 0xC4, 0xE4: string[i] = 0x83;
            case 0xC6, 0xE6: string[i] = 0x84;
            case 0xD6, 0xF6: string[i] = 0x91;
            case 0xD1, 0xF1: string[i] = 0xEC;
            case 0xDF: string[i] = 0x96;
            case 0xBF: string[i] = 0xAF;
        }
    }
    return string;
}
/*
 *****************************************************************************
*/
/*
 |COMMANDS|
*/
/// <summary>
/// Comando para carregar e setar o jogador ao cenário.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores específicos.</returns>
CMD:char(playerid)
{
	LoadScenario(playerid);
	return 1;
}
//-----------------
/// <summary>
/// Comando temporário para sair da câmera setada ao jogador
/// que carregar o cenário.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores específicos.</returns>
CMD:actor(playerid)
{
	TogglePlayerControllable(playerid, true);
	SetCameraBehindPlayer(playerid);
	return 1;
}
/// <summary>
/// Comando temporário para criar um ator. Imprime código da
/// aplicação da função no console.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores específicos.</returns>
CMD:c_actor(playerid)
{
	new Float:pos[4];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);

	new id = CreateActor(GetPlayerSkin(playerid), pos[0], pos[1], pos[2], pos[3]);

	printf("CreateActor(%d, %.4f, %.4f, %.4f, %.4f);", GetPlayerSkin(playerid), pos[0], pos[1], pos[2], pos[3]);

	SendClientMessageEx(playerid, -1, "Ator criado. ID = %d", id);

	return 1;
}
/// <summary>
/// Comando temporário para deletar um ator específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="params">Parâmetros a serem utilizados: <id do ator>.</param>
/// <returns>Não retorna valores específicos.</returns>
CMD:d_actor(playerid, params[])
{
	if(isnull(params)) return 1;

	DestroyActor(strval(params));

	SendClientMessageEx(playerid, -1, "Ator %d destruído.", strval(params));

	return 1;
}