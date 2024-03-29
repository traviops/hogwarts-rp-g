/*
	Arquivo:
		modules/player/character.pwn

	Descri��o:
		- Este m�dulo � direcionado ao gerenciamento de personagens do jogador.

	�ltima atualiza��o:
		23/03/18

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" J�nior,
		Bruno "Bruno13" Travi,
		Jo�o "BarbaNegra" Paulo,
		Jo�o "JPedro" Pedro,
		Renato "Misterix" Venancio)

	Esqueleto do c�digo:
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
const
	
	/// <summary> 
	///	Defini��o do m�ximo de slots.</summary>
	MAX_CHARACTERS_SLOTS			= 5,

	/// <summary> 
	///	Defini��es dos tipos de contas.</summary>
	ACCOUNT_TYPE_NORMAL				= 3,
	ACCOUNT_TYPE_PREMIUM			= 5,

	/// <summary> 
	///	Defini��es do slots.</summary>
	CONFIG_RESET_SLOT				= 0,
	CONFIG_SET_CHAR_SLOT			= 1,
	CONFIG_BLOCK_SLOT				= 2,

	/// <summary> 
	///	Defini��es do estado dos slots.</summary>
	STATE_EMPTY						= 0,
	STATE_CREATED					= 1,
	STATE_BLOCKED					= 2,

	/// <summary> 
	///	Defini��o de slot inv�lido.</summary>
	INVALID_CHAR_SLOT				= -1,

	/// <summary>
	/// Defini��es dos tipos de p�ginas no menu de personagens.</summary>
	MENU_PAGE_NONE					= -1,
	MENU_PAGE_MAIN					= 0,
	MENU_PAGE_CREATE_CHAR 			= 1,
	MENU_PAGE_CREATE_FEATURE		= 2,

	/// <summary> 
	///	Defini��es das conversas entre os atores.</summary>
	CONVERSATION_TYPE_SPEECH		= 0,
	CONVERSATION_TYPE_RESPONSE		= 1,

	/// <summary>
	/// Defini��o do m�ximo de skins selecion�veis na cria��o de personagem.</summary>
	MAX_FEATURE_MALE_SKINS			= 6,
	MAX_FEATURE_FEMALE_SKINS		= 4,

	/// <summary>
	/// Defini��o do m�ximo de olhos selecion�veis na cria��o de personagem.</summary>
	MAX_FEATURE_EYES				= 3,

	/// <summary>
	/// Defini��o do m�ximo de cabelos selecion�veis na cria��o de personagem.</summary>
	MAX_FEATURE_HAIRS				= 6,

	/// <summary>
	/// Defini��es dos tipos de g�neros.</summary>
	GENDER_TYPE_MALE				= 0,
	GENDER_TYPE_FEMALE				= 1,

	/// <summary>
	/// Defini��es dos tipos de caracter�sticas da cria��o de personagens.</summary>
	CHAR_FEATURE_NONE				= -1,
	CHAR_FEATURE_SKIN				= 0,
	CHAR_FEATURE_HAIR				= 1,
	CHAR_FEATURE_EYE				= 2,

	/// <summary>
	/// Defini��o da dura��o do movimento na troca de c�mera da cria��o de personagem.</summary>
	CHAR_FEAUTRE_CAMERA_MOVE_TIME	= 1100,

	/// <summary>
	///	Defini��es das cores do bot�o g�nero.</summary>
	COLOR_GENDER_SELECTED			= -1523963137,
	COLOR_GENDER_UNSELECTED			= -1,

	/// <summary>
	///	Defini��o da cor do seletor de textdraws.</summary>
	SELECTOR_TEXTDRAW_COLOR			= 0xDDDDDD40,

	/// <summary>
	///	Defini��es da numera��o dos dialogs.</summary>
	DIALOG_SLOT_MESSAGE				= 19888,

	/// <summary>
	///	Defini��o do total de skins utiliz�veis nos personagens.</summary>
	MAX_CHAR_SKINS					= 3,

	/// <summary>
	///	Defini��o da caracter�stica tipo padr�o/inv�lida, utilizada para cabelo e olhos.</summary>
	FEATURE_TYPE_DEFAULT			= 0,
	FEATURE_TYPE_INVALID			= -1,

	/// <summary>
	///	Defini��es do �ndice do attachment utilizado por cada caracter�stica.</summary>
	CHAR_FEATURE_EYE_L_ATTACH_INDEX	= 0,
	CHAR_FEATURE_EYE_R_ATTACH_INDEX	= 1,
	CHAR_FEATURE_HAIR_ATTACH_INDEX	= 2;

/*
 * ENUMERATORS
 ******************************************************************************
 */
/// <summary> 
///	Enumerador da vari�vel 'playerActorScenario[MAX_PLAYERS][E_ACTOR_SCENARIO]'.</summary>
enum E_ACTOR_SCENARIO
{
	E_ACTOR_ID[2],
	Timer:E_ACTOR_CONVERSATION_TIMER[2]
}

/// <summary> 
///	Enumerador da vari�vel 'textCharSelectionGlobal[E_TEXT_CHAR_SELECTION_GLOBAL]'.</summary>
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

/// <summary> 
///	Enumerador da vari�vel 'textCharCreationGlobal[E_TEXT_CHAR_CREATION_GLOBAL]'.</summary>
enum E_TEXT_CHAR_CREATION_GLOBAL
{
	Text:E_HEADER,
	Text:E_BUTTON_BACK,
	Text:E_BACKGROUND[7],
	Text:E_BACKGROUND_GENDER[2],
	Text:E_BUTTON_NAME,
	Text:E_BUTTON_SKIN,
	Text:E_BUTTON_HAIR,
	Text:E_BUTTON_EYE,
	Text:E_BUTTON_CREATE,
	Text:E_TEXT_CREATE,
	Text:E_SELECT_FEATURE_BACKGROUND[3]
}

/// <summary> 
///	Enumerador da vari�vel 'textCharSelectionPrivate[MAX_PLAYERS][E_TEXT_CHAR_SELECTION_PRIVATE]'.</summary>
enum E_TEXT_CHAR_SELECTION_PRIVATE
{
	PlayerText:E_CHAR_SLOT_SKIN[MAX_CHARACTERS_SLOTS],
	PlayerText:E_CHAR_SLOT_NAME[MAX_CHARACTERS_SLOTS],
	PlayerText:E_CHAR_SLOT_LAST_ACESS[MAX_CHARACTERS_SLOTS]
}

/// <summary> 
///	Enumerador da vari�vel 'textCharCreationPrivate[MAX_PLAYERS][E_TEXT_CHAR_CREATION_PRIVATE]'.</summary>
enum E_TEXT_CHAR_CREATION_PRIVATE
{
	PlayerText:E_CHAR_NAME,
	PlayerText:E_CHAR_SKIN,
	PlayerText:E_CHAR_HAIR,
	PlayerText:E_CHAR_EYE,
	PlayerText:E_BUTTON_GENDER_MALE,
	PlayerText:E_BUTTON_GENDER_FEMALE,
	PlayerText:E_SELECT_FEATURE_TEXT,
	PlayerText:E_SELECT_FEATURE_VALUE
}

/// <summary> 
///	Enumerador da vari�vel 'textSelectedControl[MAX_PLAYERS][E_TEXT_SELECTED_CONTROL]'.</summary>
enum E_TEXT_SELECTED_CONTROL
{
	E_CHAR_SLOT,
	bool:E_BUTTON_EDIT
}

const
	size_E_CHAR_NAME = MAX_CHARACTERS_SLOTS * MAX_PLAYER_NAME,
	size_E_CHAR_LAST_ACESS = MAX_CHARACTERS_SLOTS * 5;

/// <summary> 
///	Enumerador da vari�vel 'playerCharacters[MAX_PLAYERS][E_PLAYER_CHARACTERS]'.</summary>
enum E_PLAYER_CHARACTERS
{
	E_ACCOUNT_TYPE,//TOTAL SLOTS
	E_CHAR_STATE[MAX_CHARACTERS_SLOTS],
	E_CHAR_SKIN[MAX_CHARACTERS_SLOTS],
	E_CHAR_NAME[size_E_CHAR_NAME],
	E_CHAR_LAST_ACESS[size_E_CHAR_LAST_ACESS]//0 - hora | 1 - min | 2 - dia | 3 - m�s | 4 - ano
}

/// <summary> 
///	Enumerador da vari�vel 'playerMenuCharacter[MAX_PLAYERS][E_PLAYER_MENU_CHARACTER]'.</summary>
enum E_PLAYER_MENU_CHARACTER
{
	E_PLAYER_IN_MENU_PAGE,
	E_PLAYER_KEY_PRESSED,
	E_PLAYER_SETTING_FEATURE_TYPE,
	E_PLAYER_FEATURE_VALUE_SELECTED,
	E_PLAYER_FEATURE_CHARACTER_NAME[MAX_PLAYER_NAME]
}

#define E_CHAR_NAME][%1][%2] E_CHAR_NAME][((%1)*MAX_PLAYER_NAME)+(%2)]
#define E_CHAR_LAST_ACESS][%1][%2] E_CHAR_LAST_ACESS][((%1)*5)+(%2)]

/// <summary> 
///	Enumerador da vari�vel 'playerCreateCharacter[MAX_PLAYERS][E_PLAYER_CREATE_CHARACTER]'.</summary>
enum E_PLAYER_CREATE_CHARACTER
{
	E_PLAYER_CHAR_NAME[MAX_PLAYER_NAME],
	E_PLAYER_GENDER_SELECTED,
	E_PLAYER_SKIN_SELECTED,
	E_PLAYER_HAIR_SELECTED,
	E_PLAYER_EYE_SELECTED
}

/// <summary> 
///	Enumerador da matriz 'actorsConversation[][E_ACTORS_CONVERSATION]'.</summary>
enum E_ACTORS_CONVERSATION
{
	E_ANIM_LIB[12],
	E_ANIM_NAME[15],
	E_ANIM_COMPLETION_TIME,
	E_CONVERSATION_TYPE
}

/// <summary> 
///	Enumerador da matriz 'charFeatureEyes[MAX_FEATURE_EYES][E_CHAR_FEATURE_EYES]'.</summary>
enum E_CHAR_FEATURE_EYES
{
	E_FEATURE_EYES_MODEL_ID,
	E_FEATURE_EYES_NAME[7],
}

