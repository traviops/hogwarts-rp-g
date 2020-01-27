#include <a_samp>
#include <zcmd>
#include <sscanf2>
/*----------------------------------------------------------------------------*/
/*
	{MACROS}
*/
stock m_string[128];

#define SendClientMessageEx(%0,%1,%2,%3) \
		format(m_string, sizeof(m_string),%2,%3) && SendClientMessage(%0, %1, m_string)

#define call:%1(%2) \
		forward %1(%2); \
		public %1(%2)
/*----------------------------------------------------------------------------*/
/*
	{ENUMERATOR}
*/
enum
{
	ANIM_SIDE_MENU_SHOW = 0,
 	ANIM_SIDE_MENU_HIDE = 1,
	
	ANIM_SIDE_MENU_SHOWED = 0,
	ANIM_SIDE_MENU_HIDDEN = 1
}
//---------------------------------------------
enum E_GLOBAL_TEXT_ACCOUNT
{
	Text:e_G_BACKGROUND[10],//10-29 REMOVED - Menu Options
	
	Text:e_G_PREMIUM[2],

	Text:e_G_BUTTON[7]
}

enum E_PLAYER_TEXT_ACCOUNT
{
    PlayerText:e_P_BUTTON_MENU,
    
    PlayerText:e_P_MENU_OPTIONS[20],
    
	PlayerText:e_P_PREMIUM[2],
	PlayerText:e_P_REGULAR,
    
    PlayerText:e_P_BUTTON_OPTIONS[7],
    
	PlayerText:e_P_OPTION_NAME,
	
	PlayerText:e_P_USER_PREMIUM_NAME,
	PlayerText:e_P_USER_REGULAR_NAME,
	
	PlayerText:e_P_SELECTOR
}
//---------------------------------------------
enum E_ACC_ATTRIBUTES
{
	bool:e_ACC_OPENED,
	
	e_ACC_OPTION_SELECTED,

	e_ACC_SIDE_MENU_STATE,
	e_ACC_SIDE_MENU_TIMERID,
	bool:e_ACC_SIDE_MENU_ANIMATING,
	Float:e_ACC_SIDE_MENU_SIZE_ADDED,
	Float:e_ACC_SIDE_MENU_SIZE_REMOVED
}

enum E_ACC_PLAYER
{
	bool:e_ACC_IS_PREMIUM
}

enum E_OPTIONS_DATA
{
	e_OPTION_NAME[14],
	Float:e_OPTION_POS
}
/*----------------------------------------------------------------------------*/
/*
	{VARIABELS}
*/
static
	i,
	//player_size,

	cursorState[MAX_PLAYERS],
	myName[MAX_PLAYERS][MAX_PLAYER_NAME],

	Text:accountGlobalText[E_GLOBAL_TEXT_ACCOUNT],
	PlayerText:accountPlayerText[MAX_PLAYERS][E_PLAYER_TEXT_ACCOUNT],

	accountAttributes[MAX_PLAYERS][E_ACC_ATTRIBUTES],

	accountPlayer[MAX_PLAYERS][E_ACC_PLAYER],
/*----------------------------------------------------------------------------*/
/*
	{ARRAY}
*/
optionsText[7][E_OPTIONS_DATA] = {
	{"STATUS", 			210.366195},
	{"EMAIL", 			223.199447},
	{"CONQUISTAS", 		236.616073},
	{"CONFIGURAÇÕES", 	250.032714},
	{"SEGURANÇA", 		263.449432},
	{"BUG", 			276.866302},
	{"PREMIUM", 		290.283111}
};
/*----------------------------------------------------------------------------*/
/*
	<HOOKS>
*/
my_SelectTextDraw(playerid, hovercolor)
{
	SelectTextDraw(playerid, hovercolor);
	cursorState[playerid] = true;
}
#if defined _ALS_SelectTextDraw
	#undef SelectTextDraw
#else
	#define _ALS_SelectTextDraw
#endif
#define SelectTextDraw my_SelectTextDraw

my_CancelSelectTextDraw(playerid)
{
	cursorState[playerid] = false;
    CancelSelectTextDraw(playerid);
}
#if defined _ALS_CancelSelectTextDraw
	#undef CancelSelectTextDraw
#else
	#define _ALS_CancelSelectTextDraw
#endif
#define CancelSelectTextDraw my_CancelSelectTextDraw
/*----------------------------------------------------------------------------*/
public OnFilterScriptInit()
{
    ACC_CreateGlobalTextDraws();
    
	return 1;
}

