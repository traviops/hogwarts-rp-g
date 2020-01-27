#include <a_samp>
#include <zcmd>
#include <hogFade>
#include <magicAnimation>
/*----------------------------------------------------------------------------*/
/*
	{VARIABELS}
*/
enum E_LOGIN_SCREEN_TEXT
{
	Text:e_TITLE[3],

	Text:e_BUTTON[3],

	Text:e_TEXT[4]
}

new 
	Text:loginScreenTextDraw[E_LOGIN_SCREEN_TEXT],
	bool:whileConnect[MAX_PLAYERS];
/*----------------------------------------------------------------------------*/
/*
	{DEFINES}
*/
#define SendClientMessageEx(%0,%1,%2,%3) static stringf[256]; format(stringf, sizeof(stringf),%2,%3) && SendClientMessage(%0, %1, stringf)
#define call:%1(%2) forward %1(%2); public %1(%2)
/*----------------------------------------------------------------------------*/
/*
	{CALLBACKS}
*/
public OnFilterScriptInit()
{
	fade_OnFilterScriptInit();

	CreateMainScreenTextDraw();

	print("\n-----------------------------------------------");
	print("      [HOG] Login Screen[v_type_0] loaded");
	print("-----------------------------------------------\n");

	return 1;
}

public OnPlayerConnect(playerid)
{
	whileConnect[playerid] = true;
    if(whileConnect[playerid]) TogglePlayerSpectating(playerid, 1);

	OpenLoginScreenToPlayer(playerid);

	return 1;
}

public OnPlayerSpawn(playerid)
{
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

call:StartFadeOut(playerid)
{
	fadeOut(playerid, 50);
}
/*call:SetPositionCamera(playerid)
{
	SetPlayerCameraPos(playerid, 321.521942, 8827.158203, 13.316607+1.3);
    SetPlayerCameraLookAt(playerid, 324.171295, 8824.163085, 13.204122+1.3);
}*/

call:ShowTextDrawsLoginScreen(playerid, tape)
{
	switch(tape)
	{
		case 0:
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_BUTTON][0]),
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TEXT][0]);
		case 1:
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_BUTTON][1]),
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TEXT][1]);
		case 2:
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_BUTTON][2]),
			TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TEXT][2]);
		case 3: TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TEXT][3]), SelectTextDraw(playerid, 0xDDDDDDAA);
	}

	if(tape != 3) SetTimerEx("ShowTextDrawsLoginScreen", 300, false, "ii", playerid, tape+1);
}
call:CallStartMagicAnimation(playerid) StartMagicAnimation(playerid);