/// <summary> 
///	Enumerador da matriz 'charFeatureHairs[MAX_FEATURE_HAIRS][E_CHAR_FEATURE_HAIRS]'.</summary>
enum E_CHAR_FEATURE_HAIRS
{
	E_FEATURE_HAIR_MODEL_ID,
	E_FEATURE_HAIR_NAME[23],
}

/// <summary> 
///	Enumerador da matriz 'attachCharsFeatureEyes[][MAX_CHAR_SKINS * 2][E_ATTACH_CHARS_FEATURE_EYES]'.</summary>
enum E_ATTACH_CHARS_FEATURE_EYES
{
	E_CHAR_SKIN_ID[2],
	E_EYES_BONE,
	Float:E_EYES_OFFSETX,
	Float:E_EYES_OFFSETY,
	Float:E_EYES_OFFSETZ,
	Float:E_EYES_ROTX,
	Float:E_EYES_ROTY,
	Float:E_EYES_ROTZ,
	Float:E_EYES_SCALEX,
	Float:E_EYES_SCALEY,
	Float:E_EYES_SCALEZ,
	E_EYES_MAT_COLOR1,
	E_EYES_MAT_COLOR2
}

/// <summary> 
///	Enumerador da matriz 'attachCharsFeatureHairs[MAX_FEATURE_HAIRS][E_ATTACH_CHARS_FEATURE_HAIRS]'.</summary>
enum E_ATTACH_CHARS_FEATURE_HAIRS
{
	E_CHAR_SKIN_ID[2],
	E_HAIR_BONE,
	Float:E_HAIR_OFFSETX,
	Float:E_HAIR_OFFSETY,
	Float:E_HAIR_OFFSETZ,
	Float:E_HAIR_ROTX,
	Float:E_HAIR_ROTY,
	Float:E_HAIR_ROTZ,
	Float:E_HAIR_SCALEX,
	Float:E_HAIR_SCALEY,
	Float:E_HAIR_SCALEZ
}

/*
 * VARIABLES
 ******************************************************************************
 */
static

	/// <summary>
	///	Defini��o do id deste m�dulo.</summary>
	this = MODULE_CHARACTER,

	/// <summary> 
	///	Vari�vel dos atores criados para o jogador.</summary>
	playerActorScenario[MAX_PLAYERS][E_ACTOR_SCENARIO],

	/// <summary> 
	///	Vari�veis de controle das TextDraws Globais/Privadas.</summary>
	Text:textCharSelectionGlobal[E_TEXT_CHAR_SELECTION_GLOBAL],
	Text:textCharCreationGlobal[E_TEXT_CHAR_CREATION_GLOBAL],
	PlayerText:textCharSelectionPrivate[MAX_PLAYERS][E_TEXT_CHAR_SELECTION_PRIVATE],
	PlayerText:textCharCreationPrivate[MAX_PLAYERS][E_TEXT_CHAR_CREATION_PRIVATE],

	/// <summary>
	/// Vari�vel para controle das TextDraws selecionadas, isso inclu� tanto slots quanto bot�es.</summary>
	textSelectedControl[MAX_PLAYERS][E_TEXT_SELECTED_CONTROL],

	/// <summary> 
	///	Vari�vel de controle de todos personagens do jogador.</summary>
	playerCharacters[MAX_PLAYERS][E_PLAYER_CHARACTERS],

	/// <summary> 
	///	Vari�vel para controle do menu de personagens do jogador.</summary>
	playerMenuCharacter[MAX_PLAYERS][E_PLAYER_MENU_CHARACTER],

	/// <summary> 
	///	Vari�vel para controle da cria��o de personagens do jogador.</summary>
	playerCreateCharacter[MAX_PLAYERS][E_PLAYER_CREATE_CHARACTER],

	/// <summary> 
	///	Matriz com anima��es que ser�o aplicadas aos atores.</summary>
	actorsConversation[][E_ACTORS_CONVERSATION] = {
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
	},

	/// <summary> 
	///	Posi��o out screen do menu de sele��o de personagens.</summary>
	Float:menuSelectionCharPositionOut[3] = {1277.6066, -798.1226, 1083.9971},

	/// <summary> 
	///	Posi��o das skins do menu de sele��o de personagens.</summary>
	Float:menuSelectionCharPositionIn[3] = {1276.4379, -794.2152, 1084.1719},

	/// <summary> 
	///	Posi��o da c�mera na sele��o de personagens.</summary>
	Float:camPosSelectionCharacter[3] = {1278.5630, -794.0517, 1084.3660},
	Float:camLookAtSelectionCharacter[3] = {1277.5581, -794.0945, 1084.2833},

	/// <summary> 
	///	Posi��o da c�mera na altera��o de caracter�sticas na cria��o de personagens.</summary>
	Float:camPosConfigCharacterFeature[3] = {1277.3708, -794.2350, 1084.9235},
	Float:camLookAtConfigCharacterFeature[3] = {1276.3722, -794.0945, 1084.8417},

	/// <summary> 
	///	Matriz com o nome de cada caracter�stica da cria��o de personagem. Corresponde aos IDs CHAR_FEATURE_SKIN e etc.</summary>
	featureText[3][7] = {
		{"Skin"},
		{"Cabelo"},
		{"Olho"}
	},

	/// <summary> 
	///	Matriz com as skins masculinas selecion�veis na cria��o de personagens.</summary>
	charFeatureMaleSkins[MAX_FEATURE_MALE_SKINS] = {
		20001, 20002, 20003, 20004, 20005, 20006
	},

	/// <summary> 
	///	Matriz com as skins femininas selecion�veis na cria��o de personagens.</summary>
	charFeatureFemaleSkins[MAX_FEATURE_FEMALE_SKINS] = {
		194, 172, 141, 11
	},

	/// <summary> 
	///	Matriz com o nome de todos os tipos de olhos.</summary>
	charFeatureEyes[MAX_FEATURE_EYES][E_CHAR_FEATURE_EYES] = {
		{0, "Normal"},
		{3100, "Azul"},
		{3104, "Verde"}
	},

	/// <summary> 
	///	Matriz com o nome de todos os tipos de cabelos.</summary>
	charFeatureHairs[MAX_FEATURE_HAIRS][E_CHAR_FEATURE_HAIRS] = {
		//18640, "Cachopa"
		{0, "Careca"},
		{-2000, "Penteado para os lados"},
		{-2001, "Topete"},
		{-2002, "Penteado para tr�s"},
		{18975, "Afro"},
		{19077, "Flattop"}
	},

	/// <summary>
	/// Matriz com os attachments dos olhos de todos personagens.</summary>
	attachCharsFeatureEyes[MAX_CHAR_SKINS * 2][E_ATTACH_CHARS_FEATURE_EYES] = {
		{{20001, 20004}, 2, 0.07900000, 0.09199798, -0.03200098, 82.90002441, 0.00000000, 0.00000000, 0.13299900, 0.19199900, 0.22999900, 0, 0},
		{{20001, 20004}, 2, 0.07800000, 0.09099800, 0.02399799, 82.90002441, 0.00000000, 0.00000000, 0.13299900, 0.19199900, 0.22999900, 0, 0},
		{{20002, 20005}, 2, 0.08100000, 0.08599799, -0.03100099, 82.90002441, 0.00000000, 0.00000000, 0.13299900, 0.19199900, 0.22999900, 0, 0},
		{{20002, 20005}, 2, 0.08200000, 0.08899900, 0.02499799, 82.90002441, 0.00000000, 0.00000000, 0.13299900, 0.19199900, 0.22999900, 0, 0},
		{{20003, 20006}, 2, 0.07800000, 0.09599900, -0.03100101, 82.90002441, 0.00000000, 0.00000000, 0.13299900, 0.19199900, 0.22999900, 0, 0},
		{{20003, 20006}, 2, 0.07999999, 0.09699901, 0.02499897, 82.90002441, 0.00000000, 0.00000000, 0.13299900, 0.19199900, 0.22999900, 0, 0}
	},

	/// <summary>
	/// Matriz com os attachments de todos tipos cabelos de todos personagens.</summary>
	attachCharsFeatureHairs[MAX_FEATURE_HAIRS][3][E_ATTACH_CHARS_FEATURE_HAIRS] = {
		{//hair default
			{{0, 0}, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
			{{0, 0}, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
			{{0, 0}, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
		},
		{//hair 1
			{{20001, 20004}, 2, 0.10599992, 0.00999999, -0.00600000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.05100107, 1.14000153},
			{{20002, 20005}, 2, 0.11599993, 0.00599999, -0.00300000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.05100107, 1.18300366},
			{{20003, 20006}, 2, 0.11599993, 0.00599999, -0.00300000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.05100107, 1.18300366}
		},
		{//hair 2
			{{20001, 20004}, 2, 0.09899988, 0.00399999, -0.00400000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.14300262, 0.96500462},
			{{20002, 20005}, 2, 0.09899988, 0.00299999, -0.00000000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.14300262, 1.02700459},
			{{20003, 20006}, 2, 0.09899988, 0.00299999, -0.00000000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.14300262, 1.02700459}
		},
		{//hair 3
			{{20001, 20004}, 2, 0.09899988, 0.00399998, -0.00500000, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.14300262, 0.99600428},
			{{20002, 20005}, 2, 0.09899988, 0.00299998, -0.00299999, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.14300262, 1.02900433},
			{{20003, 20006}, 2, 0.09899988, 0.00299998, -0.00299999, 0.00000000, 0.00000000, 0.00000000, 1.00000000, 1.14300262, 1.02900433}
		},
		{//hair 4
			{{20001, 20004}, 2, 0.09199988, 0.00299998, -0.00299999, 0.00000000, 0.00000000, 0.00000000, 1.09199988, 1.14300262, 1.02900433},
			{{20002, 20005}, 2, 0.09199988, 0.00299998, -0.00299999, 0.00000000, 0.00000000, 0.00000000, 1.09199988, 1.14300262, 1.02900433},
			{{20003, 20006}, 2, 0.09199988, 0.00299998, -0.00299999, 0.00000000, 0.00000000, 0.00000000, 1.09199988, 1.14300262, 1.02900433}
		},
		{//hair 5
			{{20001, 20004}, 2, 0.09399997, -0.00100001, -0.00299999, 0.00000000, 0.00000000, 0.00000000, 1.09199988, 1.14300262, 1.06600809},
			{{20002, 20005}, 2, 0.09399997, -0.00300001, -0.00099999, 0.00000000, 0.00000000, 0.00000000, 1.09199988, 1.17900419, 1.09100937},
			{{20003, 20006}, 2, 0.09399997, -0.00300001, -0.00099999, 0.00000000, 0.00000000, 0.00000000, 1.09199988, 1.17900419, 1.09100937}
		}
	}
;

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined character_OnGameModeInit
		character_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o m�dulo;
	///		- cria todas TextDraws Globais utilizadas pelo menu Sele��o de Personagem.
	///		- cria objetos globais do cen�rio.
	/// </summary>

	ModuleInit("player/character.pwn");

	CreateGlobalTDCharSelection();

	CreateScenarioGlobal();
	return 1;
}

public OnPlayerConnect(playerid)
{
	#if defined character_OnPlayerConnect
		character_OnPlayerConnect(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		- se o jogador for um NPC: retorna 1;
	///		- cria todas TextDraws Privadas utilizadas pelo menu Sele��o de Personagem.
	///		- cria objetos privados do cen�rio.
	///		- configura os valores dos personagens do player(valores iniciais para testes).
	/// </summary>

	if(IsPlayerNPC(playerid))
		return 1;

	CreatePrivateTDCharSelection(playerid);
	CreateScenarioPrivate(playerid);

	ConfigureMenuSelectionCharacter(playerid);
	ConfigureCharactersValues(playerid);

	return 1;
}

public OnPlayerUpdate(playerid)
{
	#if defined character_OnPlayerUpdate
		character_OnPlayerUpdate(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		> se o jogador estiver alterando alguma caracter�stica do seu
	///		  personagem na cria��o de personagens:
	///			|> mostra a caracter�stica anterior/seguinte ao teclar KEY_LEFT/KEY_RIGHT;
	///			|> seleciona a caracter�stica ao teclar ESPACE.
	/// </summary>

	if(playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] == MENU_PAGE_CREATE_FEATURE)
	{
		static keys, lr;

		GetPlayerKeys(playerid, keys, lr, lr);

		MenuCreationCharacterKeyPress(playerid, lr, keys);
	}
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	#if defined character_OnPlayerClickTextDraw
		character_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		- se a textdraw clicada for invalida: retorna 1;
	///		- aplica todas as fun��es das textdraws clicadas.
	/// </summary>

	if(_:clickedid == INVALID_TEXT_DRAW)
		return 1;

	/// <summary>
	/// Mostra lixeira e bot�es para excluir personagens ao clicar em 'editar' na sele��o
	/// de personagens.
	/// </summary>
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

		return 1;
	}

	/// <summary>
	/// Retira o jogador da sele��o de personagens ao clicar em 'sair'.
	/// </summary>
	else if(clickedid == textCharSelectionGlobal[E_BUTTON_EXIT])
	{
		RemovePlayerCharacterMenu(playerid);
		return 1;
	}

	/// <summary>
	/// Volta para a p�gina inicial de sele��o de personagens ao clicar no bot�o de volta
	///	'<' na cria��o de personagens.
	/// </summary>
	else if(clickedid == textCharCreationGlobal[E_BUTTON_BACK])
	{
		SetPlayerPos(playerid, menuSelectionCharPositionOut[0], menuSelectionCharPositionOut[1], menuSelectionCharPositionOut[2]);
		HideMenuCreationCharacter(playerid, false);
		ShowMenuSelectionCharacter(playerid, false);
		return 1;
	}

	/// <summary>
	/// Mostra a configura��o da skin ao clicar no bot�o da sub-divis�o 'skin'.
	/// </summary>
	else if(clickedid == textCharCreationGlobal[E_BUTTON_SKIN])
	{
		ShowMenuConfigCharFeature(playerid, CHAR_FEATURE_SKIN);
		return 1;
	}

	/// <summary>
	/// Mostra a configura��o do cabelo ao clicar no bot�o da sub-divis�o 'cabelo'.
	/// </summary>
	else if(clickedid == textCharCreationGlobal[E_BUTTON_HAIR])
	{
		ShowMenuConfigCharFeature(playerid, CHAR_FEATURE_HAIR);
		return 1;
	}

	/// <summary>
	/// Mostra a configura��o do olho ao clicar no bot�o da sub-divis�o 'olho'.
	/// </summary>
	else if(clickedid == textCharCreationGlobal[E_BUTTON_EYE])
	{
		ShowMenuConfigCharFeature(playerid, CHAR_FEATURE_EYE);
		return 1;
	}
	else
	{
		for(new i; i < MAX_CHARACTERS_SLOTS; i++)
		{
			/// <summary>
			/// Aplica a fun��o espec�fica do slot clicado conforme o status do personagem desse slot.
			/// </summary>
			if(clickedid == textCharSelectionGlobal[E_CHAR_SLOT][i])
			{
				switch(playerCharacters[playerid][E_CHAR_STATE][i])
				{
					case STATE_BLOCKED:
					{
						CancelSelectTextDraw(playerid);

						ShowPlayerDialog(playerid, DIALOG_SLOT_MESSAGE, DIALOG_STYLE_MSGBOX, "Slot bloqueado", "Este slot est� bloqueado. Para saber como adquir�-lo acesse:\n\tMinha conta > Planos premium", "Confirmar", "");
					}
					case STATE_EMPTY:
					{
						SetPlayerPos(playerid, menuSelectionCharPositionIn[0], menuSelectionCharPositionIn[1], menuSelectionCharPositionIn[2]);
						
						ResetMenuCreationCharacter(playerid);

						HideMenuSelectionCharacter(playerid, false);
						ShowMenuCreationCharacter(playerid, false);
					}
				}
				break;
			}
		}
	}

	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	#if defined chr_OnPlayerClickPlayerTextDraw
		chr_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		- aplica todas as fun��es das textdraws clicadas.
	/// </summary>

	/// <summary>
	/// Altera o g�nero do personagem em cria��o para feminino ao clicar no bot�o 'Feminino'.
	/// </summary>
	if(playertextid == textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE] &&
		playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] != GENDER_TYPE_MALE)
		ChangeCharacterFeatureGender(playerid, GENDER_TYPE_MALE);

	/// <summary>
	/// Altera o g�nero do personagem em cria��o para masculino ao clicar no bot�o 'Masculino'.
	/// </summary>
	else if(playertextid == textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE] &&
		playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] != GENDER_TYPE_FEMALE)
		ChangeCharacterFeatureGender(playerid, GENDER_TYPE_FEMALE);

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#if defined character_OnDialogResponse
		character_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#endif

	/// <summary>
	/// Ativa o cursor ap�s mensagem em dialog.
	/// </summary>
	if(dialogid == DIALOG_SLOT_MESSAGE)
	{
		SelectTextDraw(playerid, SELECTOR_TEXTDRAW_COLOR, this);
	}

	return 1;
}

