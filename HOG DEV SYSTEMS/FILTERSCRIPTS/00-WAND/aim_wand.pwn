/*
	Wand System(Sistema de varinha)
		- Descrição.

		Versão: 1.0.0
		Última atualização: 00/00/00

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
#include <streamer>
/*
 *****************************************************************************
*/
/*
 |DEFINITIONS|
*/
/// <summary> 
///	Macros utilizados.</summary>
static stock stringF[256];

#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if !defined SendClientMessageEx
	#define SendClientMessageEx(%0,%1,%2,%3) format(stringF, sizeof(stringF),%2,%3) && SendClientMessage(%0, %1, stringF)//ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[]) 
#endif

#if !defined call
	#define call:%0(%1) forward %0(%1); public %0(%1)
#endif

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

const
	MAX_EFFECT_OBJECTS	= 10,

	WAND_ATTACH_INDEX			= 8,
	WAND_ATTACH_EFFECT_INDEX	= 9;
/*
 *****************************************************************************
*/
/*
 |ENUMERATORS|
*/
enum E_PLAYER_WAND
{
	bool:E_PLAYER_WAND_EQUIPPED,
	bool:E_PLAYER_WAND_AIM_STATE,
	bool:E_WAND_THROWING_EFFECT,
	E_WAND_EFFECT_OBJECT[MAX_EFFECT_OBJECTS],
	E_WAND_TARGET_ID
}
enum E_PLAYER_CONTROL
{
	bool:E_PLAYER_FIRST_SPAWN
}
/*
 *****************************************************************************
*/
/*
 |VARIABLES|
*/
static
	Text:textWandAimGlobal,
	PlayerText:textWandAimPrivate[MAX_PLAYERS],
	
	playerWand[MAX_PLAYERS][E_PLAYER_WAND],
	playerControl[MAX_PLAYERS][E_PLAYER_CONTROL];
