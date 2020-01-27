/*
	Arquivo:
		modules/core/macros.pwn

	Descrição:
		- Este arquivo é responsável por definir os macros utilizados.

	Última atualização:
		09/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		Renato "Misterix" Venancio)

	Esqueleto do código:
	|
	 *
	 * DEFINITIONS
	 *
	|
	 *
	 * NATIVE CALLBACKS
	 *
	|
	 *
	 * HOOKS
	 *
	|
*/
/*
 * DEFINITIONS
 *****************************************************************************
*/
/// <summary>
///	Macros.</summary>
stock stringFormat[4096];

#define SendClientMessageFormat(%0,%1,%2,%3) \
	format(stringFormat, sizeof(stringFormat), %2, %3) &&\
	SendClientMessage(%0, %1, stringFormat)

#define ShowPlayerDialogFormat(%0,%1,%2,%3,%4,%5,%6,%7) \
	format(stringFormat, sizeof(stringFormat), %4, %7) && \
	ShowPlayerDialog(%0, %1, %2, %3, stringFormat, %5, %6)

#define PlayerTextDrawSetStringFormat(%0,%1,%2,%3) \
	format(stringFormat, sizeof(stringFormat), %2, %3) && \
	PlayerTextDrawSetString(%0, PlayerText:%1, stringFormat)

/*
 * NATIVE CALLBACKS
 *****************************************************************************
*/
public OnGameModeInit()
{
	#if defined macros_OnGameModeInit
		macros_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicializa o módulo.
	/// </summary>

	ModuleInit("core/macros.pwn");

	return 1;
}

/*
 * HOOKS
 *****************************************************************************
*/
/// <summary>
/// Hook da callback OnGameModeInit.
/// </summary>
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit macros_OnGameModeInit
#if defined macros_OnGameModeInit
	forward macros_OnGameModeInit();
#endif