/*
 * MY CALLBACKS
 ******************************************************************************
 */
public OnPlayerHideCursor(playerid, hovercolor, moduleCalled)
{
	#if defined character_OnPlayerHideCursor
		character_OnPlayerHideCursor(playerid, hovercolor, moduleCalled);
	#endif

	if(moduleCalled != this)
		return 1;

	return 1;	
}

/// <summary>
/// Timer para aplicar as anima��es aos atores de um jogador espec�fico. As
/// anima��es s�o rand�micas e simulam uma conversa entre dois atores, tal
/// essa sem fim.
/// Intervalo: Definido pela matriz 'actorsConversation'
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="actorIndex">Index do ator a ser aplicado a anima��o.</param>
/// <param name="conversationType">Tipo da posi��o do ator na conversa.</param>
/// <returns>N�o retorna valores.</returns>
timer ActorConversation[1000](playerid, actorIndex, conversationType)
{
	new index,
		randomAnimation,
		validAnimations[sizeof(actorsConversation)];

	for(new i = 0; i < sizeof(actorsConversation); i++)
	{
		if(actorsConversation[i][E_CONVERSATION_TYPE] == conversationType)
		{
			validAnimations[index] = i;
			index++;
		}
	}
	randomAnimation = random(index);
	randomAnimation = validAnimations[randomAnimation];

	ApplyActorAnimation(playerActorScenario[playerid][E_ACTOR_ID][actorIndex], actorsConversation[randomAnimation][E_ANIM_LIB], actorsConversation[randomAnimation][E_ANIM_NAME], 4.1, 0, 1, 1, 1, 1);

	playerActorScenario[playerid][E_ACTOR_CONVERSATION_TIMER][actorIndex] = defer ActorConversation[actorsConversation[randomAnimation][E_ANIM_COMPLETION_TIME]](playerid, actorIndex, conversationType);
}

/// <summary>
/// Timer para mostrar as textdraws de configura��o das caracter�sticas do
/// personagem ao terminar a movimenta��o da c�mera.
/// Intervalo: Definido pela defini��o 'CHAR_FEAUTRE_CAMERA_MOVE_TIME'.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="type">Tipo da movimenta��o que est� ocorrendo. 0 = SelecionCharacter para CharacterFeature | 1 = CharacterFeature para SelectionCharacter.</param>
/// <param name="featureType">Tipo da caracter�stica.</param>
/// <returns>N�o retorna valores.</returns>
timer CharCameraMoveFinished[CHAR_FEAUTRE_CAMERA_MOVE_TIME](playerid, type, featureType)
{
	if(type)
	{
		ShowMenuCreationCharacter(playerid, true);
		return;
	}

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2]);

	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], featureText[featureType][0]);
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT]);

	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], GetFeatureValueName(playerid, featureType));
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_CREATE_FEATURE;
}

/*
 * FUNCTIONS
 ******************************************************************************
 */
