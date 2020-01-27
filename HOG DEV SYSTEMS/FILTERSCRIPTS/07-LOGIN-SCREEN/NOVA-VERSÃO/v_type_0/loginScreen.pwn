/*
	|
	 *
	 * INCLUDES
	 *
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
	 * COMMANDS
	 *
	|
	BUGS: 	
		- Quando o player se conecta pela primeira vez após o servidor ser iniciado, tudo ocorre normalmente, porém, caso relogue,
		o sistema apresenta falhas, tais quais fazem a animação do MagicAnimation não ser executada...

		- Quando um player entra depois de outro player ter entrado após o servidor ter sido iniciado, a animação do MagicAnimation
		não é executada, dando o mesmo bug dito acima.

	CORREÇÃO DO BUG:
		- (28/04/16 - 21:22)
			Talvez o bug tenha sido solucionado, uma vez que foi aplicado o reset das variáveis de controle da inc MagicAnimation.
*/
/*
 * INCLUDES
 *****************************************************************************
 */
#include <a_samp>
#include <zcmd>
#include <hogFader>
#include <magicAnimation>
/*
 * DEFINES
 *****************************************************************************
 */
#define SendClientMessageEx(%0,%1,%2,%3) static stringf[256]; format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
#define call:%1(%2) forward %1(%2); public %1(%2)
/*
 * VARIABLES
 *****************************************************************************
 */
enum E_LOGIN_SCREEN_TEXT
{
	Text:E_LOGIN_TITLE[3],

	Text:E_LOGIN_BUTTON[3],

	Text:E_LOGIN_TEXT[4]
}

new 
	Text:loginScreenTextDraw[E_LOGIN_SCREEN_TEXT],
	bool:whileConnect[MAX_PLAYERS],
	mapBlock;
/*
 * NATIVE CALLBACKS
 *****************************************************************************
 */
public OnFilterScriptInit()
{
	fader_OnGameModeInit();

	CreateLoginScreenTextDraw();

	/*	7703.6450,11661.1563,26.2179 	// pos block 1
		-4312.5830,-4842.5112,885.5993 	// pos block 2
	*/
	mapBlock = GangZoneCreate(-10000.0, -11000.0, 10000.0, 11000.0);

	print("\n-----------------------------------------------");
	print("      [HOG] Login Screen[v_type_0] loaded");
	print("-----------------------------------------------\n");

	return 1;
}

public OnPlayerConnect(playerid)
{
	whileConnect[playerid] = true;
    
    TogglePlayerSpectating(playerid, 1);

	OpenLoginScreenToPlayer(playerid);

	return 1;
}

public OnPlayerSpawn(playerid)
{
	//MA_LoadAnimations(playerid);

	PositionPlayerLoginScreen(playerid);

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
   
	if(whileConnect[playerid])
	{
        TogglePlayerSpectating(playerid, 1);
        return 1;
    }

 	SetSpawnInfo(playerid, 0, 171, 324.2294,8824.7646,14.3335, 41.4946, 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);

	return false;
}

public OnFadeScreenPlayerChanged(playerid, bool:fadeType)
{
	if(fadeType == FADE_OUT)
	{
		SetTimerEx("ShowTextDrawsLoginScreen", 300, false, "ii", playerid, 0);
	}
}
/*
 * MY CALLBACKS
 *****************************************************************************
 */
call:StartFadeOut(playerid)
{
	fadeOut(playerid, 50);
}

call:ShowTextDrawsLoginScreen(playerid, tape)
{
	switch(tape)
	{
		case 0:
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_BUTTON][0]),
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TEXT][0]);
		case 1:
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_BUTTON][1]),
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TEXT][1]);
		case 2:
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_BUTTON][2]),
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TEXT][2]);
		case 3: TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TEXT][3]);//, SelectTextDraw(playerid, 0xDDDDDDAA);
	}

	if(tape != 3) SetTimerEx("ShowTextDrawsLoginScreen", 300, false, "ii", playerid, tape+1);
}

