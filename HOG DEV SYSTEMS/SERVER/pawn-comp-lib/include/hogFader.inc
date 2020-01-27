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
 * DEFINES
 *****************************************************************************
 */
#define FADE_OUT	false
#define FADE_IN		true

#if !defined call
	#define call:%1(%2) forward %1(%2); public %1(%2)
#endif
#define SendClientMessageEx(%0,%1,%2,%3) static stringf[256]; format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
/*
 * VARIABLES
 *****************************************************************************
 */
static
	Text:textFade,
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

	print("    > [inc] loading hogFader.inc");

    fadeInit();

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
			TextDrawHideForPlayer(playerid, textFade);

			CallLocalFunction("OnFadeScreenPlayerChanged", "ii", playerid, fadeType);
			return;
		}

		fadeAA[playerid] -= 3;

		TextDrawBoxColor(textFade, fadeAA[playerid]);
		TextDrawShowForPlayer(playerid, textFade);

		timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, fadeType, timeDuration);

		#if defined FADE_STATS_DEBUG
		    SendClientMessageEx(playerid, -1, "OUT %d", fadeAA[playerid]);
		#endif

		return;
	}

	if(fadeAA[playerid] | fadeAA[playerid]+2 >= 255)
	{
		TextDrawBoxColor(textFade, 255);
		TextDrawShowForPlayer(playerid, textFade);
		return;
	}

	fadeAA[playerid] += 2;

	TextDrawBoxColor(textFade, fadeAA[playerid]);
	TextDrawShowForPlayer(playerid, textFade);

	timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, fadeType, timeDuration);

	#if defined FADE_STATS_DEBUG
		SendClientMessageEx(playerid, -1, "IN %d", fadeAA[playerid]);
	#endif
}
/*
 * FUNCTIONS
 *****************************************************************************
 */
fadeInit()
{
	textFade = TextDrawCreate(-2.000000, -2.000000, "box");
	TextDrawLetterSize(textFade, 0.000000, 50.000000);
	TextDrawTextSize(textFade, 645.000000, 0.000000);
	TextDrawColor(textFade, -1);
	TextDrawUseBox(textFade, 1);
	TextDrawBoxColor(textFade, 0);//0-255
	TextDrawBackgroundColor(textFade, 255);
	TextDrawFont(textFade, 1);

	print("      > fadeInit(): textFade created");
}
/*
 * INC FUNCTIONS
 *****************************************************************************
 */
stock fadeOut(playerid, timeDuration)
{
	fadeAA[playerid] = 255;

	TextDrawBoxColor(textFade, 255);

	TextDrawShowForPlayer(playerid, textFade);

	timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, FADE_OUT, timeDuration);
}

stock fadeIn(playerid, timeDuration)
{
	fadeAA[playerid] = 0;

	TextDrawBoxColor(textFade, 0);

	TextDrawShowForPlayer(playerid, textFade);

	timerFade[playerid] = SetTimerEx("FadeTransition", timeDuration, false, "ibi", playerid, FADE_IN, timeDuration);

	SendClientMessage(playerid, -1, "const message[]");
}

stock fadeDirect(playerid)
{
	TextDrawBoxColor(textFade, 255);

	TextDrawShowForPlayer(playerid, textFade);
}

stock fadeStop(playerid)
{
	KillTimer(timerFade[playerid]);
	TextDrawHideForPlayer(playerid, textFade);
}