///	<summary>
/// Cria todas as Textdraws Globais do menu Sele��o de Personagem.
/// </summary>
/// <returns>N�o retorna valores.</returns>
static CreateGlobalTDCharSelection()
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

	/*
	 *****************************************************************************/

	textCharCreationGlobal[E_HEADER] = TextDrawCreate(217.532165, 146.250015, "criar_personagem");
	TextDrawLetterSize(textCharCreationGlobal[E_HEADER], 0.400000, 1.600000);
	TextDrawAlignment(textCharCreationGlobal[E_HEADER], 3);
	TextDrawColor(textCharCreationGlobal[E_HEADER], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_HEADER], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_HEADER], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_HEADER], 255);
	TextDrawFont(textCharCreationGlobal[E_HEADER], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_HEADER], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_HEADER], 0);

	textCharCreationGlobal[E_BUTTON_BACK] = TextDrawCreate(3.886538, 142.750000, "<");
	TextDrawLetterSize(textCharCreationGlobal[E_BUTTON_BACK], 0.328783, 2.440001);
	TextDrawTextSize(textCharCreationGlobal[E_BUTTON_BACK], 17.000000, 20.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BUTTON_BACK], 1);
	TextDrawColor(textCharCreationGlobal[E_BUTTON_BACK], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_BACK], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BUTTON_BACK], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BUTTON_BACK], 255);
	TextDrawFont(textCharCreationGlobal[E_BUTTON_BACK], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BUTTON_BACK], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_BACK], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_BUTTON_BACK], true);

	textCharCreationGlobal[E_BACKGROUND][0] = TextDrawCreate(12.764693, 179.500015, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][0], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BACKGROUND][0], 209.399993, 249.399993);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][0], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][0], 70);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][0], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][0], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][0], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][0], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][0], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][0], 0);

	textCharCreationGlobal[E_BACKGROUND][1] = TextDrawCreate(18.000000, 183.000000, "Nome");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][1], 0.242576, 1.086665);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][1], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][1], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][1], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][1], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][1], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][1], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][1], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][1], 0);

	textCharCreationGlobal[E_BUTTON_NAME] = TextDrawCreate(18.000000, 194.000000, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BUTTON_NAME], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BUTTON_NAME], 199.000000, 16.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BUTTON_NAME], 1);
	TextDrawColor(textCharCreationGlobal[E_BUTTON_NAME], 50);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_NAME], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BUTTON_NAME], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BUTTON_NAME], 255);
	TextDrawFont(textCharCreationGlobal[E_BUTTON_NAME], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BUTTON_NAME], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_NAME], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_BUTTON_NAME], true);

	textCharCreationGlobal[E_BACKGROUND][2] = TextDrawCreate(18.000000, 214.999908, ConvertToGameText("G�nero"));
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][2], 0.242576, 1.086665);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][2], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][2], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][2], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][2], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][2], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][2], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][2], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][2], 0);

	textCharCreationGlobal[E_BACKGROUND_GENDER][0] = TextDrawCreate(18.000000, 226.000000, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 199.000000, 16.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 50);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND_GENDER][0], 0);

	textCharCreationGlobal[E_BACKGROUND_GENDER][1] = TextDrawCreate(118.000000, 229.683868, "]");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 0.242576, 1.086665);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 2);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND_GENDER][1], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND_GENDER][1], 0);

	textCharCreationGlobal[E_BACKGROUND][3] = TextDrawCreate(18.000000, 247.083099, "Skin");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][3], 0.242576, 1.086665);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][3], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][3], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][3], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][3], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][3], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][3], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][3], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][3], 0);

	textCharCreationGlobal[E_BUTTON_SKIN] = TextDrawCreate(18.000000, 258.083160, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BUTTON_SKIN], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BUTTON_SKIN], 199.000000, 16.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BUTTON_SKIN], 1);
	TextDrawColor(textCharCreationGlobal[E_BUTTON_SKIN], 50);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_SKIN], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BUTTON_SKIN], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BUTTON_SKIN], 255);
	TextDrawFont(textCharCreationGlobal[E_BUTTON_SKIN], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BUTTON_SKIN], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_SKIN], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_BUTTON_SKIN], true);

	textCharCreationGlobal[E_BACKGROUND][4] = TextDrawCreate(18.000000, 279.083557, "Cabelo");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][4], 0.242576, 1.086665);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][4], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][4], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][4], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][4], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][4], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][4], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][4], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][4], 0);

	textCharCreationGlobal[E_BUTTON_HAIR] = TextDrawCreate(18.000000, 290.083801, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BUTTON_HAIR], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BUTTON_HAIR], 199.000000, 16.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BUTTON_HAIR], 1);
	TextDrawColor(textCharCreationGlobal[E_BUTTON_HAIR], 50);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_HAIR], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BUTTON_HAIR], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BUTTON_HAIR], 255);
	TextDrawFont(textCharCreationGlobal[E_BUTTON_HAIR], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BUTTON_HAIR], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_HAIR], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_BUTTON_HAIR], true);

	textCharCreationGlobal[E_BACKGROUND][5] = TextDrawCreate(18.000000, 311.383819, "Olho");
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][5], 0.242576, 1.086665);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][5], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][5], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][5], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][5], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][5], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][5], 2);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][5], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][5], 0);

	textCharCreationGlobal[E_BUTTON_EYE] = TextDrawCreate(18.000000, 322.083801, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BUTTON_EYE], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BUTTON_EYE], 199.000000, 16.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BUTTON_EYE], 1);
	TextDrawColor(textCharCreationGlobal[E_BUTTON_EYE], 50);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_EYE], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BUTTON_EYE], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BUTTON_EYE], 255);
	TextDrawFont(textCharCreationGlobal[E_BUTTON_EYE], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BUTTON_EYE], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_EYE], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_BUTTON_EYE], true);

	textCharCreationGlobal[E_BACKGROUND][6] = TextDrawCreate(18.205001, 342.083740, ConvertToGameText("~r~NOTA~w~: Tenha certeza das caracter�sticas que quer~n~para seu personagem, n�o ser� poss�vel alterar~n~futuramente, somente criando um novo."));
	TextDrawLetterSize(textCharCreationGlobal[E_BACKGROUND][6], 0.242576, 1.127498);
	TextDrawAlignment(textCharCreationGlobal[E_BACKGROUND][6], 1);
	TextDrawColor(textCharCreationGlobal[E_BACKGROUND][6], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][6], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BACKGROUND][6], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BACKGROUND][6], 255);
	TextDrawFont(textCharCreationGlobal[E_BACKGROUND][6], 1);
	TextDrawSetProportional(textCharCreationGlobal[E_BACKGROUND][6], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_BACKGROUND][6], 0);

	textCharCreationGlobal[E_BUTTON_CREATE] = TextDrawCreate(18.000000, 395.000000, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_BUTTON_CREATE], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_BUTTON_CREATE], 199.000000, 28.000000);
	TextDrawAlignment(textCharCreationGlobal[E_BUTTON_CREATE], 1);
	TextDrawColor(textCharCreationGlobal[E_BUTTON_CREATE], 100);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_CREATE], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_BUTTON_CREATE], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_BUTTON_CREATE], 255);
	TextDrawFont(textCharCreationGlobal[E_BUTTON_CREATE], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_BUTTON_CREATE], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_BUTTON_CREATE], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_BUTTON_CREATE], true);

	textCharCreationGlobal[E_TEXT_CREATE] = TextDrawCreate(118.000000, 399.000000, "CRIAR");
	TextDrawLetterSize(textCharCreationGlobal[E_TEXT_CREATE], 0.562574, 2.049165);
	TextDrawAlignment(textCharCreationGlobal[E_TEXT_CREATE], 2);
	TextDrawColor(textCharCreationGlobal[E_TEXT_CREATE], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_TEXT_CREATE], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_TEXT_CREATE], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_TEXT_CREATE], 255);
	TextDrawFont(textCharCreationGlobal[E_TEXT_CREATE], 3);
	TextDrawSetProportional(textCharCreationGlobal[E_TEXT_CREATE], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_TEXT_CREATE], 0);

	/*
	 *************************************************************************/

	textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0] = TextDrawCreate(12.764693, 179.500015, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 209.000000, 48.000000);
	TextDrawAlignment(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 1);
	TextDrawColor(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 70);
	TextDrawSetShadow(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 255);
	TextDrawFont(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], 0);
	TextDrawSetSelectable(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0], true);

	textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1] = TextDrawCreate(18.000000, 194.000000, "LD_SPAC:white");
	TextDrawLetterSize(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 199.000000, 16.000000);
	TextDrawAlignment(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 1);
	TextDrawColor(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 50);
	TextDrawSetShadow(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 255);
	TextDrawFont(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 4);
	TextDrawSetProportional(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 0);
	TextDrawSetShadow(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1], 0);

	textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2] = TextDrawCreate(117.531478, 212.000457, "Use ~r~A~w~ e ~r~D~w~ para passar, e ~r~SPACE~w~ para selecionar.");
	TextDrawLetterSize(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 0.242576, 1.127498);
	TextDrawAlignment(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 2);
	TextDrawColor(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], -1);
	TextDrawSetShadow(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 0);
	TextDrawSetOutline(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 0);
	TextDrawBackgroundColor(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 255);
	TextDrawFont(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 1);
	TextDrawSetProportional(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 1);
	TextDrawSetShadow(textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2], 0);
}

///	<summary>
/// Cria todas as Textdraws Privadas do menu Sele��o de Personagem.
/// </summary>
/// <returns>N�o retorna valores.</returns>
static CreatePrivateTDCharSelection(playerid)
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

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0] = CreatePlayerTextDraw(playerid, 45.764713, 183.583312, "name");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][0], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][0] = CreatePlayerTextDraw(playerid, 45.764713, 198.166580, "last_acess");
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

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1] = CreatePlayerTextDraw(playerid, 45.764713, 226.750000, "name");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][1], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][1] = CreatePlayerTextDraw(playerid, 45.764713, 241.333267, "last_acess");
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

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2] = CreatePlayerTextDraw(playerid, 45.764713, 269.916687, "name");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][2], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][2] = CreatePlayerTextDraw(playerid, 45.764713, 284.499969, "last_acess");
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

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3] = CreatePlayerTextDraw(playerid, 45.764713, 313.083374, "name");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][3], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][3] = CreatePlayerTextDraw(playerid, 45.764713, 327.666656, "last_acess");
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

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4] = CreatePlayerTextDraw(playerid, 45.764713, 356.250061, "name");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0.407999, 1.792497);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], -1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 1);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][4], 0);

	textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4] = CreatePlayerTextDraw(playerid, 45.764713, 370.833343, "last_acess");
	PlayerTextDrawLetterSize(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0.186351, 1.179998);
	PlayerTextDrawAlignment(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 1);
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], -5963521);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0);
	PlayerTextDrawSetOutline(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 255);
	PlayerTextDrawFont(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 2);
	PlayerTextDrawSetProportional(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 1);
	PlayerTextDrawSetShadow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][4], 0);

	/*
	 *************************************************************************/

	textCharCreationPrivate[playerid][E_CHAR_NAME] = CreatePlayerTextDraw(playerid, 118.000000, 196.000000, "name");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 0.242576, 1.086665);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 2);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], 0);

	textCharCreationPrivate[playerid][E_CHAR_SKIN] = CreatePlayerTextDraw(playerid, 118.000000, 260.600036, "555");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 0.242576, 1.086665);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 2);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], 0);

	textCharCreationPrivate[playerid][E_CHAR_HAIR] = CreatePlayerTextDraw(playerid, 118.000000, 292.683898, "Padrao");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 0.242576, 1.086665);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 2);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], 0);

	textCharCreationPrivate[playerid][E_CHAR_EYE] = CreatePlayerTextDraw(playerid, 118.000000, 324.583831, "Azul");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 0.242576, 1.086665);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 2);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], 0);

	textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE] = CreatePlayerTextDraw(playerid, 51.938522, 229.166564, "Masculino");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 0.242576, 1.086665);
	PlayerTextDrawTextSize(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 109.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 1);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], 0);
	PlayerTextDrawSetSelectable(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], true);

	textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE] = CreatePlayerTextDraw(playerid, 129.713027, 229.166564, "Feminino");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 0.242576, 1.086665);
	PlayerTextDrawTextSize(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 177.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 1);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], 0);
	PlayerTextDrawSetSelectable(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], true);

	/*
	 *************************************************************************/

	textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT] = CreatePlayerTextDraw(playerid, 18.000000, 183.000000, "Skin");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 0.242576, 1.086665);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 1);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], 0);

	textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE] = CreatePlayerTextDraw(playerid, 118.000000, 196.000000, "555");
	PlayerTextDrawLetterSize(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 0.242576, 1.086665);
	PlayerTextDrawAlignment(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 2);
	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], -1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 0);
	PlayerTextDrawSetOutline(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 0);
	PlayerTextDrawBackgroundColor(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 255);
	PlayerTextDrawFont(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 2);
	PlayerTextDrawSetProportional(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 1);
	PlayerTextDrawSetShadow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], 0);
}