/*
 *****************************************************************************
*/
/*
 |NATIVE CALLBACKS|
*/
public OnFilterScriptInit()
{
	CreateTDGlobalWand();

	print("\n------------------------------------");
	print("      [HOG] Wand System loaded");
	print("------------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	for(new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) RemovePlayerAttachedObject(playerid, i);

	CreateTDPrivateWand(playerid);
	ResetPlayerEffectObjects(playerid);

	playerWand[playerid][E_WAND_TARGET_ID] = INVALID_PLAYER_ID;
	playerControl[playerid][E_PLAYER_FIRST_SPAWN] = true;

	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(playerControl[playerid][E_PLAYER_FIRST_SPAWN])
	{
		playerControl[playerid][E_PLAYER_FIRST_SPAWN] = false;

		LoadPlayerAnimations(playerid);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_FIRE && playerWand[playerid][E_PLAYER_WAND_EQUIPPED] && playerWand[playerid][E_PLAYER_WAND_AIM_STATE])//newkeys & KEY_HANDBRAKE)
	{
		ApplyWandEffect(playerid);
	}
	else if(newkeys & KEY_NO)
	{
		new
            Float:fPX, Float:fPY, Float:fPZ,
            Float:fVX, Float:fVY, Float:fVZ,
            Float:object_x, Float:object_y, Float:object_z;
 
        // Change me to change the scale you want. A larger scale increases the distance from the camera.
        // A negative scale will inverse the vectors and make them face in the opposite direction.
        const
            Float:fScale = 5.0;
 
        GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
        GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
 
        object_x = fPX + floatmul(fVX, fScale);
        object_y = fPY + floatmul(fVY, fScale);
        object_z = fPZ + floatmul(fVZ, fScale);
 
        CreateObject(1974, object_x, object_y, object_z, 0.0, 0.0, 0.0);
	}
	
	return 1;
}
/*public OnPlayerUpdate(playerid)
{
	new target,
		keys,
		ud,
		lr;
		Float:p[3];
	        
	GetPlayerCameraPos(playerid, p[0], p[1], p[2]);

	GetPlayerKeys(playerid, keys, ud, lr);

	if(keys & KEY_SPRINT)
	{
		SendClientMessage(playerid, -1, "ok");

		target = PossibleTarget(playerid);

		if(!~target) return SendClientMessage(playerid, -1, "- None -");

		SendClientMessageEx(playerid, -1, "Você está mirando no jogador %d.", target);
	}

	return 1;
}*/
/*
 *****************************************************************************
*/
/*
 |MY CALLBACKS|
*/
call:CheckKeyAim(playerid)
{
	if(!playerWand[playerid][E_PLAYER_WAND_EQUIPPED])
	{
		ChangePlayerWandState(playerid, false, false);
		return;
	}

	new target,
		keys,
		ud,
		lr;
	        
	GetPlayerKeys(playerid, keys, ud, lr);

	if(keys & KEY_HANDBRAKE)
	{
		target = PossibleTarget(playerid);

		if(!~target)
		{
			ChangePlayerWandState(playerid, false);

			if(playerWand[playerid][E_WAND_TARGET_ID] != INVALID_PLAYER_ID)
				playerWand[playerid][E_WAND_TARGET_ID] = INVALID_PLAYER_ID;
		}
		else
		{
			ChangePlayerWandState(playerid, true);

			playerWand[playerid][E_WAND_TARGET_ID] = target;
		}
	}
	else if(playerWand[playerid][E_PLAYER_WAND_AIM_STATE])
		ChangePlayerWandState(playerid, false);

	SetTimerEx("CheckKeyAim", 100, false, "i", playerid);
}
call:WandEffect(playerid)
{
	new index = GetEffectObjectIndexFree(playerid);

	if(!~index) return;

	new 
		targetid = playerWand[playerid][E_WAND_TARGET_ID],
		Float:X, Float:Y, Float:Z, Float:VX, Float:VY, Float:A;

	GetPlayerCameraFrontVector(playerid, VX, VY, A);
	A = atan2(VY, VX) + 270.0;
	GetPlayerVelocity(targetid, X, Y, Z);
	SetPlayerVelocity(targetid, floatsin(-A, degrees) * 0.5, floatcos(A, degrees) * 0.5 , floatabs((Z*2.5)+1.035));

	SetPlayerAttachedObject(playerid, WAND_ATTACH_EFFECT_INDEX, 18724, 1, 0.833537, 0.750917, -1.701738, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	//CreateWandEffect(playerid, index);
}
call:StopWandAnimation(playerid)
{
	UnfreezePlayer(playerid);

	playerWand[playerid][E_WAND_THROWING_EFFECT] = false;
}
/*
 *****************************************************************************
*/
/*
 |FUNCTIONS|
*/
stock CreateWandEffect(playerid, index)
{
	if(!~index) return;

	new Float:posX,
		Float:posY,
		Float:posZ,
		Float:angle,
		/*Float:cameraPos[3],
		Float:vectorPos[3],*/
		Float:pos3DX,
		Float:pos3DY,
		Float:pos3DZ,
		Float:distance,
		Float:cameraPosX,
		Float:cameraPosY,
		Float:cameraPosZ,
		Float:cameraRotX,
		Float:cameraRotZ,
		Float:cameraVectorX,
		Float:cameraVectorY,
		Float:cameraVectorZ;

    GetPlayerPos(playerid, posX, posY, posZ);
	GetPlayerFacingAngle(playerid, angle);

	GetXYInFrontOfPoint(posX, posY, angle, 2.2);
	//------------------------------------------
	SendClientMessageEx(playerid, -1, "pos start: %.3f, %.3f, %.3f", posX, posY, posZ+1.0);
	//-------------------------------------------------------------------------------------
	//playerWand[playerid][E_WAND_EFFECT_OBJECT][index] = CreateObject(1974/*18693*/, posX, posY, posZ+1.0, 0.0, 90.0, angle-90);
	//-------------------------------------------------------------------------------------------------------------------------
	GetPlayerPos(playerWand[playerid][E_WAND_TARGET_ID], posX, posY, posZ);

	distance = GetPlayerDistanceFromPoint(playerid, posX, posY, posZ);

	SendClientMessageEx(playerid, -1, "distance: %.3f", distance);
	//--------------------------------------------------
	GetPlayerCameraPos(playerid, cameraPosX, cameraPosY, cameraPosZ);
	GetPlayerCameraFrontVector(playerid, cameraVectorX, cameraVectorY, cameraVectorZ);
 
	pos3DX = cameraPosX + floatmul(cameraVectorX, distance);
	pos3DY = cameraPosY + floatmul(cameraVectorY, distance);
	pos3DZ = cameraPosZ + floatmul(cameraVectorZ, distance);
	//--------------------------------------------------------
	GetPlayerCameraRotation(playerid, cameraRotX, cameraRotZ);

	distance = 3.0;

	GetXYInFrontOfPoint(pos3DX, pos3DY, cameraRotZ, distance);
	//--------------------------------------------------------
	CreateObject(1974, pos3DX, pos3DY, pos3DZ, 0.0, 0.0, 0.0);
	//--------------------------------------------------
	/*GetPlayerCameraPos(playerid, cameraPos[0], cameraPos[1], cameraPos[2]);
    GetPlayerCameraFrontVector(playerid, vectorPos[0], vectorPos[1], vectorPos[2]);

    //new Float:distance = floatabs(GetPlayerDistanceFromPoint(playerWand[playerid][E_WAND_EFFECT_OBJECT][index], posX, posY, posZ));//GetPlayerDistanceFromPoint(playerid, posX, posY, posZ));//GetDistanceBetweenPoints(posX, posY, posZ+1.0, cameraPos[0], cameraPos[1], cameraPos[2]);// * -1;

    cameraPos[0] = cameraPos[0] + floatmul(vectorPos[0], distance);
    cameraPos[1] = cameraPos[1] + floatmul(vectorPos[1], distance);
    cameraPos[2] = cameraPos[2] + floatmul(vectorPos[2], distance);*/

    /*new Float:distance = GetDistanceBetweenPoints(posX, posY, posZ+1.0, vectorPos[0], vectorPos[1], vectorPos[2]);

    GetPlayerCameraRotation(playerid, vectorPos[0], vectorPos[1]); 
	GetPointInFrontOfCamera3D(playerid,cameraPos[0], cameraPos[1], cameraPos[2], distance, vectorPos[0], vectorPos[1]);*/
	//GetXYInFrontOfPoint(cameraPos[0], cameraPos[1], angle-20.0, -100.0);
	//--------------------------------------------------------------------
	SendClientMessageEx(playerid, -1, "pos end: %.3f, %.3f, %.3f", pos3DX, pos3DY, pos3DZ/*cameraPos[0], cameraPos[1], cameraPos[2]*/);

	//MoveObject(playerWand[playerid][E_WAND_EFFECT_OBJECT][index], pos3DX, pos3DY, pos3DZ, 4, 0.0, 90.0, angle+180.0/*-90*/);
}
EquipPlayerWand(playerid)
{
	if(playerWand[playerid][E_PLAYER_WAND_EQUIPPED]) return;

	playerWand[playerid][E_PLAYER_WAND_EQUIPPED] = true;

	//SetPlayerAttachedObject(playerid, WAND_ATTACH_INDEX, 18644, 6, 0.080394, 0.019579, -0.008789, 175.201721, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	SetPlayerAttachedObject(playerid, WAND_ATTACH_INDEX, 338, 6, 0.063999, 0.007999, 0.008999, -9.600000, 0.000000, 0.000000, 0.416001, 0.436002, 0.202000);

	ShowPlayerWandAim(playerid);

	CheckKeyAim(playerid);
}
UnequipPlayerWand(playerid)
{
	if(!playerWand[playerid][E_PLAYER_WAND_EQUIPPED]) return;

	playerWand[playerid][E_PLAYER_WAND_EQUIPPED] = false;

	RemovePlayerAttachedObject(playerid, WAND_ATTACH_INDEX);

	ResetPlayerEffectObjects(playerid);

	HidePlayerWandAim(playerid);
}
ResetPlayerEffectObjects(playerid)
{
	for(new i; i < MAX_EFFECT_OBJECTS; i++)
		playerWand[playerid][E_WAND_EFFECT_OBJECT][i] = 0;

	playerWand[playerid][E_WAND_THROWING_EFFECT] = false;
}
GetEffectObjectIndexFree(playerid)
{
	for(new i; i < MAX_EFFECT_OBJECTS; i++)
	{
		if(!playerWand[playerid][E_WAND_EFFECT_OBJECT][i])
			return i;
	}
	return -1;
}
ApplyWandEffect(playerid)
{
	if(playerWand[playerid][E_WAND_THROWING_EFFECT]) return;

	playerWand[playerid][E_WAND_THROWING_EFFECT] = true;

	ApplyAnimation(playerid, "KNIFE", "knife_part", 4.1, 0, 1, 1, 1, 1, 1);

	PlayerPlaySound(playerid, 40408, 0, 0, 0);

    SetTimerEx("WandEffect", 200, false, "i", playerid);
    SetTimerEx("StopWandAnimation", 500, false, "i", playerid);
}
ChangePlayerWandState(playerid, bool:wandState, bool:show = true)
{
	/*
		false - Desable
		true - Enable

		0x479DD4FF (1201526015) azul
		0xFF493AFF (4282989311) vermelho
	*/
	PlayerTextDrawColor(playerid, textWandAimPrivate[playerid], (wandState) ? (4282989311) : (1201526015));
	
	if(show)
		PlayerTextDrawShow(playerid, textWandAimPrivate[playerid]);

	playerWand[playerid][E_PLAYER_WAND_AIM_STATE] = wandState;
}
ShowPlayerWandAim(playerid)
{
	TextDrawShowForPlayer(playerid, textWandAimGlobal);
	PlayerTextDrawShow(playerid, textWandAimPrivate[playerid]);
}

HidePlayerWandAim(playerid)
{
	TextDrawHideForPlayer(playerid, textWandAimGlobal);
	PlayerTextDrawHide(playerid, textWandAimPrivate[playerid]);
}
PossibleTarget(playerid)
{
	new playerPoolSize = GetPlayerPoolSize(),
		i;

	for(i = 0; i <= playerPoolSize; i++)
	{
 		if(i != playerid && IsPlayerAimingAtPlayer(playerid, i))
 			return i;
	}
	return -1;
}
//-----------------------------------------------------------------------------
CreateTDGlobalWand()
{
	textWandAimGlobal = TextDrawCreate(338.021331, 178.085937, "LD_BEAT:chit");
	TextDrawLetterSize(textWandAimGlobal, 0.000000, 0.000000);
	TextDrawTextSize(textWandAimGlobal, 1.900000, 2.500000);
	TextDrawAlignment(textWandAimGlobal, 1);
	TextDrawColor(textWandAimGlobal, -1);
	TextDrawSetShadow(textWandAimGlobal, 0);
	TextDrawSetOutline(textWandAimGlobal, 0);
	TextDrawBackgroundColor(textWandAimGlobal, 255);
	TextDrawFont(textWandAimGlobal, 4);
	TextDrawSetProportional(textWandAimGlobal, 0);
	TextDrawSetShadow(textWandAimGlobal, 0);
}
CreateTDPrivateWand(playerid)
{
	textWandAimPrivate[playerid] = CreatePlayerTextDraw(playerid, 330.593109, 170.749984, "particle:target256");
	PlayerTextDrawLetterSize(playerid, textWandAimPrivate[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, textWandAimPrivate[playerid], 17.100000, 16.499994);
	PlayerTextDrawAlignment(playerid, textWandAimPrivate[playerid], 1);
	PlayerTextDrawColor(playerid, textWandAimPrivate[playerid], 1201526015);
	PlayerTextDrawSetShadow(playerid, textWandAimPrivate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, textWandAimPrivate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, textWandAimPrivate[playerid], 255);
	PlayerTextDrawFont(playerid, textWandAimPrivate[playerid], 4);
	PlayerTextDrawSetProportional(playerid, textWandAimPrivate[playerid], 0);
	PlayerTextDrawSetShadow(playerid, textWandAimPrivate[playerid], 0);
	/*textWandAim[playerid][0] = CreatePlayerTextDraw(playerid, 337.000000, 178.000000-0.3, "LD_BEAT:chit");
	PlayerTextDrawBackgroundColor(playerid, textWandAim[playerid][0], 0);
	PlayerTextDrawFont(playerid, textWandAim[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, textWandAim[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, textWandAim[playerid][0], 1201526015);
	PlayerTextDrawSetOutline(playerid, textWandAim[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, textWandAim[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, textWandAim[playerid][0], 1);
	PlayerTextDrawUseBox(playerid, textWandAim[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, textWandAim[playerid][0], 255);
	PlayerTextDrawTextSize(playerid, textWandAim[playerid][0], 4.000000, 4.000000);
	PlayerTextDrawSetSelectable(playerid, textWandAim[playerid][0], 0);

	textWandAim[playerid][1] = CreatePlayerTextDraw(playerid, 332.000000, 173.000000, "particle:lockon");
	PlayerTextDrawBackgroundColor(playerid, textWandAim[playerid][1], 255);
	PlayerTextDrawFont(playerid, textWandAim[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, textWandAim[playerid][1], 0.500000, -2.000000);
	PlayerTextDrawColor(playerid, textWandAim[playerid][1], 842150655);
	PlayerTextDrawSetOutline(playerid, textWandAim[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, textWandAim[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, textWandAim[playerid][1], 1);
	PlayerTextDrawUseBox(playerid, textWandAim[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, textWandAim[playerid][1], 255);
	PlayerTextDrawTextSize(playerid, textWandAim[playerid][1], 14.000000, 13.000000);
	PlayerTextDrawSetSelectable(playerid, textWandAim[playerid][1], 0);*/
}
/*
 *****************************************************************************
*/
/*
 |COMPLEMENTS|
*/
/// <author>
/// Bruno13
/// </author>
/// <summary>
/// Descongela um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
UnfreezePlayer(playerid)
{
	ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 1, 1, 1);
}
/// <author>
/// Bruno13
/// </author>
/// <summary>
/// Carrega a livraria de cada animação utilizada. Evita problemas com a
/// aplicação das mesmas pela primeira vez.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
LoadPlayerAnimations(playerid)
{
    ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "KNIFE", "null", 0.0, 0, 0, 0, 0, 0);
}
//----------------------------------------------------------------
static stock GetPlayerCameraRotation(playerid,&Float:rx,&Float:rz)
{
	new Float:mx,Float:my,Float:mz;
	GetPlayerCameraFrontVector(playerid,mx,my,mz);
	CompRotationFloat(-(acos(mz)-90.0),rx);
	CompRotationFloat((atan2(my,mx)-90.0),rz);
}

static stock GetPointInFrontOfCamera3D(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0)
{
	new Float:x,Float:y,Float:z;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPlayerCameraRotation(playerid,rx,rz);
	GetPointInFront3D(x,y,z,rx,rz,radius,tx,ty,tz);
}

static stock GetPointInFront3D(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz)
{
	tx = x - (radius * floatcos(rx,degrees) * floatsin(rz,degrees));
	ty = y + (radius * floatcos(rx,degrees) * floatcos(rz,degrees));
	tz = z + (radius * floatsin(rx,degrees));
}

static stock CompRotationFloat(Float:rotation,&Float:crotation=0.0)
{
	crotation = rotation;
	while(crotation < 0.0) crotation += 360.0;
	while(crotation >= 360.0) crotation -= 360.0;
	return _:crotation;
}

stock static Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return VectorSize(x1-x2, y1-y2, z1-z2);
}

static Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ, Float:ObjX, Float:ObjY, Float:ObjZ, Float:FrX, Float:FrY, Float:FrZ)
{
	new Float:TGTDistance;

	TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));

	new Float:tmpX, Float:tmpY, Float:tmpZ;

	tmpX = FrX * TGTDistance + CamX;
	tmpY = FrY * TGTDistance + CamY;
	tmpZ = FrZ * TGTDistance + CamZ;

	return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}

static Float:GetPointAngleToPoint(Float:x2, Float:y2, Float:X, Float:Y)
{

	new Float:DX, Float:DY;
	new Float:angle;

	DX = floatabs(floatsub(x2,X));
	DY = floatabs(floatsub(y2,Y));

	if (DY == 0.0 || DX == 0.0)
	{
		if(DY == 0 && DX > 0) angle = 0.0;
		else if(DY == 0 && DX < 0) angle = 180.0;
		else if(DY > 0 && DX == 0) angle = 90.0;
		else if(DY < 0 && DX == 0) angle = 270.0;
		else if(DY == 0 && DX == 0) angle = 0.0;
	}
	else
	{
		angle = atan(DX/DY);

		if(X > x2 && Y <= y2) angle += 90.0;
		else if(X <= x2 && Y < y2) angle = floatsub(90.0, angle);
		else if(X < x2 && Y >= y2) angle -= 90.0;
		else if(X >= x2 && Y > y2) angle = floatsub(270.0, angle);
	}
  	return floatadd(angle, 90.0);
}

static GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:distance)
{
	x += (distance * floatsin(-angle, degrees));
	y += (distance * floatcos(-angle, degrees));
}

static IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
	new Float:camera_x,Float:camera_y,Float:camera_z,Float:vector_x,Float:vector_y,Float:vector_z;

	GetPlayerCameraPos(playerid, camera_x, camera_y, camera_z);
	GetPlayerCameraFrontVector(playerid, vector_x, vector_y, vector_z);

	new Float:vertical, Float:horizontal;

	switch (GetPlayerWeapon(playerid))
	{
		case 34,35,36: {
			if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, vector_x, vector_y, vector_z) < radius) return true;
			return false;
		}
		case 30,31: {vertical = 4.0; horizontal = -1.6;}
		case 33: {vertical = 2.7; horizontal = -1.0;}
		default: {vertical = 6.0; horizontal = -2.2;}
	}

	new Float:angle = GetPointAngleToPoint(0, 0, floatsqroot(vector_x*vector_x+vector_y*vector_y), vector_z) - 270.0;
	new Float:resize_x, Float:resize_y, Float:resize_z = floatsin(angle+vertical, degrees);
	GetXYInFrontOfPoint(resize_x, resize_y, GetPointAngleToPoint(0, 0, vector_x, vector_y)+horizontal, floatcos(angle+vertical, degrees));

	if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, resize_x, resize_y, resize_z) < radius) return true;
	return false;
}

static IsPlayerAimingAtPlayer(playerid, target)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(target, x, y, z);

	if(IsPlayerAimingAt(playerid, x, y, z-0.75, 0.25)) return true;
	if(IsPlayerAimingAt(playerid, x, y, z-0.25, 0.25)) return true;
	if(IsPlayerAimingAt(playerid, x, y, z+0.25, 0.25)) return true;
	if(IsPlayerAimingAt(playerid, x, y, z+0.75, 0.25)) return true;

	return false;
}
/*
 *****************************************************************************
*/
/*
 |COMMANDS|
*/
CMD:wand(playerid)
{
	if(playerWand[playerid][E_PLAYER_WAND_EQUIPPED])
		UnequipPlayerWand(playerid);
	else
		EquipPlayerWand(playerid);
	
	return 1;
}
CMD:in(playerid)
{
	SendClientMessageEx(playerid, -1, "%s", IsPlayerInAnyVehicle(playerid) ? ("está") : ("nop"));

	return 1;
}