OpenLoginScreenToPlayer(playerid)
{
	fadeDirect(playerid);

	TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TITLE][0]);
	TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TITLE][1]);
	TextDrawShowForPlayer(playerid, loginScreenTextDraw[e_TITLE][2]);

	//SetTimerEx("SetPositionCamera", 500, false, "i", playerid);
	
	SetTimerEx("StartFadeOut", 1000, false, "i", playerid);

	//SpawnPlayer(playerid);
	whileConnect[playerid] = false;
	TogglePlayerSpectating(playerid, 0);
	OnPlayerRequestClass(playerid, 0);
}
PositionPlayerLoginScreen(playerid)
{
	//SendClientMessage(playerid, -1, "spawned");

	SetPlayerPos(playerid, 324.2294,8824.7646,14.3335);
	SetPlayerFacingAngle(playerid, 41.4946);
	SetPlayerSkin(playerid, 171);

	SetPlayerCameraPos(playerid, 321.521942, 8827.158203, 13.316607+1.3);
	SetPlayerCameraLookAt(playerid, 324.171295, 8824.163085, 13.204122+1.3);

	TogglePlayerControllable(playerid, true);//ver aqui

	//StartMagicAnimation(playerid);
	SetTimerEx("CallStartMagicAnimation", 50, false, "i", playerid);

	SetPlayerAttachedObject(playerid, 2,18644,5,0.096000,0.036999,0.009000,-0.800069,-0.199999,0.000000,1.000000,1.000000,1.000000);
}
CreateMainScreenTextDraw()
{
	loginScreenTextDraw[e_TITLE][0] = TextDrawCreate(345.529327, 118.833290, "H");
	TextDrawLetterSize(loginScreenTextDraw[e_TITLE][0], 1.053176, 5.006666);
	TextDrawAlignment(loginScreenTextDraw[e_TITLE][0], 1);
	TextDrawColor(loginScreenTextDraw[e_TITLE][0], -1);
	TextDrawSetShadow(loginScreenTextDraw[e_TITLE][0], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TITLE][0], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TITLE][0], 255);
	TextDrawFont(loginScreenTextDraw[e_TITLE][0], 1);
	TextDrawSetProportional(loginScreenTextDraw[e_TITLE][0], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TITLE][0], 0);

	loginScreenTextDraw[e_TITLE][1] = TextDrawCreate(369.058837, 141.583312, "ogwarts");
	TextDrawLetterSize(loginScreenTextDraw[e_TITLE][1], 0.406587, 1.920830);
	TextDrawAlignment(loginScreenTextDraw[e_TITLE][1], 1);
	TextDrawColor(loginScreenTextDraw[e_TITLE][1], -1);
	TextDrawSetShadow(loginScreenTextDraw[e_TITLE][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TITLE][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TITLE][1], 255);
	TextDrawFont(loginScreenTextDraw[e_TITLE][1], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TITLE][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TITLE][1], 0);

	loginScreenTextDraw[e_TITLE][2] = TextDrawCreate(431.646972, 155.000030, "rp/g");
	TextDrawLetterSize(loginScreenTextDraw[e_TITLE][2], 0.152941, 1.144997);
	TextDrawAlignment(loginScreenTextDraw[e_TITLE][2], 1);
	TextDrawColor(loginScreenTextDraw[e_TITLE][2], -1523963137);
	TextDrawSetShadow(loginScreenTextDraw[e_TITLE][2], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TITLE][2], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TITLE][2], 255);
	TextDrawFont(loginScreenTextDraw[e_TITLE][2], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TITLE][2], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TITLE][2], 0);

	loginScreenTextDraw[e_BUTTON][0] = TextDrawCreate(333.764434, 79.166687, "-");
	TextDrawLetterSize(loginScreenTextDraw[e_BUTTON][0], 9.116230, 19.636692);
	//TextDrawTextSize(loginScreenTextDraw[e_BUTTON][0], 440.000000, 79.000000);
	TextDrawAlignment(loginScreenTextDraw[e_BUTTON][0], 1);
	TextDrawColor(loginScreenTextDraw[e_BUTTON][0], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][0], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_BUTTON][0], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_BUTTON][0], 255);
	TextDrawFont(loginScreenTextDraw[e_BUTTON][0], 1);
	TextDrawSetProportional(loginScreenTextDraw[e_BUTTON][0], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][0], 0);
	//TextDrawSetSelectable(loginScreenTextDraw[e_BUTTON][0], true);

	loginScreenTextDraw[e_TEXT][0] = TextDrawCreate(397.294097+1.0, 180.666748, "Entrar");
	TextDrawLetterSize(loginScreenTextDraw[e_TEXT][0], 0.426822, 2.224164);
	TextDrawTextSize(loginScreenTextDraw[e_TEXT][0], 25.000000, 100.000000);
	TextDrawAlignment(loginScreenTextDraw[e_TEXT][0], 2);
	TextDrawColor(loginScreenTextDraw[e_TEXT][0], -1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][0], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TEXT][0], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TEXT][0], 255);
	TextDrawFont(loginScreenTextDraw[e_TEXT][0], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TEXT][0], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][0], 0);
	TextDrawSetSelectable(loginScreenTextDraw[e_TEXT][0], true);

	loginScreenTextDraw[e_BUTTON][1] = TextDrawCreate(333.764434, 121.166725, "-");
	TextDrawLetterSize(loginScreenTextDraw[e_BUTTON][1], 9.116230, 19.636692);
	TextDrawAlignment(loginScreenTextDraw[e_BUTTON][1], 1);
	TextDrawColor(loginScreenTextDraw[e_BUTTON][1], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_BUTTON][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_BUTTON][1], 255);
	TextDrawFont(loginScreenTextDraw[e_BUTTON][1], 1);
	TextDrawSetProportional(loginScreenTextDraw[e_BUTTON][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][1], 0);
	//TextDrawSetSelectable(loginScreenTextDraw[e_BUTTON][1], true);

	loginScreenTextDraw[e_TEXT][1] = TextDrawCreate(397.294097+1.0, 223.833328-1.0, "registrar");
	TextDrawLetterSize(loginScreenTextDraw[e_TEXT][1], 0.426822, 2.224164);
	TextDrawTextSize(loginScreenTextDraw[e_TEXT][1], 25.000000, 100.000000);
	TextDrawAlignment(loginScreenTextDraw[e_TEXT][1], 2);
	TextDrawColor(loginScreenTextDraw[e_TEXT][1], -1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TEXT][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TEXT][1], 255);
	TextDrawFont(loginScreenTextDraw[e_TEXT][1], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TEXT][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][1], 0);
	TextDrawSetSelectable(loginScreenTextDraw[e_TEXT][1], true);
	/*loginScreenTextDraw[e_BUTTON][1] = TextDrawCreate(333.764434, 119.416717, "-");
	TextDrawLetterSize(loginScreenTextDraw[e_BUTTON][1], 9.116230, 19.636692);
	TextDrawAlignment(loginScreenTextDraw[e_BUTTON][1], 1);
	TextDrawColor(loginScreenTextDraw[e_BUTTON][1], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_BUTTON][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_BUTTON][1], 255);
	TextDrawFont(loginScreenTextDraw[e_BUTTON][1], 1);
	TextDrawSetProportional(loginScreenTextDraw[e_BUTTON][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][1], 0);

	loginScreenTextDraw[e_TEXT][1] = TextDrawCreate(397.294097, 221.500015, "registrar");
	TextDrawLetterSize(loginScreenTextDraw[e_TEXT][1], 0.426822, 2.224164);
	TextDrawAlignment(loginScreenTextDraw[e_TEXT][1], 2);
	TextDrawColor(loginScreenTextDraw[e_TEXT][1], -1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][1], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TEXT][1], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TEXT][1], 255);
	TextDrawFont(loginScreenTextDraw[e_TEXT][1], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TEXT][1], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][1], 0);*/

	loginScreenTextDraw[e_BUTTON][2] = TextDrawCreate(333.764434, 160.833358, "-");
	TextDrawLetterSize(loginScreenTextDraw[e_BUTTON][2], 9.116230, 19.636692);
	TextDrawAlignment(loginScreenTextDraw[e_BUTTON][2], 1);
	TextDrawColor(loginScreenTextDraw[e_BUTTON][2], -1523963178);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][2], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_BUTTON][2], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_BUTTON][2], 255);
	TextDrawFont(loginScreenTextDraw[e_BUTTON][2], 1);
	TextDrawSetProportional(loginScreenTextDraw[e_BUTTON][2], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_BUTTON][2], 0);
	//TextDrawSetSelectable(loginScreenTextDraw[e_BUTTON][2], true);

	loginScreenTextDraw[e_TEXT][2] = TextDrawCreate(397.294097+1.0, 262.916748, "sobre");
	TextDrawLetterSize(loginScreenTextDraw[e_TEXT][2], 0.426822, 2.224164);
	TextDrawTextSize(loginScreenTextDraw[e_TEXT][2], 22.000000, 100.000000);
	TextDrawAlignment(loginScreenTextDraw[e_TEXT][2], 2);
	TextDrawColor(loginScreenTextDraw[e_TEXT][2], -1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][2], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TEXT][2], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TEXT][2], 255);
	TextDrawFont(loginScreenTextDraw[e_TEXT][2], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TEXT][2], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][2], 0);
	TextDrawSetSelectable(loginScreenTextDraw[e_TEXT][2], true);

	loginScreenTextDraw[e_TEXT][3] = TextDrawCreate(446.705780, 293.250091, "versao ~r~0.0.1a");
	TextDrawLetterSize(loginScreenTextDraw[e_TEXT][3], 0.141644, 0.777495);
	TextDrawTextSize(loginScreenTextDraw[e_TEXT][3], 490.000000, 8.000000);
	TextDrawAlignment(loginScreenTextDraw[e_TEXT][3], 3);
	TextDrawColor(loginScreenTextDraw[e_TEXT][3], -1378294017);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][3], 0);
	TextDrawSetOutline(loginScreenTextDraw[e_TEXT][3], 0);
	TextDrawBackgroundColor(loginScreenTextDraw[e_TEXT][3], 255);
	TextDrawFont(loginScreenTextDraw[e_TEXT][3], 2);
	TextDrawSetProportional(loginScreenTextDraw[e_TEXT][3], 1);
	TextDrawSetShadow(loginScreenTextDraw[e_TEXT][3], 0);
	TextDrawSetSelectable(loginScreenTextDraw[e_TEXT][3], true);
}

/*
LoginScreen_OnPlayerConnect(playerid)
{
	whileConnect[playerid] = true;
    if(whileConnect[playerid] == true) {
        TogglePlayerSpectating(playerid, 1);
    }
}
LoginScreen_OnPlayerRequestClass(playerid)
{
	if(whileConnect[playerid] == true) {
        TogglePlayerSpectating(playerid, 1);
        return 1;
    }
}*/

CMD:tela(playerid)
{
	OpenLoginScreenToPlayer(playerid);
	return 1;
}
CMD:stop(playerid)
{
	StopMagicAnimation(playerid);
	return 1;
}