/// <summary>
/// Cria os objetos globais do cen�rio de apresenta��o do personagem.
/// </summary>
/// <returns>N�o retorna valores.</returns>
static CreateScenarioGlobal()
{
	CreateDynamicObject(14390, 1254.05969, -775.77258, 1086.24707, 0.00000, 0.00000, -90.00000, .interiorid = 5);
	CreateDynamicObject(14390, 1252.07983, -771.75250, 1086.24707, 0.00000, 0.00000, -90.00000, .interiorid = 5);
	CreateDynamicObject(19377, 1273.71692, -792.10327, 1082.92444, 0.00000, 90.00000, 0.00000, .interiorid = 5);
	CreateDynamicObject(14399, 1271.29700, -788.77606, 1083.00781, 0.00000, 0.00000, -180.00000, .interiorid = 5);
}

/// <summary>
/// Cria os objetos privados do cen�rio de apresenta��o do personagem.
/// </summary>
/// <param name="playerid">ID do jogador ao qual deve ser aplicado as fun��es privadas.</param>
/// <returns>N�o retorna valores.</returns>
static CreateScenarioPrivate(playerid)
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

/// <summary>
/// Carrega e seta um jogador espec�fico no cen�rio de sele��o de personagens.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
LoadSelectionCharacterScenario(playerid)
{
	SetPlayerInterior(playerid, 5);
	SetPlayerPos(playerid, menuSelectionCharPositionOut[0], menuSelectionCharPositionOut[1], menuSelectionCharPositionOut[2]);
	SetPlayerFacingAngle(playerid, 274.0/*272.9013*/);
	SetPlayerSkin(playerid, charFeatureMaleSkins[0]);

	TogglePlayerControllable(playerid, false);

	SetPlayerCameraPos(playerid, camPosSelectionCharacter[0], camPosSelectionCharacter[1], camPosSelectionCharacter[2]);
	SetPlayerCameraLookAt(playerid, camLookAtSelectionCharacter[0], camLookAtSelectionCharacter[1], camLookAtSelectionCharacter[2]);

	/*SetPlayerCameraPos(playerid, 1277.9937, -794.2797, 1084.8776);
	SetPlayerCameraLookAt(playerid, 1276.9946, -794.2579, 1084.6156);*/

	//olhos e cabelo
	/*SetPlayerCameraPos(playerid, 1277.3708, -794.2350, 1084.9235);
	SetPlayerCameraLookAt(playerid, 1276.3722, -794.0945, 1084.8417);*/

	CreateScenarioActors(playerid);
}

/// <summary>
/// Remove um jogador espec�fico do cen�rio de sele��o de personagens.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
OutSelectionCharacterScenario(playerid)
{
	stop playerActorScenario[playerid][E_ACTOR_CONVERSATION_TIMER][0];
	stop playerActorScenario[playerid][E_ACTOR_CONVERSATION_TIMER][1];

	DestroyActor(playerActorScenario[playerid][E_ACTOR_ID][0]);
	DestroyActor(playerActorScenario[playerid][E_ACTOR_ID][1]);
}
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Cria os atores do cen�rio de apresenta��o do personagem ao jogador.
/// </summary>
/// <returns>N�o retorna valores.</returns>
static CreateScenarioActors(playerid)
{
	new virtualworld = GetPlayerVirtualWorld(playerid);

	playerActorScenario[playerid][E_ACTOR_ID][0] = CreateActor(20013, 1273.0809, -793.1731, 1084.1718, 0.6119);
	playerActorScenario[playerid][E_ACTOR_ID][1] = CreateActor(20014, 1273.0214, -792.4755, 1084.1611, 185.7939);

	SetActorVirtualWorld(playerActorScenario[playerid][E_ACTOR_ID][0], virtualworld);
	SetActorVirtualWorld(playerActorScenario[playerid][E_ACTOR_ID][1], virtualworld);

	LoadActorAnimations(playerid);
	LoadActorsConversation(playerid);
}

/// <summary>
/// Carrega todas livrarias de anima��es usadas pelos atores de um jogador
/// espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
static LoadActorAnimations(playerid)
{
	for(new i; i < 2; i++)
	{
		ApplyActorAnimation(playerActorScenario[playerid][E_ACTOR_ID][i], "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
		ApplyActorAnimation(playerActorScenario[playerid][E_ACTOR_ID][i], "GANGS", "null", 0.0, 0, 0, 0, 0, 0);
		ApplyActorAnimation(playerActorScenario[playerid][E_ACTOR_ID][i], "OTB", "null", 0.0, 0, 0, 0, 0, 0);
		ApplyActorAnimation(playerActorScenario[playerid][E_ACTOR_ID][i], "ped", "null", 0.0, 0, 0, 0, 0, 0);
		ApplyActorAnimation(playerActorScenario[playerid][E_ACTOR_ID][i], "PLAYIDLES", "null", 0.0, 0, 0, 0, 0, 0);
	}
}

/// <summary>
/// Carrega e da in�cio a conversa��o entre os 2 atores de um jogador
/// espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
static LoadActorsConversation(playerid)
{
	new idSpeech = random(2);//id 0 ou 1

	ActorConversation(playerid, idSpeech, CONVERSATION_TYPE_SPEECH);
	ActorConversation(playerid, !idSpeech, CONVERSATION_TYPE_RESPONSE);
}
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Configura valores espec�ficos(definidos para testes) dos Personagens.
/// * Fun��o tempor�ria.
/// </summary>
/// <param name="playerid">ID do jogador a se setar esses valores.</param>
/// <returns>N�o retorna valores.</returns>
static ConfigureCharactersValues(playerid)
{
	new i;

	playerCharacters[playerid][E_ACCOUNT_TYPE] = ACCOUNT_TYPE_NORMAL;

	for(i = 0; i < ACCOUNT_TYPE_NORMAL; i++)
		ConfigureCharacterSlot(playerid, CONFIG_RESET_SLOT, i),
		UpdateTDCharacterSlot(playerid, i);

	for(i = playerCharacters[playerid][E_ACCOUNT_TYPE]; i < ACCOUNT_TYPE_PREMIUM; i++)
		ConfigureCharacterSlot(playerid, CONFIG_BLOCK_SLOT, i),
		UpdateTDCharacterSlot(playerid, i);
}

/// <summary>
/// Configura um personagem espec�fico de um jogador espec�fico atrav�s do seu
/// slot.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="configureType">Tipo da configura��o a ser aplicada no slot do personagem (CONFIG_REST_SLOT|CONFIG_SET_CHAR_SLOT|CONFIG_BLOCK_SLOT).</param>
/// <param name="slotID">ID do slot do Personagem.</param>
/// <param name="auxValue">Vari�vel auxiliar para armazenar o id da skin do personagem passada quando configureType for CONFIG_SET_CHAR_SLOT.</param>
/// <param name="auxString">Vari�vel auxiliar para armazenar o nome do personagem passado quando configureType for CONFIG_SET_CHAR_SLOT.</param>
/// <returns>N�o retorna valores.</returns>
static ConfigureCharacterSlot(playerid, configureType, slotID, auxValue = -1, auxString[MAX_PLAYER_NAME] = "")
{
	switch(configureType)
	{
		case CONFIG_RESET_SLOT:
		{
			playerCharacters[playerid][E_CHAR_STATE][slotID] = STATE_EMPTY;
			playerCharacters[playerid][E_CHAR_SKIN][slotID] = 19134;//create char icon
			playerCharacters[playerid][E_CHAR_NAME][slotID] = EOS;

			for(new i; i < 5; i++)
				playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][i] = 0;

		}
		case CONFIG_SET_CHAR_SLOT:
		{
			playerCharacters[playerid][E_CHAR_STATE][slotID] = STATE_CREATED;
			playerCharacters[playerid][E_CHAR_SKIN][slotID] = auxValue;

			format(playerCharacters[playerid][E_CHAR_NAME][slotID], sizeof(auxString), auxString);

			for(new i; i < 5; i++)
				playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][i] = 0;
		}
		case CONFIG_BLOCK_SLOT:
		{
			playerCharacters[playerid][E_CHAR_STATE][slotID] = STATE_BLOCKED;
			playerCharacters[playerid][E_CHAR_SKIN][slotID] = 19804;//block slot icon
			playerCharacters[playerid][E_CHAR_NAME][slotID] = EOS;

			for(new i; i < 5; i++)
				playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][i] = 0;
		}
	}
}

