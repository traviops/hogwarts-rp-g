#include <a_samp>
#include <zcmd>
#include <streamer>
#include <fader>
/*----------------------------------------------------------------------------*/
#define call:%1(%2) forward %1(%2); public %1(%2)
/*----------------------------------------------------------------------------*/
enum E_CLOAK_DATA
{
	bool:e_CLOAK_USING,
	bool:e_CLOAK_HAVE,
	Float:e_CLOAK_POSITION[3]
}
enum E_EFFECT_DATA
{
	e_EFFECT_OBJECT_ID,
	Float:e_EFFECT_POSITION[3]
}
/*
	{VARIABLES}
*/
static
	Text:textCover,

	cloakPlayer[MAX_PLAYERS][E_CLOAK_DATA],
	cloakEffect[MAX_PLAYERS][E_EFFECT_DATA];
/*----------------------------------------------------------------------------*/
/*
	{CALLBACKS}
*/
public OnFilterScriptInit()
{
    textCover = TextDrawCreate(-413.588134, -514.083312, "");
	TextDrawLetterSize(textCover, 0.000000, 0.000000);
	TextDrawTextSize(textCover, 1840.117309, 1635.833740);
	TextDrawAlignment(textCover, 1);
	TextDrawColor(textCover, -196);
	TextDrawSetShadow(textCover, 0);
	TextDrawSetOutline(textCover, 0);
	TextDrawBackgroundColor(textCover, 0);
	TextDrawFont(textCover, 5);
	TextDrawSetProportional(textCover, 1);
	TextDrawSetShadow(textCover, 0);
	TextDrawSetPreviewModel(textCover, 2897);
	TextDrawSetPreviewRot(textCover, 270.000000, 360.000000, 0.000000, 1.000000);

	print("\n-------------------------------------------");
	print("      [HOG] Invisibility Cloak loaded");
	print("-------------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
    cloakPlayer[playerid][e_CLOAK_USING] = false;
    
	return 1;
}

public OnPlayerSpawn(playerid)
{
    LoadPlayerAnimations(playerid);
    ResetPlayerAttachedObjects(playerid);
    
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(cloakPlayer[playerid][e_CLOAK_USING])
	{
    	return 0;//if(!logged[playerid] == false) return 0;
	}

	return 1;
}
/*----------------------------------------------------------------------------*/
/*
	{MY CALLBACKS}
	                */
call:WearCover(playerid, aux)
{
	if(aux == 0)
	{
		fadeIn(playerid, 1000, 0x000000FF);
		SetTimerEx("WearCover", 1100, false, "ii", playerid, 1);
		return;
	}
	if(aux == 1)
	{
	    GetPlayerPos(playerid,
			cloakPlayer[playerid][e_CLOAK_POSITION][0],
			cloakPlayer[playerid][e_CLOAK_POSITION][1],
			cloakPlayer[playerid][e_CLOAK_POSITION][2]);
		
	    //SetPlayerPos(playerid, 0,0,3.1172);
	    SetPlayerPos(playerid,
			cloakPlayer[playerid][e_CLOAK_POSITION][0],
			cloakPlayer[playerid][e_CLOAK_POSITION][1],
			cloakPlayer[playerid][e_CLOAK_POSITION][2]-2.0);

		TogglePlayerControllable(playerid, false);
	    
		cloakPlayer[playerid][e_CLOAK_USING] = true;

		//CallRemoteFunction("OnPlayerUpdate", "i", playerid);
	
	    RemovePlayerAttachedObject(playerid, 0);
	    
		SetTimerEx("WearCover", 3000, false, "ii", playerid, -1);
		return;
	}
	//ClearAnimations(playerid);
    //ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 1, 1, 1);
    ///ApplyAnimation(playerid, "BOMBER", "BOM_Plant_2Idle", 4.1, 0, 1, 1, 0, 1, 1);
    //ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 1, 0, 1);

	//SetPlayerAttachedObject(playerid, 0, 18741, 1, -1.244404, 0.177235, -1.678839, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000); //efeito capa
	SetPlayerPos(playerid,
			cloakPlayer[playerid][e_CLOAK_POSITION][0],
			cloakPlayer[playerid][e_CLOAK_POSITION][1],
			cloakPlayer[playerid][e_CLOAK_POSITION][2]);

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_2Idle", 4.1, 0, 1, 1, 0, 1, 1);
	
    TogglePlayerControllable(playerid, true);
	
	//TextDrawShowForPlayer(playerid, textCover);
	fadeOut(playerid, 1000, 0x000000FF);
	
	cloakEffect[playerid][e_EFFECT_POSITION][0] = cloakEffect[playerid][e_EFFECT_POSITION][1] = cloakEffect[playerid][e_EFFECT_POSITION][2] = 0.0;
	
	SetTimerEx("EffectCloak_Create", 600, false, "i", playerid);
	
	DeletePVar(playerid, "wearingCover");
}
call:EffectCloak_Create(playerid)
{
	if(!cloakPlayer[playerid][e_CLOAK_USING])
	{
	    if(IsValidDynamicObject(cloakEffect[playerid][e_EFFECT_OBJECT_ID])) SetTimerEx("EffectCloak_Destroy", 2500, false, "i", cloakEffect[playerid][e_EFFECT_OBJECT_ID]);

	    return;
	}
	
	//static Float:pos[3];
	
	if(!IsPlayerInRangeOfPoint(playerid, 0.5,
		cloakEffect[playerid][e_EFFECT_POSITION][0],
		cloakEffect[playerid][e_EFFECT_POSITION][1],
		cloakEffect[playerid][e_EFFECT_POSITION][2]))
	{
		if(IsValidDynamicObject(cloakEffect[playerid][e_EFFECT_OBJECT_ID])) SetTimerEx("EffectCloak_Destroy", 2500, false, "i", cloakEffect[playerid][e_EFFECT_OBJECT_ID]);

        GetPlayerPos(playerid,
			cloakEffect[playerid][e_EFFECT_POSITION][0],
			cloakEffect[playerid][e_EFFECT_POSITION][1],
			cloakEffect[playerid][e_EFFECT_POSITION][2]);
        
    	cloakEffect[playerid][e_EFFECT_OBJECT_ID] = CreateDynamicObject(18741,
			cloakEffect[playerid][e_EFFECT_POSITION][0],
			cloakEffect[playerid][e_EFFECT_POSITION][1],
			cloakEffect[playerid][e_EFFECT_POSITION][2]-2.6, 0.0,0.0,0.0);
				
		static i, players;
		
		players = GetPlayerPoolSize();
		
		for(i = 0; i <= players; i++)
		{
		    if(IsPlayerInRangeOfPoint(i, 15.0,
				cloakEffect[playerid][e_EFFECT_POSITION][0],
				cloakEffect[playerid][e_EFFECT_POSITION][1],
				cloakEffect[playerid][e_EFFECT_POSITION][2]))
			{
			Streamer_UpdateEx(i,
				cloakEffect[playerid][e_EFFECT_POSITION][0],
				cloakEffect[playerid][e_EFFECT_POSITION][1],
				cloakEffect[playerid][e_EFFECT_POSITION][2]-2.6);
			}
		}
	}
    
    SetTimerEx("EffectCloak_Create", 600, false, "i", playerid);
}
call:EffectCloak_Destroy(objectid)
{
    DestroyDynamicObject(objectid);
}
call:RemoveAttach(playerid)
{
    RemovePlayerAttachedObject(playerid, 0);
}
call:PlayAudioCloth(playerid)
{
    PlayerPlaySound(playerid, 20802, 0,0,0);
}
/*----------------------------------------------------------------------------*/
/*
	{COMPLEMENTS}
					*/
LoadPlayerAnimations(playerid)
{
    ApplyAnimation(playerid, "BOMBER", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
}
ResetPlayerAttachedObjects(playerid)
{
	static i;
	
	for(i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
		if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
}
/*----------------------------------------------------------------------------*/
/*
	{COMMANDS}
*/
CMD:capa(playerid)
{
	if(GetPVarInt(playerid, "wearingCover") || cloakPlayer[playerid][e_CLOAK_HAVE] || cloakPlayer[playerid][e_CLOAK_USING]) return 1;
	
	cloakPlayer[playerid][e_CLOAK_HAVE] = true;
    cloakPlayer[playerid][e_CLOAK_USING] = false;
	SetPlayerAttachedObject(playerid,0,19944,5,0.304000,0.037999,0.000000,-114.299964,0.000000,0.800000,0.472000,0.405999,0.193000); //capa

	return 1;
}
CMD:use(playerid)
{
	if(GetPVarInt(playerid, "wearingCover")) return 1;
	
    if(cloakPlayer[playerid][e_CLOAK_USING])
	{
	    cloakPlayer[playerid][e_CLOAK_USING] = false;
	    RemovePlayerAttachedObject(playerid, 0);
		SetPlayerAttachedObject(playerid,0,19944,5,0.304000,0.037999,0.000000,-114.299964,0.000000,0.800000,0.472000,0.405999,0.193000); //capa

        TextDrawHideForPlayer(playerid, textCover);
		return 1;
	}
	
	if(cloakPlayer[playerid][e_CLOAK_HAVE])
	{
	    SetPVarInt(playerid, "wearingCover", true);
	    
	    //ApplyAnimation(playerid, "BOMBER", "BOM_Plant",      4.1, 0, 1, 1, 0, 3400, 1);
	    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 3400, 1);
	    //ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 1, 0, 1);
	    
	    SetTimerEx("PlayAudioCloth", 400, false, "i", playerid);
	    SetTimerEx("WearCover", 1200/*2300*/, false, "ii", playerid, 0);
	    //SetTimerEx("RemoveAttach", 3400, false, "i", playerid);
	}

	return 1;
}

CMD:skin(playerid) return SetPlayerSkin(playerid, 171);
/*CMD:teste(playerid)
{
    static Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	CreateDynamicObject(18741, pos[0], pos[1], pos[2]-2.6, 0.0,0.0,0.0);
	Streamer_UpdateEx(playerid, pos[0], pos[1], pos[2]-2.6);
	
	return 1;
}*/
