/*
	|
	 *
	 * DEFINES
	 *
	|
	 *
	 * VARIABLES
	 *
	|
	 *
	 * STATEMENTS
	 *
	|
	 *
	 * HOOK NATIVE CALLBACKS
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
	 * INC FUNCTIONS
	 *
	|
*/
/*
 * INCLUDES
 *****************************************************************************
 */

/*
 * DEFINES
 *****************************************************************************
 */
//static stock stringF[256];

#if !defined call
	#define call:%0(%1) forward %0(%1); public %0(%1)
#endif

#if !defined SendClientMessageEx
	#define SendClientMessageEx(%0,%1,%2,%3) format(stringF, sizeof(stringF),%2,%3) && SendClientMessage(%0, %1, stringF)//ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[]) 
#endif

const

	bool:FADE_OUT 	= false,
	bool:FADE_IN 	= true;
/*
 * VARIABLES
 *****************************************************************************
 */
static

	PlayerText:playerTextFade[MAX_PLAYERS],

	timerFade[MAX_PLAYERS],
	fadeAA[MAX_PLAYERS];
/*
 * HOOK NATIVE CALLBACKS
 *****************************************************************************
 */
public OnFilterScriptInit()
{
	#if defined hogFader_OnFilterScriptInit
        hogFader_OnFilterScriptInit();
    #endif

	print("    > [inc] hogFader.inc loaded\n");

	return 1;
}
#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit hogFader_OnFilterScriptInit
#if defined hogFader_OnFilterScriptInit
    forward hogFader_OnFilterScriptInit();
#endif

/*public OnPlayerConnect(playerid)
{
	#if defined hogFader_OnPlayerConnect
        hogFader_OnPlayerConnect(playerid);
    #endif

	CreatePrivateFadeText(playerid);

	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect hogFader_OnPlayerConnect
#if defined hogFader_OnPlayerConnect
    forward hogFader_OnPlayerConnect();
#endif*/
/*public OnGameModeInit()
{
	#if defined fader_OnGameModeInit
        fader_OnGameModeInit();
    #endif

	fadeInit();

	return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit fader_OnGameModeInit
#if defined fader_OnGameModeInit
    forward fader_OnGameModeInit();
#endif*/
/*call:fader_OnGameModeInit()
{
	fadeInit();

	return 1;
}*/
/*
 * STATEMENTS
 *****************************************************************************
 */
forward OnFadeScreenPlayerChanged(playerid, bool:fadeType);
/*
 * MY CALLBACKS
 *****************************************************************************
 */
call:FadeTransition(playerid, bool:fadeType, timeDuration)
{
	if(fadeType == FADE_OUT)
	{
		if(fadeAA[playerid] | fadeAA[playerid]-3 <= 1)
		{
			PlayerTextDrawShow(playerid, playerTextFade[playerid]);

			CallLocalFunction("OnFadeScreenPlayerChanged", "ii", playerid, fadeType);
			return;
		}

		fadeAA[playerid] -= 3;

		PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], fadeAA[playerid]);
		PlayerTextDrawShow(playerid, playerTextFade[playerid]);

		timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, fadeType, timeDuration);

		#if defined FADE_STATS_DEBUG
		    SendClientMessageEx(playerid, -1, "OUT %d", fadeAA[playerid]);
		#endif

		return;
	}

	if(fadeAA[playerid] | fadeAA[playerid]+2 >= 255)
	{
		PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
		PlayerTextDrawShow(playerid, playerTextFade[playerid]);
		return;
	}

	fadeAA[playerid] += 2;

	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], fadeAA[playerid]);
	PlayerTextDrawShow(playerid, playerTextFade[playerid]);

	timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, fadeType, timeDuration);

	#if defined FADE_STATS_DEBUG
		SendClientMessageEx(playerid, -1, "IN %d", fadeAA[playerid]);
	#endif
}
/*
 * FUNCTIONS
 *****************************************************************************
 */
CreatePrivateFadeText(playerid)
{
	playerTextFade[playerid] = CreatePlayerTextDraw(playerid, -2.000000, -2.000000, "box");
	PlayerTextDrawLetterSize(playerid, playerTextFade[playerid], 0.000000, 50.000000);
	PlayerTextDrawTextSize(playerid, playerTextFade[playerid], 645.000000, 0.000000);
	PlayerTextDrawColor(playerid, playerTextFade[playerid], -1);
	PlayerTextDrawUseBox(playerid, playerTextFade[playerid], 1);
	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 0);//0-255
	PlayerTextDrawBackgroundColor(playerid, playerTextFade[playerid], 255);
	PlayerTextDrawFont(playerid, playerTextFade[playerid], 1);
}
/*
 * INC FUNCTIONS
 *****************************************************************************
 */
stock CreatePlayerFade(playerid, bool:showFade)
{
	CreatePrivateFadeText(playerid);
	
	if(showFade)
		fadeDirect(playerid);
}

stock fadeOut(playerid, timeDuration)
{
	fadeAA[playerid] = 255;

	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
	PlayerTextDrawShow(playerid, playerTextFade[playerid]);

	timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, FADE_OUT, timeDuration);
}

stock fadeIn(playerid, timeDuration)
{
	fadeAA[playerid] = 0;

	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 0);

	PlayerTextDrawShow(playerid, playerTextFade[playerid]);

	timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, FADE_IN, timeDuration);
}

stock fadeDirect(playerid)
{
	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
	PlayerTextDrawShow(playerid, playerTextFade[playerid]);
}

stock fadeStop(playerid)
{
	KillTimer(timerFade[playerid]);
	PlayerTextDrawHide(playerid, playerTextFade[playerid]);
}