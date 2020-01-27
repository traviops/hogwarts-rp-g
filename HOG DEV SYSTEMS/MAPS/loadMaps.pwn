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
*/
/*
 * DEFINITIONS
 *****************************************************************************
*/
#if defined STREAMER_OBJECT_SD
 	#undef STREAMER_OBJECT_SD
#endif
    
#define STREAMER_OBJECT_SD 100.0
/*
 * VARIABLES
 *****************************************************************************
*/
static

	tempObjectID;

#pragma unused tempObjectID
/*
 *****************************************************************************
*/
/*
 |NATIVE CALLBACKS|
*/
hook OnGameModeInit()
{
	#include "..\..\..\MAPS\EXT\forbidden_forest_native.pwn"
	//#include "..\..\..\MAPS\EXT\forbidden_forest_streamer.pwn"
	/*#include "..\..\..\MAPS\EXT\hogwarts_native.pwn"
	#include "..\..\..\MAPS\EXT\hogwarts_streamer_textured.pwn"
	#include "..\..\..\MAPS\EXT\path_to_forbidden_forest_and_hagrid_house_streamer.pwn"
	#include "..\..\..\MAPS\EXT\platform_9_3-4_textured.pwn"*/
	//#include "..\..\..\MAPS\EXT\quidditch_native_textured.pwn"

	ModuleInit("visual/maps.pwn");

	return 1;
}