call:CallStartMagicAnimation(playerid)
{
	/*new Float:pos[4];

	GetPlayerPos(playerid, pos[0],pos[1],pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);

	if(pos[0] != 324.2294 || pos[1] != 8824.7646 || pos[2] != 14.3335 || pos[3] != 41.4946)
	{
		SetPlayerPos(playerid, 324.2294,8824.7646,14.3335);
		SetPlayerFacingAngle(playerid, 41.4946);
	}*/

	StartMagicAnimation(playerid);
}
/*
 * FUNCTIONS
 *****************************************************************************
 */
OpenLoginScreenToPlayer(playerid)
{
	fadeDirect(playerid);

	TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TITLE][0]);
	TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TITLE][1]);
	TextDrawShowForPlayer(playerid, loginScreenTextDraw[E_LOGIN_TITLE][2]);
	
	//SetTimerEx("StartFadeOut", 2000, false, "i", playerid);

	whileConnect[playerid] = false;
	TogglePlayerSpectating(playerid, 0);
	OnPlayerRequestClass(playerid, 0);
}

PositionPlayerLoginScreen(playerid)
{
	GangZoneShowForPlayer(playerid, mapBlock, 0x000000FF);

	SelectTextDraw(playerid, 0xDDDDDDAA);

	SetPlayerVirtualWorld(playerid, random(300)+100);

	SetPlayerWeather(playerid, 78);

	SetPlayerPos(playerid, 324.2294,8824.7646,14.3335);
	SetPlayerFacingAngle(playerid, 41.4946);
	SetPlayerSkin(playerid, 171);

	SetPlayerCameraPos(playerid, 321.521942, 8827.158203, 13.316607+1.3);
	SetPlayerCameraLookAt(playerid, 324.171295, 8824.163085, 13.204122+1.3);

	TogglePlayerControllable(playerid, true);//ver aqui

	SetTimerEx("CallStartMagicAnimation", 50, false, "i", playerid);

	SetTimerEx("StartFadeOut", 3000, false, "i", playerid);

	SetPlayerAttachedObject(playerid, 2,18644,5,0.096000,0.036999,0.009000,-0.800069,-0.199999,0.000000,1.000000,1.000000,1.000000);
}