/// <summary>
/// Mostra o menu de sele��o de personagem a um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="showCursor">True para mostrar o cursor, False para n�o.</param>
/// <returns>N�o retorna valores.</returns>
ShowMenuSelectionCharacter(playerid, bool:showCursor = true)
{
	new i;

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_HEADER][0]);
	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_HEADER][1]);

	for(i = 0; i < 5; i++)
		TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_CHAR_SLOT][i]);

	for(i = 0; i < 5; i++)
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][i]),
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][i]),
		PlayerTextDrawShow(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][i]);

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EDIT]);
	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EDIT_TEXT]);

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EXIT]);
	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EXIT_TEXT]);

	if(showCursor)
		SelectTextDraw(playerid, SELECTOR_TEXTDRAW_COLOR, this);//0xDDDDDDAA

	RemovePlayerAttachedObject(playerid, CHAR_FEATURE_EYE_L_ATTACH_INDEX);
	RemovePlayerAttachedObject(playerid, CHAR_FEATURE_EYE_R_ATTACH_INDEX);
	RemovePlayerAttachedObject(playerid, CHAR_FEATURE_HAIR_ATTACH_INDEX);

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_MAIN;
}

/// <summary>
/// Esconde o menu de Sele��o de Personagem a um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="hideCursor">True para esconder o cursor, False para n�o.</param>
/// <returns>N�o retorna valores.</returns>
HideMenuSelectionCharacter(playerid, bool:hideCursor = true)
{
	new i;

	TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_HEADER][0]);
	TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_HEADER][1]);

	for(i = 0; i < 5; i++)
		TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_CHAR_SLOT][i]);

	for(i = 0; i < 5; i++)
		PlayerTextDrawHide(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][i]),
		PlayerTextDrawHide(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][i]),
		PlayerTextDrawHide(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][i]);

	TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EDIT]);
	TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EDIT_TEXT]);

	TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EXIT]);
	TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_EXIT_TEXT]);

	if(textSelectedControl[playerid][E_BUTTON_EDIT])
	{
		TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH]);
		TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH_TEXT]);
		TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_TRASH_ICON]);

		for(i = 0; i < 5; i++)
			TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_BUTTON_DELETE][i]);
	}

	if(hideCursor)
		CancelSelectTextDraw(playerid);

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_NONE;
	
	textSelectedControl[playerid][E_BUTTON_EDIT] = false;
}

/// <summary>
/// Reseta configura��es do menu de cria��o de personagem de um jogador
/// espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
static ResetMenuCreationCharacter(playerid)
{
	format(playerCreateCharacter[playerid][E_PLAYER_CHAR_NAME], MAX_PLAYER_NAME, text_char_feature_default_name);
	playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] = GENDER_TYPE_MALE;
	playerCreateCharacter[playerid][E_PLAYER_SKIN_SELECTED] = 0;
	playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED] = playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED] = FEATURE_TYPE_DEFAULT;
}

/// <summary>
/// Mostra o menu de Cria��o de Personagem a um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="showCursor">True para mostrar o cursor, False para n�o.</param>
/// <returns>N�o retorna valores.</returns>
static ShowMenuCreationCharacter(playerid, bool:showCursor)
{
	new i,
		skinid = (playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] == GENDER_TYPE_MALE ? (charFeatureMaleSkins[playerCreateCharacter[playerid][E_PLAYER_SKIN_SELECTED]]) : (charFeatureFemaleSkins[playerCreateCharacter[playerid][E_PLAYER_SKIN_SELECTED]]));			

	TextDrawShowForPlayer(playerid, textCharSelectionGlobal[E_HEADER][0]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_HEADER]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BUTTON_BACK]);

	for(i = 0; i < 7; i++)
		TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BACKGROUND][i]);

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BUTTON_NAME]);

	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME], playerCreateCharacter[playerid][E_PLAYER_CHAR_NAME]);
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME]);
	//playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE]

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BACKGROUND_GENDER][0]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BACKGROUND_GENDER][1]);

	/*PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], COLOR_GENDER_SELECTED);
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE]);

	PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], COLOR_GENDER_UNSELECTED);
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE]);*/
	ChangeCharacterFeatureGender(playerid, playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED], false);

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BUTTON_SKIN]);
	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], ConvertIntToString(skinid));
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN]);

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BUTTON_HAIR]);
	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], ConvertToGameText(charFeatureHairs[playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED]][E_FEATURE_HAIR_NAME]));
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR]);

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BUTTON_EYE]);
	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], ConvertToGameText(charFeatureEyes[playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED]][E_FEATURE_EYES_NAME]));
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE]);

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_BUTTON_CREATE]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_TEXT_CREATE]);

	if(showCursor)
		SelectTextDraw(playerid, SELECTOR_TEXTDRAW_COLOR, this);

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_CREATE_CHAR;
}

/// <summary>
/// Esconde o menu de Cria��o de Personagem a um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="hideCursor">True para esconder o cursor, False para n�o.</param>
/// <param name="noHideHeader">True para n�o esconder o cabe�alho, False para esconder.</param>
/// <returns>N�o retorna valores.</returns>
static HideMenuCreationCharacter(playerid, bool:hideCursor, bool:noHideHeader = false)
{
	new i;

	if(!noHideHeader)
	{
		TextDrawHideForPlayer(playerid, textCharSelectionGlobal[E_HEADER][0]);
		TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_HEADER]);
		TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BUTTON_BACK]);
	}

	for(i = 0; i < 7; i++)
		TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BACKGROUND][i]);

	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BUTTON_NAME]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_CHAR_NAME]);

	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BACKGROUND_GENDER][0]);
	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BACKGROUND_GENDER][1]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE]);

	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BUTTON_SKIN]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN]);

	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BUTTON_HAIR]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR]);

	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BUTTON_EYE]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE]);
	
	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_BUTTON_CREATE]);
	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_TEXT_CREATE]);

	if(hideCursor)
		CancelSelectTextDraw(playerid);

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_NONE;
}

/// <summary>
/// Mostra o menu de configura��o de uma caracter�stica espec�fica do
/// personagem a ser criado para um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="featureType">Tipo da caracter�stica.</param>
/// <returns>N�o retorna valores.</returns>
static ShowMenuConfigCharFeature(playerid, featureType)
{
	HideMenuCreationCharacter(playerid, true, true);
	
	playerMenuCharacter[playerid][E_PLAYER_SETTING_FEATURE_TYPE] = featureType;

	switch(featureType)
	{
		case CHAR_FEATURE_EYE, CHAR_FEATURE_HAIR:
		{
			playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED] = playerCreateCharacter[playerid][(featureType == CHAR_FEATURE_EYE) ? (E_PLAYER_EYE_SELECTED) : (E_PLAYER_HAIR_SELECTED)];

			InterpolateCameraPos(playerid, camPosSelectionCharacter[0], camPosSelectionCharacter[1], camPosSelectionCharacter[2], camPosConfigCharacterFeature[0], camPosConfigCharacterFeature[1], camPosConfigCharacterFeature[2], CHAR_FEAUTRE_CAMERA_MOVE_TIME, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, camLookAtSelectionCharacter[0], camLookAtSelectionCharacter[1], camLookAtSelectionCharacter[2], camLookAtConfigCharacterFeature[0], camLookAtConfigCharacterFeature[1], camLookAtConfigCharacterFeature[2], CHAR_FEAUTRE_CAMERA_MOVE_TIME, CAMERA_MOVE);

			defer CharCameraMoveFinished(playerid, 0, featureType);
			return;
		}
		case CHAR_FEATURE_SKIN:
			playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED] = playerCreateCharacter[playerid][E_PLAYER_SKIN_SELECTED];
	}

	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1]);
	TextDrawShowForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2]);

	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT], featureText[featureType][0]);
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT]);
	PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], GetFeatureValueName(playerid, featureType));
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_CREATE_FEATURE;
}

/// <summary>
/// Esconde o menu de configura��o de uma caracter�stica espec�fica do
/// personagem a ser criado para um jogador espec�fico.
/// espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
static HideMenuConfigCharFeature(playerid)
{
	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_NONE;

	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][0]);
	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][1]);
	TextDrawHideForPlayer(playerid, textCharCreationGlobal[E_SELECT_FEATURE_BACKGROUND][2]);

	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_TEXT]);
	PlayerTextDrawHide(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);

	switch(playerMenuCharacter[playerid][E_PLAYER_SETTING_FEATURE_TYPE])
	{
		case CHAR_FEATURE_EYE, CHAR_FEATURE_HAIR:
		{
			playerMenuCharacter[playerid][E_PLAYER_SETTING_FEATURE_TYPE] = CHAR_FEATURE_NONE;

			InterpolateCameraPos(playerid, camPosConfigCharacterFeature[0], camPosConfigCharacterFeature[1], camPosConfigCharacterFeature[2], camPosSelectionCharacter[0], camPosSelectionCharacter[1], camPosSelectionCharacter[2], CHAR_FEAUTRE_CAMERA_MOVE_TIME, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, camLookAtConfigCharacterFeature[0], camLookAtConfigCharacterFeature[1], camLookAtConfigCharacterFeature[2], camLookAtSelectionCharacter[0], camLookAtSelectionCharacter[1], camLookAtSelectionCharacter[2], CHAR_FEAUTRE_CAMERA_MOVE_TIME, CAMERA_MOVE);
			
			defer CharCameraMoveFinished(playerid, 1, CHAR_FEATURE_NONE);
			return;
		}
	}

	playerMenuCharacter[playerid][E_PLAYER_SETTING_FEATURE_TYPE] = CHAR_FEATURE_NONE;

	ShowMenuCreationCharacter(playerid, true);
}

/// <summary>
/// Obt�m o nome de uma caracter�stica espec�fica que est� sendo selecionada na
/// cria��o de personagem de um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="featureType">Tipo da caracter�stica.</param>
/// <returns>Nome da caracter�stica selecionada.</returns>
static GetFeatureValueName(playerid, featureType)
{
	new string[12];

	switch(featureType)
	{
		case CHAR_FEATURE_SKIN:
		{
			new skinid = (playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] == GENDER_TYPE_MALE ? (charFeatureMaleSkins[playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]]) : (charFeatureFemaleSkins[playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]]));
						
			format(string, sizeof(string), ConvertIntToString(skinid));
		}

		case CHAR_FEATURE_HAIR:
			format(string, sizeof(string), "%s", ConvertToGameText(charFeatureHairs[playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]][E_FEATURE_HAIR_NAME]));

		case CHAR_FEATURE_EYE:
			format(string, sizeof(string), "%s", ConvertToGameText(charFeatureEyes[playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]][E_FEATURE_EYES_NAME]));
	}

	return string;// ConvertToGameText(string);
}

