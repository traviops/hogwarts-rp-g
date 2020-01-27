#include <a_samp>
#include <zcmd>

main(){}

new bool:whileConnect[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
    //SetSpawnInfo(playerid, 0, 171, 501.980987,-69.150199,998.757812, -90.0, 22, 100, 0, 0, 0, 0);
    
    //LoginScreen_OnPlayerConnect(playerid);
    whileConnect[playerid] = true;
    if(whileConnect[playerid] == true) {
        TogglePlayerSpectating(playerid, 1);
    }

    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;

    SetPlayerInterior(playerid, 11);
    
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;

    //LoginScreen_OnPlayerRequestClass(playerid);
    if(whileConnect[playerid] == true) {
        TogglePlayerSpectating(playerid, 1);

        SendClientMessage(playerid, -1, "const message[]");
        return 1;
    }
    /*whileConnect[playerid] = false;
    TogglePlayerSpectating(playerid, 0);
    OnPlayerRequestClass(playerid, 0);*/

	//SendClientMessage(playerid, -1, "RequestClass"); - debug
	
 	//SpawnPlayer(playerid);
 	SetSpawnInfo(playerid, 0, 171, 501.980987,-69.150199,998.757812, -90.0, 22, 100, 0, 0, 0, 0);
    //SpawnPlayer(playerid);
	return false;
}
/*
public OnPlayerRequestSpawn(playerid)
{
    SendClientMessage(playerid, -1, "RequestSpawn");
    SpawnPlayer(playerid);
    
    return false;
}*/


CMD:kill(playerid) return SetPlayerHealth(playerid, 0.0);

CMD:amx(playerid)
{
	SendRconCommand("unloadfs sounds");
 	SendRconCommand("loadfs sounds");

	return 1;
}