public OnPlayerConnect(playerid)
{
    ACC_CreatePlayerTextDraws(playerid);
    
    GetPlayerName(playerid, myName[playerid], MAX_PLAYER_NAME);

    accountPlayer[playerid][e_ACC_IS_PREMIUM] = false;
    
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW && cursorState[playerid])
	{
	    if(MenuAccountIsOpened(playerid)) CloseMenuAccount(playerid);
	}
	/*
		MENU ACCOUNT BUTTONS
							*/
	/*
	    Close MENU */
	if(clickedid == accountGlobalText[e_G_BUTTON][0])
	{
		CloseMenuAccount(playerid);
	}
	/*
	    Open/Close SIDE MENU ACCOUNT */
	if(clickedid == accountGlobalText[e_G_BACKGROUND][7])
	{
	    if(accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING]) return 1;
	    
	    if(accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] == ANIM_SIDE_MENU_HIDDEN)
	    {
	        OpenSideMenuOfAccount(playerid);
		}
		else if(accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] == ANIM_SIDE_MENU_SHOWED)
		{
		    CloseSideMenuOfAccount(playerid);
		}
	}

	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    /*
		INVENTORY BUTTONS
							*/
							
	/*if(playertextid == )
	{
	}*/
	
	/*
		PREVIEW ITEMS BUTTONS
								*/
    for(i = 0; i < 7; i++)
    {
		if(playertextid == accountPlayerText[playerid][e_P_BUTTON_OPTIONS][i])
		{
		    SelectThisOption(playerid, i);
            break;
		}
	}

	return 1;
}

