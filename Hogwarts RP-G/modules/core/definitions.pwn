/*
	Arquivo:
		modules/core/definitions.pwn

	Descrição:
		- Este módulo é responsável por declarar algumas definições utilizadas
		em outros módulos.

	Última atualização:
		02/01/18

	Copyright (C) 2017 Hogwarts RP/G
		(Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
		João "JPedro" Vithinn,
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
 ******************************************************************************
 */

/*
 * DEFINITIONS
 ******************************************************************************
 */
const

	INVALID_MODULE_ID	= -1,
	MODULE_LOGIN		= 0,
	MODULE_CHARACTER	= 1;
/*
 * ENUMERATORS
 ******************************************************************************
 */

/*
 * VARIABLES
 ******************************************************************************
 */

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined definitions_OnGameModeInit
		definitions_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicializa o módulo;
	/// </summary>

	ModuleInit("core/definitions.pwn");

	return 1;
}

/*
 * MY CALLBACKS
 ******************************************************************************
 */

/*
 * FUNCTIONS
 ******************************************************************************
 */

/*
 * COMMANDS
 ******************************************************************************
 */

/*
 * HOOKS
 ******************************************************************************
 */
/// <summary>
/// Hook da callback OnGameModeInit.
/// </summary>
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit definitions_OnGameModeInit
#if defined definitions_OnGameModeInit
	forward definitions_OnGameModeInit();
#endif