/// <summary>
/// Obt�m o index da matriz attachCharsFeatureEyes de uma skin espec�fica.
/// </summary>
/// <param name="skinid">ID da skin.</param>
/// <returns>Index da matriz. FEATURE_TYPE_INVALID se nada for encontrado.</returns>
static GetPlayerArrayEyesSkinIndex(skinid)
{
	for(new i; i < MAX_CHAR_SKINS * 2; i++)
	{
		if(attachCharsFeatureEyes[i][E_CHAR_SKIN_ID][0] == skinid || attachCharsFeatureEyes[i][E_CHAR_SKIN_ID][1] == skinid)
			return i;
	}
	return FEATURE_TYPE_INVALID;		
}

/// <summary>
/// Obt�m o index da matriz attachCharsFeatureHairs de uma skin espec�fica.
/// </summary>
/// <param name="skinid">ID da skin.</param>
/// <returns>Index da matriz. FEATURE_TYPE_INVALID se nada for encontrado.</returns>
static GetPlayerArrayHairsSkinIndex(skinid)
{
	for(new i, j; i < MAX_FEATURE_HAIRS; i++)
	{
		for(j = 0; j < 3; j++)
		{
			if(attachCharsFeatureHairs[i][j][E_CHAR_SKIN_ID][0] == skinid || attachCharsFeatureHairs[i][j][E_CHAR_SKIN_ID][1] == skinid)
				return i;
		}
	}
	return FEATURE_TYPE_INVALID;		
}
/*
-----------------------------------------------------------------------------*/
/// <summary>
/// Atualiza a informa��o 'g�nero' do menu de cria��o de personagem.
/// Se 'isChangedByPlayer' for true, seta a primeira skin do g�nero alterado e
/// remove as caracter�sticas cabelo e olho se estiverem setadas.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="genderid">Tipo do g�nero (GENDER_TYPE_MALE | GENDER_TYPE_FEMALE).</param>
/// <param name="isChangedByPlayer">True se a altera��o do g�nero foi feita pelo jogador, False se n�o.</param>
/// <returns>N�o retorna valores.</returns>
static ChangeCharacterFeatureGender(playerid, genderid, bool:isChangedByPlayer = true)
{
	if(genderid == GENDER_TYPE_MALE)
	{
		PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], COLOR_GENDER_SELECTED);
		PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], COLOR_GENDER_UNSELECTED);
	}
	else
	{
		PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE], COLOR_GENDER_UNSELECTED);
		PlayerTextDrawColor(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE], COLOR_GENDER_SELECTED);
	}
	
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_MALE]);
	PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_BUTTON_GENDER_FEMALE]);

	if(isChangedByPlayer)
	{
		new skinid = (genderid == GENDER_TYPE_MALE ? (charFeatureMaleSkins[0]) : (charFeatureFemaleSkins[0]));

		PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN], ConvertIntToString(skinid));
		PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_SKIN]);

		playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] = genderid;
		playerCreateCharacter[playerid][E_PLAYER_SKIN_SELECTED] = 0;

		SetPlayerSkin(playerid, skinid);

		if(playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED] != FEATURE_TYPE_DEFAULT)
		{
			playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED] = FEATURE_TYPE_DEFAULT;

			PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE], charFeatureEyes[0][E_FEATURE_EYES_NAME]);
			PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_EYE]);

			RemovePlayerAttachedObject(playerid, CHAR_FEATURE_EYE_L_ATTACH_INDEX);
			RemovePlayerAttachedObject(playerid, CHAR_FEATURE_EYE_R_ATTACH_INDEX);
		}
		if(playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED] != FEATURE_TYPE_DEFAULT)
		{
			playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED] = FEATURE_TYPE_DEFAULT;

			PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR], charFeatureHairs[0][E_FEATURE_HAIR_NAME]);
			PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_CHAR_HAIR]);
			
			RemovePlayerAttachedObject(playerid, CHAR_FEATURE_HAIR_ATTACH_INDEX);
		}
	}
}

/// <summary>
/// Reseta configura��es do menu de sele��o de personagem de um jogador
/// espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores.</returns>
static ConfigureMenuSelectionCharacter(playerid)
{
	textSelectedControl[playerid][E_CHAR_SLOT] = INVALID_CHAR_SLOT;
	textSelectedControl[playerid][E_BUTTON_EDIT] = false;

	playerMenuCharacter[playerid][E_PLAYER_IN_MENU_PAGE] = MENU_PAGE_NONE;
	playerMenuCharacter[playerid][E_PLAYER_SETTING_FEATURE_TYPE] = CHAR_FEATURE_NONE;

	playerMenuCharacter[playerid][E_PLAYER_KEY_PRESSED] = 0;
}

/// <summary>
/// Atualiza as informa��es da TextDraw de um Personagem espec�fico
/// (atrav�s do slotID) de um jogador espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="slotID">ID do slot do Personagem.</param>
/// <param name="showChanges">True para mostrar modifica��es, False para n�o.</param>
/// <returns>N�o retorna valores.</returns>
static UpdateTDCharacterSlot(playerid, slotID, bool:showChanges = false)
{
	PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], -5963521);
	PlayerTextDrawSetPreviewModel(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], playerCharacters[playerid][E_CHAR_SKIN][slotID]);

	switch(playerCharacters[playerid][E_CHAR_STATE][slotID])
	{
		case STATE_EMPTY:
		{
			PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 0.000000, 0.000000, 90.000000, 1.045655);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], -1);

			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], text_character_new_char);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], -1);

			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], text_character_create_char);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], 900738815/*-1378294017*/);
		}
		case STATE_CREATED:
		{
			PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 0.000000, 0.000000, 0.000000, 1.045655);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], -1);
			
			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], playerCharacters[playerid][E_CHAR_NAME][slotID]);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], -1);

			PlayerTextDrawSetStringFormat(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], ConvertToGameText(text_character_last_acess), playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][0], playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][1], playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][2], playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][3], playerCharacters[playerid][E_CHAR_LAST_ACESS][slotID][4]);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], -1378294017);
		}
		case STATE_BLOCKED:
		{
			PlayerTextDrawSetPreviewRot(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 0.000000, 0.000000, 0.000000, 1.045655);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_SKIN][slotID], 255);

			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], text_character_blocked_char);
			PlayerTextDrawColor(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_NAME][slotID], 255);
			
			PlayerTextDrawSetString(playerid, textCharSelectionPrivate[playerid][E_CHAR_SLOT_LAST_ACESS][slotID], ConvertToGameText(text_character_slot_unavailable));
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

/// <summary>
/// Aplica as fun��es da caracter�stica selecionada no menu de cria��o de personagens.
/// As fun��es podem ser avan�ar/voltar caracter�stica ou selecionar.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="keyLR">ID da tecla pressionada: A (esquerda) ou D (direita).</param>
/// <param name="keys">ID da tecla pressionada: SPACE.</param>
/// <returns>N�o retorna valores.</returns>
static MenuCreationCharacterKeyPress(playerid, keyLR, keys)
{
	static featureType, valueSelected;

	featureType = playerMenuCharacter[playerid][E_PLAYER_SETTING_FEATURE_TYPE];
	valueSelected = playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED];

	if(keyLR == KEY_LEFT && playerMenuCharacter[playerid][E_PLAYER_KEY_PRESSED] != KEY_LEFT)
	{
		switch(featureType)
		{
			case CHAR_FEATURE_SKIN:
			{
				if(valueSelected > 0)
				{
					new skinid = (playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED] == GENDER_TYPE_MALE ? (charFeatureMaleSkins[valueSelected - 1]) : (charFeatureFemaleSkins[valueSelected - 1]));
					
					MenuCreationCharUpdateFeature(playerid, featureType, skinid);

					playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]--;
				}
			}

			case CHAR_FEATURE_EYE:
			{
				valueSelected -= 1;

				if(valueSelected < 0)
					goto out_key_left;

				if(!MenuCreationCharUpdateFeature(playerid, featureType, valueSelected))
					goto out_key_left;

				playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]--;
			}

			case CHAR_FEATURE_HAIR:
			{
				valueSelected -= 1;

				if(valueSelected < 0)
					goto out_key_left;

				if(!MenuCreationCharUpdateFeature(playerid, featureType, valueSelected))
					goto out_key_left;

				playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]--;
			}
		}

		out_key_left:

		playerMenuCharacter[playerid][E_PLAYER_KEY_PRESSED] = KEY_LEFT;
	}
	else if(keyLR == KEY_RIGHT && playerMenuCharacter[playerid][E_PLAYER_KEY_PRESSED] != KEY_RIGHT)
	{
		switch(featureType)
		{
			case CHAR_FEATURE_SKIN:
			{
				new genderType = playerCreateCharacter[playerid][E_PLAYER_GENDER_SELECTED];

				if(valueSelected < ((genderType == GENDER_TYPE_MALE ? (MAX_FEATURE_MALE_SKINS) : (MAX_FEATURE_FEMALE_SKINS)) - 1))
				{
					new skinid = (genderType == GENDER_TYPE_MALE ? (charFeatureMaleSkins[valueSelected + 1]) : (charFeatureFemaleSkins[valueSelected + 1]));

					MenuCreationCharUpdateFeature(playerid, featureType, skinid);

					playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]++;
				}
			}

			case CHAR_FEATURE_EYE:
			{
				if(valueSelected < (MAX_FEATURE_EYES) - 1)//sizeof(attachCharsFeatureEyes))//(MAX_CHAR_SKINS - 1))
				{
					valueSelected += 1;

					if(!MenuCreationCharUpdateFeature(playerid, featureType, valueSelected))
						goto out_key_right;

					playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]++;
				}
			}

			case CHAR_FEATURE_HAIR:
			{
				if(valueSelected < (MAX_FEATURE_HAIRS) - 1)
				{
					valueSelected += 1;

					if(!MenuCreationCharUpdateFeature(playerid, featureType, valueSelected))
						goto out_key_right;

					playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED]++;
				}
			}
		}

		out_key_right:

		playerMenuCharacter[playerid][E_PLAYER_KEY_PRESSED] = KEY_RIGHT;
	}
	else if(keys & KEY_SPRINT)
	{
		switch(featureType)
		{
			case CHAR_FEATURE_SKIN:
				playerCreateCharacter[playerid][E_PLAYER_SKIN_SELECTED] = playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED];

			case CHAR_FEATURE_HAIR:
				playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED] = playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED];
			
			case CHAR_FEATURE_EYE:
				playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED] = playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED];
		}

		HideMenuConfigCharFeature(playerid);
	}
	else
		playerMenuCharacter[playerid][E_PLAYER_KEY_PRESSED] = 0;
}

