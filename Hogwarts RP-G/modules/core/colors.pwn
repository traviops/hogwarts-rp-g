/*
	Arquivo:
		modules/core/colors.pwn

	Descrição:
		- Este módulo é responsável pela definição de todas cores utilizadas.

	Última atualização:
		24/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
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
 ******************************************************************************
 */
stock const

	/// <summary>
	///	Definição das cores.</summary>
	COLOR_DEFAULT	=	0xA9C4E4AA,
	COLOR_RED		=	0xE84F33AA,
	COLOR_GREEN		=	0x9ACD32AA,
	COLOR_YELLOW	=	0xFCD440AA;

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined colors_OnGameModeInit
		colors_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo;
	/// </summary>
	
	ModuleInit("core/colors.pwn");
	return 1;
}

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
#define OnGameModeInit colors_OnGameModeInit
#if defined colors_OnGameModeInit
	forward colors_OnGameModeInit();
#endif