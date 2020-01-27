#include <a_samp>
#include <zcmd>

#define fileHour "hour.cfg"

main()
{
    SetGameModeText("Bar tests");
}

public OnGameModeInit()
{
    new File:handle = fopen(fileHour, io_read),
        hour[3];

    if(handle)
    {
        if(fexist(fileHour))
        {
            while(fread(handle, hour))
                SetWorldTime(strval(hour));
        }
        
        fclose(handle);
    }
    
    return 1;
}

public OnPlayerConnect(playerid)
{
    SetSpawnInfo(playerid, 0, 171, 501.980987,-69.150199,998.757812, -90.0, 0, 0, 0, 0, 0, 0);

    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;

    SetPlayerInterior(playerid, 11);
    SetPlayerSkin(playerid, 171);
    
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;

    SpawnPlayer(playerid);

	return false;
}


CMD:kill(playerid) return SetPlayerHealth(playerid, 0.0);

CMD:amx(playerid)
{
	SendRconCommand("unloadfs sounds");
 	SendRconCommand("loadfs sounds");

	return 1;
}