/// <summary>
/// Atualiza uma caracter�stica espec�fica no menu de cria��o de personagens.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="featureType">Tipo da caracter�stica.</param>
/// <param name="featureValue">Valor da caracter�stica.</param>
/// <returns>True se a caracter�stica for alterada, False se for removida ou ocorrer algum erro.</returns>
static MenuCreationCharUpdateFeature(playerid, featureType, featureValue)
{
	switch(featureType)
	{
		case CHAR_FEATURE_SKIN:
		{
			SetPlayerSkin(playerid, featureValue);

			PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], ConvertIntToString(featureValue));
			PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);

			if(playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED] != FEATURE_TYPE_DEFAULT)
				MenuCreationCharUpdateFeature(playerid, CHAR_FEATURE_EYE, playerCreateCharacter[playerid][E_PLAYER_EYE_SELECTED]);
			
			if(playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED] != FEATURE_TYPE_DEFAULT)
				MenuCreationCharUpdateFeature(playerid, CHAR_FEATURE_HAIR, playerCreateCharacter[playerid][E_PLAYER_HAIR_SELECTED]);
		}

		case CHAR_FEATURE_EYE:
		{
			if(!featureValue)
			{
				RemovePlayerAttachedObject(playerid, CHAR_FEATURE_EYE_L_ATTACH_INDEX);
				RemovePlayerAttachedObject(playerid, CHAR_FEATURE_EYE_R_ATTACH_INDEX);

				PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], charFeatureEyes[0][E_FEATURE_EYES_NAME]);
				PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);

				playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED] = FEATURE_TYPE_DEFAULT;
				return false;
			}

			new skinid = GetPlayerCustomSkin(playerid);
				
			skinid = GetPlayerArrayEyesSkinIndex(skinid);

			if(skinid == FEATURE_TYPE_INVALID)
			{
				SendClientMessage(playerid, COLOR_RED, message_error_select_feature);
				return false;
			}

			new modelID = charFeatureEyes[featureValue][E_FEATURE_EYES_MODEL_ID];

			SetPlayerAttachedObject(playerid, CHAR_FEATURE_EYE_L_ATTACH_INDEX,
				modelID, attachCharsFeatureEyes[skinid][E_EYES_BONE], attachCharsFeatureEyes[skinid][E_EYES_OFFSETX],
				attachCharsFeatureEyes[skinid][E_EYES_OFFSETY], attachCharsFeatureEyes[skinid][E_EYES_OFFSETZ],
				attachCharsFeatureEyes[skinid][E_EYES_ROTX], attachCharsFeatureEyes[skinid][E_EYES_ROTY],
				attachCharsFeatureEyes[skinid][E_EYES_ROTZ], attachCharsFeatureEyes[skinid][E_EYES_SCALEX],
				attachCharsFeatureEyes[skinid][E_EYES_SCALEY], attachCharsFeatureEyes[skinid][E_EYES_SCALEZ],
				attachCharsFeatureEyes[skinid][E_EYES_MAT_COLOR1], attachCharsFeatureEyes[skinid][E_EYES_MAT_COLOR2]);

			SetPlayerAttachedObject(playerid, CHAR_FEATURE_EYE_R_ATTACH_INDEX,
				modelID, attachCharsFeatureEyes[skinid + 1][E_EYES_BONE], attachCharsFeatureEyes[skinid + 1][E_EYES_OFFSETX],
				attachCharsFeatureEyes[skinid + 1][E_EYES_OFFSETY], attachCharsFeatureEyes[skinid + 1][E_EYES_OFFSETZ],
				attachCharsFeatureEyes[skinid + 1][E_EYES_ROTX], attachCharsFeatureEyes[skinid + 1][E_EYES_ROTY],
				attachCharsFeatureEyes[skinid + 1][E_EYES_ROTZ], attachCharsFeatureEyes[skinid + 1][E_EYES_SCALEX],
				attachCharsFeatureEyes[skinid + 1][E_EYES_SCALEY], attachCharsFeatureEyes[skinid + 1][E_EYES_SCALEZ],
				attachCharsFeatureEyes[skinid + 1][E_EYES_MAT_COLOR1], attachCharsFeatureEyes[skinid + 1][E_EYES_MAT_COLOR2]);

			PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], charFeatureEyes[featureValue][E_FEATURE_EYES_NAME]);
			PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);
		}

		case CHAR_FEATURE_HAIR:
		{
			if(!featureValue)
			{
				RemovePlayerAttachedObject(playerid, CHAR_FEATURE_HAIR_ATTACH_INDEX);

				PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], charFeatureHairs[0][E_FEATURE_HAIR_NAME]);
				PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);

				playerMenuCharacter[playerid][E_PLAYER_FEATURE_VALUE_SELECTED] = FEATURE_TYPE_DEFAULT;
				return false;
			}

			new skinid = GetPlayerCustomSkin(playerid);
				
			skinid = GetPlayerArrayHairsSkinIndex(skinid);

			if(skinid == FEATURE_TYPE_INVALID)
			{
				SendClientMessage(playerid, COLOR_RED, message_error_select_feature);
				return false;
			}

			new modelID = charFeatureHairs[featureValue][E_FEATURE_HAIR_MODEL_ID];

			SetPlayerAttachedObject(playerid, CHAR_FEATURE_HAIR_ATTACH_INDEX,
					modelID, attachCharsFeatureHairs[featureValue][skinid][E_HAIR_BONE], attachCharsFeatureHairs[featureValue][skinid][E_HAIR_OFFSETX],
					attachCharsFeatureHairs[featureValue][skinid][E_HAIR_OFFSETY], attachCharsFeatureHairs[featureValue][skinid][E_HAIR_OFFSETZ],
					attachCharsFeatureHairs[featureValue][skinid][E_HAIR_ROTX], attachCharsFeatureHairs[featureValue][skinid][E_HAIR_ROTY],
					attachCharsFeatureHairs[featureValue][skinid][E_HAIR_ROTZ], attachCharsFeatureHairs[featureValue][skinid][E_HAIR_SCALEX],
					attachCharsFeatureHairs[featureValue][skinid][E_HAIR_SCALEY], attachCharsFeatureHairs[featureValue][skinid][E_HAIR_SCALEZ],
					0x000000FF);

			PlayerTextDrawSetString(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE], charFeatureHairs[featureValue][E_FEATURE_HAIR_NAME]);
			PlayerTextDrawShow(playerid, textCharCreationPrivate[playerid][E_SELECT_FEATURE_VALUE]);
		}
	}

	return true;
}

/*
 * COMMANDS
 ******************************************************************************
 */
/// <summary>
/// Comando tempor�rio para carregar e setar o jogador ao cen�rio.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores espec�ficos.</returns>
CMD:char(playerid)
{
	LoadSelectionCharacterScenario(playerid);
	return 1;
}

/// <summary>
/// Comando tempor�rio para sair da c�mera setada ao jogador que carregar o
/// cen�rio.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores espec�ficos.</returns>
CMD:actor(playerid)
{
	TogglePlayerControllable(playerid, true);
	SetCameraBehindPlayer(playerid);
	return 1;
}

/// <summary>
/// Comando tempor�rio para criar um ator. Imprime c�digo da aplica��o da
/// fun��o no console.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>N�o retorna valores espec�ficos.</returns>
CMD:c_actor(playerid)
{
	new Float:pos[4];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);

	new id = CreateActor(GetPlayerSkin(playerid), pos[0], pos[1], pos[2], pos[3]);

	printf("CreateActor(%d, %.4f, %.4f, %.4f, %.4f);", GetPlayerSkin(playerid), pos[0], pos[1], pos[2], pos[3]);

	SendClientMessageFormat(playerid, -1, "Ator criado. ID = %d", id);

	return 1;
}

/// <summary>
/// Comando tempor�rio para deletar um ator espec�fico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="params">Par�metros a serem utilizados: <id do ator>.</param>
/// <returns>N�o retorna valores espec�ficos.</returns>
CMD:d_actor(playerid, params[])
{
	if(isnull(params)) return 1;

	DestroyActor(strval(params));

	SendClientMessageFormat(playerid, -1, "Ator %d destru�do.", strval(params));

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
#define OnGameModeInit character_OnGameModeInit
#if defined character_OnGameModeInit
	forward character_OnGameModeInit();
#endif

/// <summary>
/// Hook da callback OnPlayerConnect.
/// </summary>
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect character_OnPlayerConnect
#if defined character_OnPlayerConnect
	forward character_OnPlayerConnect(playerid);
#endif

/// <summary>
/// Hook da callback OnPlayerUpdate.
/// </summary>
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate character_OnPlayerUpdate
#if defined character_OnPlayerUpdate
	forward character_OnPlayerUpdate(playerid);
#endif

/// <summary>
/// Hook da callback OnPlayerClickTextDraw.
/// </summary>
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw character_OnPlayerClickTextDraw
#if defined character_OnPlayerClickTextDraw
	forward character_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

/// <summary>
/// Hook da callback OnPlayerClickPlayerTextDraw.
/// </summary>
#if defined ALS_OnPlayerClickPlayerTextDraw
	#undef OnPlayerClickPlayerTextDraw
#else
	#define ALS_OnPlayerClickPlayerTextDraw
#endif
#define OnPlayerClickPlayerTextDraw chr_OnPlayerClickPlayerTextDraw
#if defined chr_OnPlayerClickPlayerTextDraw
	forward chr_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
#endif

/// <summary>
/// Hook da callback OnDialogResponse.
/// </summary>
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse character_OnDialogResponse
#if defined character_OnDialogResponse
	forward character_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

/// <summary>
/// Hook da callback OnPlayerHideCursor.
/// </summary>
#if defined _ALS_OnPlayerHideCursor
	#undef OnPlayerHideCursor
#else
	#define _ALS_OnPlayerHideCursor
#endif
#define OnPlayerHideCursor character_OnPlayerHideCursor
#if defined character_OnPlayerHideCursor
	forward character_OnPlayerHideCursor(playerid, hovercolor, moduleCalled);
#endif