SelectThisOption(playerid, optionid)//parei aqui (06/11/15 - 21:30): Tudo ok. Menu finalizado, resta apenas agora colocar o conteúdo em cada item.
{
    ForceCloseSideMenuOfAccount(playerid);
    
    accountAttributes[playerid][e_ACC_OPTION_SELECTED] = optionid;
    
    PlayerTextDrawSetString(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], ConvertToGameText(optionsText[optionid][e_OPTION_NAME]));
    PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_OPTION_NAME]);
    
    if(accountPlayerText[playerid][e_P_SELECTOR] != PlayerText:INVALID_TEXT_DRAW) PlayerTextDrawDestroy(playerid, accountPlayerText[playerid][e_P_SELECTOR]);
    
    accountPlayerText[playerid][e_P_SELECTOR] = CreatePlayerTextDraw(playerid, 210.159362, optionsText[optionid][e_OPTION_POS], "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 2.088814, (1 <= optionid <= 5 ? (14.083333) : (13.500000)) );
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_SELECTOR], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], -2017574401);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_SELECTOR], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
    /*accountPlayerText[playerid][e_P_SELECTOR] = CreatePlayerTextDraw(playerid, 210.629943, optionsText[optionid][e_OPTION_POS], "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 2.088814, 14.083333);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_SELECTOR], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], -2017574401);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_SELECTOR], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);*/
}
/*----------------------------------------------------------------------------*/
/*
	{COMMANDS}
*/
CMD:acc(playerid)
{
    OpenMenuAccount(playerid);
    
    return 1;
}
CMD:close(playerid)
{
    CloseMenuAccount(playerid);

    return 1;
}
CMD:premium(playerid) return accountPlayer[playerid][e_ACC_IS_PREMIUM] = true;
CMD:r(playerid, params[])
{
    TextDrawHideForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][strval(params)]);

    return 1;
}
CMD:c(playerid, params[])
{
    TextDrawShowForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][strval(params)]);

    return 1;
}
CMD:a(playerid)
{
	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU]);

	return 1;
}
CMD:teste(playerid)
{
    //for(i = 10; i < 30; i++) TextDrawShowForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][i]);
    for(i = 0; i < 20; i++) PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][i]);
    
    return 1;
}
/*----------------------------------------------------------------------------*/
/*
	{MENU ACCOUNT FUNCTIONS}
*/
OpenMenuAccount(playerid)
{
    ConfigureMenuAccount(playerid);
    
    SelectTextDraw(playerid, 0xDDDDDDAA);
    
	for(i = 0; i < 10; i++) TextDrawShowForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][i]);
	
	TextDrawShowForPlayer(playerid, accountGlobalText[e_G_BUTTON][0]);
	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_OPTION_NAME]);
	
	accountAttributes[playerid][e_ACC_OPENED] = true;
}
CloseMenuAccount(playerid)
{
    CancelSelectTextDraw(playerid);
    
    ForceCloseSideMenuOfAccount(playerid);
    
    for(i = 0; i < 10; i++) TextDrawHideForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][i]);

	TextDrawHideForPlayer(playerid, accountGlobalText[e_G_BUTTON][0]);
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_OPTION_NAME]);
	
	accountAttributes[playerid][e_ACC_OPENED] = false;
}
MenuAccountIsOpened(playerid) return accountAttributes[playerid][e_ACC_OPENED];
ConfigureMenuAccount(playerid)
{
    accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING] = false;
    
    accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] = ANIM_SIDE_MENU_HIDDEN;

    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_ADDED] = 0.0;
    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_REMOVED] = 61.0;
}
/*UpdateMenuAccount(playerid)
{
}*/
//--------------------
OpenSideMenuOfAccount(playerid)
{
    accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING] = true;

    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_ADDED] = 0.0;

	accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID] = SetTimerEx("animateSideMenu", 40, false, "iif", playerid, ANIM_SIDE_MENU_SHOW, 0.0);
}
CloseSideMenuOfAccount(playerid)
{
    accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING] = true;

    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_REMOVED] = 61.0;
    
    //for(i = 10; i < 30; i++) TextDrawHideForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][i]);//10-29
    for(i = 0; i < 20; i++)
	{
	    if(i < 2) PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_PREMIUM][i]);
	    if(i < 7) PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][i]);
		PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][i]);
    }
    PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME]);
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME]);
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_REGULAR]);
	
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_SELECTOR]);

	accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID] = SetTimerEx("animateSideMenu", 40, false, "iif", playerid, ANIM_SIDE_MENU_HIDE, 61.0);
}
ForceCloseSideMenuOfAccount(playerid)
{
	KillTimer(accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID]);
	
	accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING] = false;
    accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] = ANIM_SIDE_MENU_HIDDEN;
    
    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_ADDED] = 0.0;
    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_REMOVED] = 61.0;
    
    for(i = 0; i < 20; i++)
	{
	    if(i < 2) PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_PREMIUM][i]);
	    if(i < 7) PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][i]);
		PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][i]);
    }
    PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME]);
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME]);
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_REGULAR]);
	
	PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_SELECTOR]);
    
    PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0.0, 136.109939);
    PlayerTextDrawHide(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU]);
}
/*
	{COMPLEMENTS}
*/
ConvertToGameText(in[])
{
    new string[128];
    
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
/*----------------------------------------------------------------------------*/
call:animateSideMenu(playerid, type, Float:size)
{
	if(type == ANIM_SIDE_MENU_SHOW)
	{
		if(accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_ADDED] >= 62)
		{
		    PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 61.0, 136.109939);//61.000000
	    	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU]);

		    accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID] = SetTimerEx("animateSideMenu_ShowOptions", 300, false, "ii", playerid, 0);
		    //accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] = ANIM_SIDE_MENU_SHOWED;
		    return;
		}

	    PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], size, 136.109939);//61.000000
	    PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU]);

	    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_ADDED] += 3.0;

	    accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID] = SetTimerEx("animateSideMenu", 40, false, "iif", playerid, type, accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_ADDED]);
	}
	else
	{
		if(accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_REMOVED] <= -1)
		{
		    PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0.0, 136.109939);//61.000000
	    	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU]);
	    
		    accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING] = false;
		    
		    accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] = ANIM_SIDE_MENU_HIDDEN;
		    return;
		}

	    PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], size, 136.109939);//61.000000
	    PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU]);

	    accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_REMOVED] -= 3.0;

	    accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID] = SetTimerEx("animateSideMenu", 40, false, "iif", playerid, type, accountAttributes[playerid][e_ACC_SIDE_MENU_SIZE_REMOVED]);
	}
}
call:animateSideMenu_ShowOptions(playerid, id)//parei aqui (20/10/15 - 04:39): Falta dar SetString nas TD abaixo com o nome do player e o esquema de '...' das TextDraws.
{
	if(id >= 14)
	{
	    if(accountPlayer[playerid][e_ACC_IS_PREMIUM])
	    {
	        //PlayerTextDrawSetString(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME]);
	        
	    	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_PREMIUM][0]);
			PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_PREMIUM][1]);

			PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME]);
		}
		else
		{
		    //PlayerTextDrawSetString(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME]);

			PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME]);
		    PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_REGULAR]);
		}
		PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_SELECTOR]);
		
	    accountAttributes[playerid][e_ACC_SIDE_MENU_ANIMATING] = false;
	    accountAttributes[playerid][e_ACC_SIDE_MENU_STATE] = ANIM_SIDE_MENU_SHOWED;
	    return;
	}
	/*TextDrawShowForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][id]);//10-29
	TextDrawShowForPlayer(playerid, accountGlobalText[e_G_BACKGROUND][id+1]);*/
	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][id/2]);//1-6
	
	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][id]);
	PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][id+1]);

	//PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][id+13]);14-19 - Faltou as barrinhas..
    if(id != 12) PlayerTextDrawShow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][id/2 + 14]);
    
	id += 2;
	
	accountAttributes[playerid][e_ACC_SIDE_MENU_TIMERID] = SetTimerEx("animateSideMenu_ShowOptions", 300, false, "ii", playerid, id);
}
/*----------------------------------------------------------------------------*/
ACC_CreateGlobalTextDraws()
{
    accountGlobalText[e_G_BACKGROUND][0] = TextDrawCreate(210.470672, 159.666641, "box");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][0], 0.000000, 20.258808);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][0], 429.000000, 0.000000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][0], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][0], -1);
	TextDrawUseBox(accountGlobalText[e_G_BACKGROUND][0], 1);
	TextDrawBoxColor(accountGlobalText[e_G_BACKGROUND][0], 102);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][0], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][0], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][0], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][0], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][0], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][0], 0);

	accountGlobalText[e_G_BACKGROUND][1] = TextDrawCreate(210.159271, 159.033523, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][1], 219.029983, 17.000000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][1], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][1], -2017574401);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][1], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][1], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][1], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][1], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][1], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][1], 0);

	accountGlobalText[e_G_BACKGROUND][2] = TextDrawCreate(319.647003, 159.666687, "MINHA_CONTA");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][2], 0.400000, 1.600000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][2], 2);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][2], 589441023);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][2], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][2], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][2], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][2], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][2], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][2], 0);

	accountGlobalText[e_G_BACKGROUND][3] = TextDrawCreate(210.470474, 177.166717, "Veja suas estatisticas e configure sua conta.");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][3], 0.209882, 0.876666);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][3], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][3], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][3], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][3], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][3], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][3], 2);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][3], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][3], 0);

	accountGlobalText[e_G_BACKGROUND][4] = TextDrawCreate(209.911743, 185.333404, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][4], 219.000000, 0.720000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][4], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][4], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][4], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][4], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][4], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][4], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][4], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][4], 0);

	accountGlobalText[e_G_BACKGROUND][5] = TextDrawCreate(209.911743, 188.250061, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][5], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][5], 219.309829, 154.249862);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][5], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][5], 286463487);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][5], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][5], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][5], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][5], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][5], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][5], 0);

	accountGlobalText[e_G_BACKGROUND][6] = TextDrawCreate(209.911743, 188.250061, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][6], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][6], 219.299835, 20.000000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][6], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][6], 589441023);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][6], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][6], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][6], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][6], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][6], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][6], 0);

	accountGlobalText[e_G_BACKGROUND][7] = TextDrawCreate(213.235351, 192.916687, "LD_SPAC:white");//Selector MENU
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][7], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][7], 11.000000, 11.779994);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][7], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][7], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][7], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][7], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][7], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][7], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][7], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][7], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BACKGROUND][7], true);

	accountGlobalText[e_G_BACKGROUND][8] = TextDrawCreate(211.353057, 195.250000, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][8], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][8], 15.000000, 2.000000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][8], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][8], 589441023);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][8], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][8], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][8], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][8], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][8], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][8], 0);

	accountGlobalText[e_G_BACKGROUND][9] = TextDrawCreate(211.353057, 199.916702, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][9], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][9], 15.000000, 2.000000);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][9], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][9], 589441023);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][9], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][9], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][9], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][9], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][9], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][9], 0);
	//--------------------------------------------------------------------------

	/*accountGlobalText[e_G_BACKGROUND][10] = TextDrawCreate(212.923721, 211.416702, "hud:radar_gangB");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][10], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][10], 7.720016, 9.860013);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][10], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][10], 255);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][10], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][10], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][10], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][10], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][10], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][10], 0);

	accountGlobalText[e_G_BACKGROUND][11] = TextDrawCreate(221.294113, 210.416671, "STATUS");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][11], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][11], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][11], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][11], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][11], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][11], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][11], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][11], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][11], 0);

	accountGlobalText[e_G_BACKGROUND][12] = TextDrawCreate(212.923721, 224.833297, "hud:radar_police");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][12], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][12], 7.720016, 9.860013);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][12], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][12], 255);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][12], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][12], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][12], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][12], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][12], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][12], 0);

	accountGlobalText[e_G_BACKGROUND][13] = TextDrawCreate(221.294113, 223.833343, "EMAIL");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][13], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][13], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][13], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][13], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][13], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][13], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][13], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][13], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][13], 0);

	accountGlobalText[e_G_BACKGROUND][14] = TextDrawCreate(212.923721, 238.249908, "hud:radar_race");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][14], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][14], 7.720016, 9.860013);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][14], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][14], 255);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][14], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][14], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][14], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][14], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][14], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][14], 0);

	accountGlobalText[e_G_BACKGROUND][15] = TextDrawCreate(221.294113, 237.249954, "CONQUIS.");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][15], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][15], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][15], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][15], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][15], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][15], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][15], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][15], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][15], 0);

	accountGlobalText[e_G_BACKGROUND][16] = TextDrawCreate(212.923721, 252.249862, "hud:radar_modGarage");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][16], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][16], 7.720016, 9.860013);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][16], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][16], 255);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][16], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][16], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][16], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][16], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][16], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][16], 0);

	accountGlobalText[e_G_BACKGROUND][17] = TextDrawCreate(221.294113, 250.666580, "CONFIG.");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][17], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][17], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][17], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][17], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][17], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][17], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][17], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][17], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][17], 0);

	accountGlobalText[e_G_BACKGROUND][18] = TextDrawCreate(207.517654, 260.683319, "");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][18], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][18], 18.980016, 19.416652);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][18], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][18], 255);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][18], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][18], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][18], 0);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][18], 5);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][18], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][18], 0);
	TextDrawSetPreviewModel(accountGlobalText[e_G_BACKGROUND][18], 19804);
	TextDrawSetPreviewRot(accountGlobalText[e_G_BACKGROUND][18], 0.000000, 0.000000, 0.000000, 1.000000);

	accountGlobalText[e_G_BACKGROUND][19] = TextDrawCreate(221.294113, 264.083374, "SEGURAN.");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][19], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][19], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][19], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][19], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][19], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][19], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][19], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][19], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][19], 0);

	accountGlobalText[e_G_BACKGROUND][20] = TextDrawCreate(212.923736, 288.599975, "hud:radar_gangB");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][20], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][20], 7.880019, -9.219980);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][20], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][20], 255);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][20], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][20], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][20], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][20], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][20], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][20], 0);

	accountGlobalText[e_G_BACKGROUND][21] = TextDrawCreate(221.294113, 277.500183, "BUG");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][21], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][21], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][21], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][21], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][21], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][21], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][21], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][21], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][21], 0);

	accountGlobalText[e_G_BACKGROUND][22] = TextDrawCreate(212.923721, 292.500061, "hud:radar_cash");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][22], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][22], 7.720016, 9.860013);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][22], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][22], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][22], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][22], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][22], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][22], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][22], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][22], 0);

	accountGlobalText[e_G_BACKGROUND][23] = TextDrawCreate(221.294113, 290.916931, "PREMIUM");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][23], 0.283293, 1.279165);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][23], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][23], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][23], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][23], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][23], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][23], 1);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][23], 1);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][23], 0);

	accountGlobalText[e_G_BACKGROUND][24] = TextDrawCreate(212.294143, 223.250045, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][24], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][24], 56.000000, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][24], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][24], -111);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][24], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][24], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][24], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][24], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][24], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][24], 0);

	accountGlobalText[e_G_BACKGROUND][25] = TextDrawCreate(212.294143, 236.316741, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][25], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][25], 56.000000, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][25], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][25], -111);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][25], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][25], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][25], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][25], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][25], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][25], 0);

	accountGlobalText[e_G_BACKGROUND][26] = TextDrawCreate(212.294143, 249.733367, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][26], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][26], 56.000000, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][26], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][26], -111);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][26], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][26], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][26], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][26], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][26], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][26], 0);

	accountGlobalText[e_G_BACKGROUND][27] = TextDrawCreate(212.294143, 263.150085, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][27], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][27], 56.000000, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][27], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][27], -111);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][27], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][27], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][27], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][27], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][27], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][27], 0);

	accountGlobalText[e_G_BACKGROUND][28] = TextDrawCreate(212.294143, 276.566802, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][28], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][28], 56.000000, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][28], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][28], -111);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][28], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][28], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][28], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][28], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][28], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][28], 0);

	accountGlobalText[e_G_BACKGROUND][29] = TextDrawCreate(212.294143, 289.983520, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BACKGROUND][29], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BACKGROUND][29], 56.000000, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_BACKGROUND][29], 1);
	TextDrawColor(accountGlobalText[e_G_BACKGROUND][29], -111);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][29], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BACKGROUND][29], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BACKGROUND][29], 255);
	TextDrawFont(accountGlobalText[e_G_BACKGROUND][29], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BACKGROUND][29], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BACKGROUND][29], 0);*/

    /*
	    Text:PREMIUM
	*/
	/*accountGlobalText[e_G_PREMIUM][0] = TextDrawCreate(211.352951, 333.500030, "LD_CHAT:thumbup");//VERIFICAÇÃO PREMIUM
	TextDrawLetterSize(accountGlobalText[e_G_PREMIUM][0], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_PREMIUM][0], 8.588212, 9.499999);
	TextDrawAlignment(accountGlobalText[e_G_PREMIUM][0], 1);
	TextDrawColor(accountGlobalText[e_G_PREMIUM][0], -1);
	TextDrawSetShadow(accountGlobalText[e_G_PREMIUM][0], 0);
	TextDrawSetOutline(accountGlobalText[e_G_PREMIUM][0], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_PREMIUM][0], 255);
	TextDrawFont(accountGlobalText[e_G_PREMIUM][0], 4);
	TextDrawSetProportional(accountGlobalText[e_G_PREMIUM][0], 1);
	TextDrawSetShadow(accountGlobalText[e_G_PREMIUM][0], 0);
	
	accountGlobalText[e_G_PREMIUM][1] = TextDrawCreate(220.764678, 341.316711, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_PREMIUM][1], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_PREMIUM][1], 48.470581, 0.690001);
	TextDrawAlignment(accountGlobalText[e_G_PREMIUM][1], 1);
	TextDrawColor(accountGlobalText[e_G_PREMIUM][1], -111);
	TextDrawSetShadow(accountGlobalText[e_G_PREMIUM][1], 0);
	TextDrawSetOutline(accountGlobalText[e_G_PREMIUM][1], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_PREMIUM][1], 255);
	TextDrawFont(accountGlobalText[e_G_PREMIUM][1], 4);
	TextDrawSetProportional(accountGlobalText[e_G_PREMIUM][1], 0);
	TextDrawSetShadow(accountGlobalText[e_G_PREMIUM][1], 0);*/

	/*
	    Text:BUTTONS
	*/
	accountGlobalText[e_G_BUTTON][0] = TextDrawCreate(414.352355, 159.950012, "LD_BEAT:cross");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][0], 14.235260, 15.333327);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][0], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][0], -1);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][0], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][0], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][0], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][0], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][0], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][0], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][0], true);
	
	/*accountGlobalText[e_G_BUTTON][1] = TextDrawCreate(210.159423, 223.783035, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][1], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][1], 58.559421, 12.916666);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][1], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][1], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][1], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][1], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][1], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][1], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][1], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][1], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][1], true);

	accountGlobalText[e_G_BUTTON][2] = TextDrawCreate(210.159423, 237.199615, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][2], 58.559421, 12.916666);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][2], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][2], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][2], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][2], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][2], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][2], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][2], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][2], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][2], true);

	accountGlobalText[e_G_BUTTON][3] = TextDrawCreate(210.159423, 250.616210, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][3], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][3], 58.559421, 12.916666);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][3], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][3], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][3], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][3], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][3], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][3], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][3], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][3], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][3], true);

	accountGlobalText[e_G_BUTTON][4] = TextDrawCreate(210.159423, 264.032989, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][4], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][4], 58.559421, 12.916666);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][4], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][4], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][4], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][4], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][4], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][4], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][4], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][4], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][4], true);

	accountGlobalText[e_G_BUTTON][5] = TextDrawCreate(210.159423, 277.449645, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][5], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][5], 58.559421, 12.916666);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][5], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][5], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][5], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][5], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][5], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][5], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][5], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][5], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][5], true);

	accountGlobalText[e_G_BUTTON][6] = TextDrawCreate(210.159423, 290.866424, "LD_SPAC:white");
	TextDrawLetterSize(accountGlobalText[e_G_BUTTON][6], 0.000000, 0.000000);
	TextDrawTextSize(accountGlobalText[e_G_BUTTON][6], 58.559421, 12.916666);
	TextDrawAlignment(accountGlobalText[e_G_BUTTON][6], 1);
	TextDrawColor(accountGlobalText[e_G_BUTTON][6], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][6], 0);
	TextDrawSetOutline(accountGlobalText[e_G_BUTTON][6], 0);
	TextDrawBackgroundColor(accountGlobalText[e_G_BUTTON][6], 255);
	TextDrawFont(accountGlobalText[e_G_BUTTON][6], 4);
	TextDrawSetProportional(accountGlobalText[e_G_BUTTON][6], 0);
	TextDrawSetShadow(accountGlobalText[e_G_BUTTON][6], 0);
	TextDrawSetSelectable(accountGlobalText[e_G_BUTTON][6], true);*/
}
ACC_CreatePlayerTextDraws(playerid)
{
    accountPlayerText[playerid][e_P_BUTTON_MENU] = CreatePlayerTextDraw(playerid, 209.911697, 206.333419, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 61.000000, 136.109939);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 589441023);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_MENU], 0);
	
	accountPlayerText[playerid][e_P_MENU_OPTIONS][0] = CreatePlayerTextDraw(playerid, 212.923721, 211.416702, "hud:radar_gangB");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 7.720016, 9.860013);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 255);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][0], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][1] = CreatePlayerTextDraw(playerid, 221.294113, 210.416671, "STATUS");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][1], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][2] = CreatePlayerTextDraw(playerid, 212.923721, 224.833297, "hud:radar_police");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 7.720016, 9.860013);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 255);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][2], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][3] = CreatePlayerTextDraw(playerid, 221.294113, 223.833343, "EMAIL");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][3], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][4] = CreatePlayerTextDraw(playerid, 212.923721, 238.249908, "hud:radar_race");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 7.720016, 9.860013);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 255);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][4], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][5] = CreatePlayerTextDraw(playerid, 221.294113, 237.249954, "CONQUIS.");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][5], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][6] = CreatePlayerTextDraw(playerid, 212.923721, 252.249862, "hud:radar_modGarage");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 7.720016, 9.860013);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 255);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][6], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][7] = CreatePlayerTextDraw(playerid, 221.294113, 250.666580, "CONFIG.");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][7], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][8] = CreatePlayerTextDraw(playerid, 207.517654, 260.683319, "");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 18.980016, 19.416652);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 255);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 5);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 19804);
	PlayerTextDrawSetPreviewRot(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][8], 0.000000, 0.000000, 0.000000, 1.000000);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][9] = CreatePlayerTextDraw(playerid, 221.294113, 264.083374, "SEGURAN.");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][9], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][10] = CreatePlayerTextDraw(playerid, 212.923736, 288.599975, "hud:radar_gangB");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 7.880019, -9.219980);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 255);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][10], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][11] = CreatePlayerTextDraw(playerid, 221.294113, 277.500183, "BUG");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][11], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][12] = CreatePlayerTextDraw(playerid, 212.923721, 292.500061, "hud:radar_cash");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 7.720016, 9.860013);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][12], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][13] = CreatePlayerTextDraw(playerid, 221.294113, 290.916931, "PREMIUM");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 0.283293, 1.279165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 1);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][13], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][14] = CreatePlayerTextDraw(playerid, 212.294143, 223.250045, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 56.000000, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][14], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][15] = CreatePlayerTextDraw(playerid, 212.294143, 236.316741, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 56.000000, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][15], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][16] = CreatePlayerTextDraw(playerid, 212.294143, 249.733367, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 56.000000, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][16], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][17] = CreatePlayerTextDraw(playerid, 212.294143, 263.150085, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 56.000000, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][17], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][18] = CreatePlayerTextDraw(playerid, 212.294143, 276.566802, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 56.000000, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][18], 0);

	accountPlayerText[playerid][e_P_MENU_OPTIONS][19] = CreatePlayerTextDraw(playerid, 212.294143, 289.983520, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 56.000000, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_MENU_OPTIONS][19], 0);
	
	//----------------------------
	/*accountPlayerText[playerid][e_P_PREMIUM][0] = CreatePlayerTextDraw(playerid, 211.352951, 333.500030, "LD_CHAT:thumbup");//VERIFICAÇÃO PREMIUM
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 8.588212, 9.499999);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0);

	accountPlayerText[playerid][e_P_PREMIUM][1] = CreatePlayerTextDraw(playerid, 220.764678, 341.316711, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 48.470581, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);*/
	
	accountPlayerText[playerid][e_P_PREMIUM][0] = CreatePlayerTextDraw(playerid, 211.352951, 332.333343, "LD_CHAT:thumbup");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 8.588212, 9.499999);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][0], 0);
	
	accountPlayerText[playerid][e_P_PREMIUM][1] = CreatePlayerTextDraw(playerid, 220.764831, 340.150024, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 48.470581, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_PREMIUM][1], 0);

	accountPlayerText[playerid][e_P_REGULAR] = CreatePlayerTextDraw(playerid, 211.823745, 340.150024, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_REGULAR], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_REGULAR], 56.941173, 0.690001);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_REGULAR], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_REGULAR], -111);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_REGULAR], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_REGULAR], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_REGULAR], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_REGULAR], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_REGULAR], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_REGULAR], 0);

	//----------------------------
	/*accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0] = CreatePlayerTextDraw(playerid, 210.159423, 209.783096, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 58.559421, 13.500000);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1] = CreatePlayerTextDraw(playerid, 210.159423, 223.783035, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 58.559421, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2] = CreatePlayerTextDraw(playerid, 210.159423, 237.199615, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 58.559421, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3] = CreatePlayerTextDraw(playerid, 210.159423, 250.616210, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 58.559421, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4] = CreatePlayerTextDraw(playerid, 210.159423, 264.032989, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 58.559421, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5] = CreatePlayerTextDraw(playerid, 210.159423, 277.449645, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 58.559421, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6] = CreatePlayerTextDraw(playerid, 210.159423, 290.866424, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 58.559421, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], true);*/
	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0] = CreatePlayerTextDraw(playerid, 210.159423, 210.366455, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][0], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1] = CreatePlayerTextDraw(playerid, 210.159423, 223.783020, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][1], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2] = CreatePlayerTextDraw(playerid, 210.159423, 237.199676, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][2], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3] = CreatePlayerTextDraw(playerid, 210.159423, 250.616317, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][3], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4] = CreatePlayerTextDraw(playerid, 210.159423, 264.033020, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][4], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5] = CreatePlayerTextDraw(playerid, 210.159423, 277.449829, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][5], true);

	accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6] = CreatePlayerTextDraw(playerid, 210.159423, 290.866607, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 60.441776, 12.916666);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], 0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_BUTTON_OPTIONS][6], true);
	//--------------------------------------------------------------------------------------------------------------

	accountPlayerText[playerid][e_P_OPTION_NAME] = CreatePlayerTextDraw(playerid, 226.564926, 188.550003, "STATUS");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 0.368939, 1.909165);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 2);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_OPTION_NAME], 0);

	/*accountPlayerText[playerid][e_P_USER_NAME] = CreatePlayerTextDraw(playerid, 220.823745, 332.333251, "BRUNO_TRAV...");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_USER_NAME], 0.174584, 1.080832);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_USER_NAME], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_USER_NAME], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_USER_NAME], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_USER_NAME], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_USER_NAME], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_USER_NAME], 2);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_USER_NAME], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_USER_NAME], 0);*/
    accountPlayerText[playerid][e_P_USER_PREMIUM_NAME] = CreatePlayerTextDraw(playerid, 220.823745, 331.166564, "BRUNO_TRAV...");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 0.174584, 1.080832);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 2);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 0);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], 270.0, 10.0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_USER_PREMIUM_NAME], true);
	
	accountPlayerText[playerid][e_P_USER_REGULAR_NAME] = CreatePlayerTextDraw(playerid, 211.882675, 331.166564, "BRUNO_TRAVI_T...");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 0.174584, 1.080832);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], -1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 2);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 1);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 0);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], 270.0, 10.0);
	PlayerTextDrawSetSelectable(playerid, accountPlayerText[playerid][e_P_USER_REGULAR_NAME], true);

    accountPlayerText[playerid][e_P_SELECTOR] = CreatePlayerTextDraw(playerid, 210.159362, 210.366195, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 2.088814, 13.500000);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_SELECTOR], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], -2017574401);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_SELECTOR], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	/*accountPlayerText[playerid][e_P_SELECTOR] = CreatePlayerTextDraw(playerid, 210.629943, 209.783096, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, accountPlayerText[playerid][e_P_SELECTOR], 2.088814, 14.083333);
	PlayerTextDrawAlignment(playerid, accountPlayerText[playerid][e_P_SELECTOR], 1);
	PlayerTextDrawColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], -2017574401);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetOutline(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawBackgroundColor(playerid, accountPlayerText[playerid][e_P_SELECTOR], 255);
	PlayerTextDrawFont(playerid, accountPlayerText[playerid][e_P_SELECTOR], 4);
	PlayerTextDrawSetProportional(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);
	PlayerTextDrawSetShadow(playerid, accountPlayerText[playerid][e_P_SELECTOR], 0);*/
}