CreateLoginScreenTextDraw()
{
	loginScreenTextDraw[E_LOGIN_TITLE][0] = TextDrawCreate(345.529327, 118.833290, "H");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TITLE][0], 1.053176, 5.006666);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TITLE][0], 1);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TITLE][0], -1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TITLE][0], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TITLE][0], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TITLE][0], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TITLE][0], 1);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TITLE][0], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TITLE][0], 0);

	loginScreenTextDraw[E_LOGIN_TITLE][1] = TextDrawCreate(369.058837, 141.583312, "ogwarts");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TITLE][1], 0.406587, 1.920830);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TITLE][1], 1);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TITLE][1], -1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TITLE][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TITLE][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TITLE][1], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TITLE][1], 2);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TITLE][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TITLE][1], 0);

	loginScreenTextDraw[E_LOGIN_TITLE][2] = TextDrawCreate(431.646972, 155.000030, "rp/g");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TITLE][2], 0.152941, 1.144997);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TITLE][2], 1);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TITLE][2], -1523963137);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TITLE][2], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TITLE][2], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TITLE][2], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TITLE][2], 2);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TITLE][2], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TITLE][2], 0);

	loginScreenTextDraw[E_LOGIN_BUTTON][0] = TextDrawCreate(333.764434, 79.166687, "-");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_BUTTON][0], 9.116230, 19.636692);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_BUTTON][0], 1);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_BUTTON][0], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_BUTTON][0], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_BUTTON][0], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_BUTTON][0], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_BUTTON][0], 1);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_BUTTON][0], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_BUTTON][0], 0);

	loginScreenTextDraw[E_LOGIN_TEXT][0] = TextDrawCreate(397.294097+1.0, 180.666748, "Entrar");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TEXT][0], 0.426822, 2.224164);
	TextDrawTextSize(loginScreenTextDraw[E_LOGIN_TEXT][0], 25.000000, 100.000000);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TEXT][0], 2);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TEXT][0], -1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][0], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TEXT][0], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TEXT][0], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TEXT][0], 2);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TEXT][0], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][0], 0);
	TextDrawSetSelectable(loginScreenTextDraw[E_LOGIN_TEXT][0], true);

	loginScreenTextDraw[E_LOGIN_BUTTON][1] = TextDrawCreate(333.764434, 121.166725, "-");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_BUTTON][1], 9.116230, 19.636692);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_BUTTON][1], 1);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_BUTTON][1], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_BUTTON][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_BUTTON][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_BUTTON][1], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_BUTTON][1], 1);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_BUTTON][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_BUTTON][1], 0);

	loginScreenTextDraw[E_LOGIN_TEXT][1] = TextDrawCreate(397.294097+1.0, 223.833328-1.0, "registrar");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TEXT][1], 0.426822, 2.224164);
	TextDrawTextSize(loginScreenTextDraw[E_LOGIN_TEXT][1], 25.000000, 100.000000);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TEXT][1], 2);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TEXT][1], -1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TEXT][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TEXT][1], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TEXT][1], 2);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TEXT][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][1], 0);
	TextDrawSetSelectable(loginScreenTextDraw[E_LOGIN_TEXT][1], true);

	loginScreenTextDraw[E_LOGIN_BUTTON][2] = TextDrawCreate(333.764434, 160.833358, "-");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_BUTTON][2], 9.116230, 19.636692);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_BUTTON][2], 1);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_BUTTON][2], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_BUTTON][2], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_BUTTON][2], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_BUTTON][2], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_BUTTON][2], 1);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_BUTTON][2], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_BUTTON][2], 0);
	//TextDrawSetSelectable(loginScreenTextDraw[E_LOGIN_BUTTON][2], true);

	loginScreenTextDraw[E_LOGIN_TEXT][2] = TextDrawCreate(397.294097+1.0, 262.916748, "sobre");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TEXT][2], 0.426822, 2.224164);
	TextDrawTextSize(loginScreenTextDraw[E_LOGIN_TEXT][2], 22.000000, 100.000000);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TEXT][2], 2);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TEXT][2], -1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][2], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TEXT][2], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TEXT][2], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TEXT][2], 2);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TEXT][2], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][2], 0);
	TextDrawSetSelectable(loginScreenTextDraw[E_LOGIN_TEXT][2], true);

	loginScreenTextDraw[E_LOGIN_TEXT][3] = TextDrawCreate(446.705780, 293.250091, "versao ~r~0.0.1a");
	TextDrawLetterSize(loginScreenTextDraw[E_LOGIN_TEXT][3], 0.141644, 0.777495);
	TextDrawTextSize(loginScreenTextDraw[E_LOGIN_TEXT][3], 490.000000, 8.000000);
	TextDrawAlignment(loginScreenTextDraw[E_LOGIN_TEXT][3], 3);
	TextDrawColor(loginScreenTextDraw[E_LOGIN_TEXT][3], -1378294017);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][3], 0);
	TextDrawSetOutline(loginScreenTextDraw[E_LOGIN_TEXT][3], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[E_LOGIN_TEXT][3], 255);
	TextDrawFont(loginScreenTextDraw[E_LOGIN_TEXT][3], 2);
	TextDrawSetProportional(loginScreenTextDraw[E_LOGIN_TEXT][3], 1);
	TextDrawSetShadow(loginScreenTextDraw[E_LOGIN_TEXT][3], 0);
	TextDrawSetSelectable(loginScreenTextDraw[E_LOGIN_TEXT][3], true);
}
/*
 * COMMANDS
 *****************************************************************************
 */
CMD:stop(playerid)
{
	StopMagicAnimation(playerid);
	return 1;
}

CMD:b(playerid)
{
	SetCameraBehindPlayer(playerid);
	return 1;
}