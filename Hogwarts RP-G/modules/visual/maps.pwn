/*
	Arquivo:
		modules/visual/maps.pwn

	Descrição:
		- Este módulo é responsável por carregar todos os mapas.

	Última atualização:
		08/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
		Renato "Misterix" Venancio)

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
	 * VARIABLES
	 *
	|
	 *
	 * NATIVE CALLBACKS
	 *
	|
	 *
	 * COMMANDS
	 *
	|
	 *
	 * HOOKS
	 *
	|
*/
/*
 * INCLUDES
 *****************************************************************************
*/
#include <zcmd>

/*
 * DEFINITIONS
 *****************************************************************************
*/
/// <summary>
///	Definição de renderizamento do streamer.</summary>
#if defined STREAMER_OBJECT_SD
 	#undef STREAMER_OBJECT_SD
#endif
    
#define STREAMER_OBJECT_SD 100.0

/*
 * VARIABLES
 *****************************************************************************
*/
static
	/// <summary>
	///	Variável para armazenar a gangzone de bloqueio do mapa.</summary>
	mapBlock;

/*
 * NATIVE CALLBACKS
 *****************************************************************************
*/
public OnGameModeInit()
{
	#if defined maps_OnGameModeInit
		maps_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		> inicia o módulo;
	///		> carrega todos os mapas;
	///		> cria gangzone de bloqueio do mapa.
	/// </summary>

	ModuleInit("visual/maps.pwn");

	new
		tempObjectID;

	//#pragma unused tempObjectID
	
	#include "..\maps\ext\forbidden_forest_native.pwn"
	#include "..\maps\int\player_lobby.pwn"
	#include "..\maps\int\castle_interior.pwn"
	#include "..\maps\int\bar_three_broomsticks.pwn"
	//#include "..\maps\ext\quidditch_native_textured.pwn"

	//#include "..\..\..\MAPS\EXT\forbidden_forest_streamer.pwn"
	/*#include "..\..\..\MAPS\EXT\hogwarts_native.pwn"
	#include "..\..\..\MAPS\EXT\hogwarts_streamer_textured.pwn"
	#include "..\..\..\MAPS\EXT\path_to_forbidden_forest_and_hagrid_house_streamer.pwn"
	#include "..\..\..\MAPS\EXT\platform_9_3-4_textured.pwn"*/
	//#include "..\..\..\MAPS\EXT\quidditch_native_textured.pwn"

	mapBlock = GangZoneCreate(-10000.0, -11000.0, 10000.0, 11000.0);

	return 1;
}

public OnPlayerConnect(playerid)
{
	#if defined maps_OnPlayerConnect
		maps_OnPlayerConnect(playerid);
	#endif
	/// <summary>
	/// Nesta callback:
	///		> mostra a gangzone de bloqueio do mapa ao jogador.
	/// </summary>

	GangZoneShowForPlayer(playerid, mapBlock, 0x000000FF);
}

/*
 * COMMANDS
 *****************************************************************************
*/
/// <summary>
/// Comando temporário.
/// </summary>
CMD:pos(playerid)//temp
{
	SetPlayerPos(playerid, -393.522, -7077.949, 31.141+10.0);
	SetPlayerInterior(playerid, 0);
	SetPlayerWeather(playerid, 52);
	return 1;
}

/// <summary>
/// Comando temporário para ir até o castelo.
/// </summary>
CMD:castle(playerid)//temp
{
	SetPlayerPos(playerid, -6985.7222, -618.8849, 22.7268);
	SetPlayerInterior(playerid, 1);
	return 1;
}

/*
 * HOOKS
 *****************************************************************************
*/
/// <summary> 
///	Hook da callback OnGameModeInit.</summary>
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit maps_OnGameModeInit
#if defined maps_OnGameModeInit
	forward maps_OnGameModeInit();
#endif

/// <summary> 
///	Hook da callback OnPlayerConnect.</summary>
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect maps_OnPlayerConnect
#if defined maps_OnPlayerConnect
	forward maps_OnPlayerConnect(playerid);
#endif