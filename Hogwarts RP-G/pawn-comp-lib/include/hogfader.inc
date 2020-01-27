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
//forward FadeTransition(playerid, fadeType, fadeInterval, fromModule, fadeWaitingType);
forward OnFadeScreenPlayerChanged(playerid, fadeType, fromModule, fadeWaitingType);
forward CreatePlayerFade(playerid, bool:showFade);
//forward SetPlayerFade(playerid, fadeType, fadeInterval, fromModule, fadeWaitingType);
/*forward fadeOut(playerid, fadeInterval);
forward fadeIn(playerid, fadeInterval);
forward fadeDirect(playerid);
forward fadeStop(playerid);*/

const

	FADE_TYPE_DIRECT	= 0,
	FADE_TYPE_IN		= 1,
	FADE_TYPE_OUT		= 2,
	FADE_TYPE_STOP		= 3;
/*
 * VARIABLES
 *****************************************************************************
 */
new 

	playerFadeWaiting[MAX_PLAYERS];

static

	PlayerText:playerTextFade[MAX_PLAYERS],

	Timer:timerFade[MAX_PLAYERS],
	fadeAA[MAX_PLAYERS];
/*
 * HOOK NATIVE CALLBACKS
 *****************************************************************************
 */
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
 * MY CALLBACKS
 *****************************************************************************
 */
timer FadeTransition[1000](playerid, fadeType, updateRate, fadeInterval, fromModule, fadeWaitingType)
{
	if(fadeType == FADE_TYPE_OUT)
	{
		if(fadeAA[playerid] <= 1 || fadeAA[playerid] - updateRate <= 1)
		{
			PlayerTextDrawShow(playerid, playerTextFade[playerid]);

			CallLocalFunction("OnFadeScreenPlayerChanged", "iiii", playerid, fadeType, fromModule, fadeWaitingType);
			return;
		}

		fadeAA[playerid] -= updateRate;

		PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], fadeAA[playerid]);
		PlayerTextDrawShow(playerid, playerTextFade[playerid]);

		timerFade[playerid] = defer FadeTransition[fadeInterval](playerid, fadeType, updateRate, fadeInterval, fromModule, fadeWaitingType);

		#if defined FADE_TRANSITION_DEBUG
			printf("OUT %d", fadeAA[playerid]);
		    //SendClientMessageFormat(playerid, -1, "OUT %d", fadeAA[playerid]);
		#endif

		return;
	}

	if(fadeAA[playerid] >= 255 || fadeAA[playerid] + updateRate >= 255)
	{
		PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
		PlayerTextDrawShow(playerid, playerTextFade[playerid]);

		CallLocalFunction("OnFadeScreenPlayerChanged", "iiii", playerid, fadeType, fromModule, fadeWaitingType);
		return;
	}

	fadeAA[playerid] += updateRate;

	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], fadeAA[playerid]);
	PlayerTextDrawShow(playerid, playerTextFade[playerid]);

	timerFade[playerid] = defer FadeTransition[fadeInterval](playerid, fadeType, updateRate, fadeInterval, fromModule, fadeWaitingType);

	#if defined FADE_TRANSITION_DEBUG
			printf("IN %d", fadeAA[playerid]);
		//SendClientMessageFormat(playerid, -1, "IN %d", fadeAA[playerid]);
	#endif
}

/*
 * FUNCTIONS
 *****************************************************************************
 */
static CreatePrivateFadeText(playerid)
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
public CreatePlayerFade(playerid, bool:showFade)
{
	CreatePrivateFadeText(playerid);
	
	if(showFade)
		SetPlayerFade(playerid, FADE_TYPE_DIRECT, 0, 0, 0, 0);
}

timer SetPlayerFade[1000](playerid, fadeType, updateRate, fadeInterval, fromModule, fadeWaitingType)
{
	if(!IsPlayerConnected(playerid))
		return;

	switch(fadeType)
	{
		case FADE_TYPE_DIRECT:
		{
			PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
			PlayerTextDrawShow(playerid, playerTextFade[playerid]);
		}

		case FADE_TYPE_IN:
		{
			fadeAA[playerid] = 0;

			PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 0);

			PlayerTextDrawShow(playerid, playerTextFade[playerid]);

			timerFade[playerid] = defer FadeTransition[fadeInterval](playerid, FADE_TYPE_IN, updateRate, fadeInterval, fromModule, fadeWaitingType);
		}

		case FADE_TYPE_OUT:
		{
			fadeAA[playerid] = 255;

			PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
			PlayerTextDrawShow(playerid, playerTextFade[playerid]);

			timerFade[playerid] = defer FadeTransition[fadeInterval](playerid, FADE_TYPE_OUT, updateRate, fadeInterval, fromModule, fadeWaitingType);
		}

		case FADE_TYPE_STOP:
		{
			stop timerFade[playerid];
			PlayerTextDrawHide(playerid, playerTextFade[playerid]);
		}

		default:
			return;
	}

	playerFadeWaiting[playerid] = fadeWaitingType;
}

GetPlayerFadeWaiting(playerid)
	return playerFadeWaiting[playerid];

/*public fadeOut(playerid, fadeInterval, fromModule, fadeWaitingType)
{
	fadeAA[playerid] = 255;

	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
	PlayerTextDrawShow(playerid, playerTextFade[playerid]);

	timerFade[playerid] = SetTimerEx("FadeTransition", fadeInterval, false, "ibiii", playerid, FADE_OUT, fadeInterval, fromModule, fadeWaitingType);
}

public fadeIn(playerid, fadeInterval, fromModule, fadeWaitingType)
{
	fadeAA[playerid] = 0;

	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 0);

	PlayerTextDrawShow(playerid, playerTextFade[playerid]);

	timerFade[playerid] = SetTimerEx("FadeTransition", fadeInterval, false, "ibiii", playerid, FADE_IN, fadeInterval, fromModule, fadeWaitingType);
}

public fadeDirect(playerid)
{
	PlayerTextDrawBoxColor(playerid, playerTextFade[playerid], 255);
	PlayerTextDrawShow(playerid, playerTextFade[playerid]);
}

public fadeStop(playerid)
{
	KillTimer(timerFade[playerid]);
	PlayerTextDrawHide(playerid, playerTextFade[playerid]);
}*/