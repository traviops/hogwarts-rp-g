/*
	Fader
		- Descrição.

		Versão: 1.0.0
		Última atualização: 00/00/00

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
		Renato "Misterix" Venancio)

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
	 * DEFINITIONS
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
	 * HOOKS
	 *
	|
*/
/*
 * DEFINITIONS
 ******************************************************************************
 */
//forward OnFadeScreenPlayerChanged(playerid, bool:fadeType, fromModule, fadeWaitingType);

const

	/// <summary>
	///	Definição das próximas funções que serão chamadas após o fim do fade executado.
	/// Em suma, o que o fade estará aguardando para executar, logo após sua conclusão.</summary>
	FADE_WAITING_NONE				= -1,
	FADE_WAITING_LOGIN_SCREEN		= 0,
	FADE_WAITING_LOBBY				= 1,
	FADE_WAITING_MENU_CHARACTER		= 2,
	FADE_WAITING_OUT_MENU_CHARACTER	= 3;

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined fader_OnGameModeInit
		fader_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo;
	/// </summary>

	ModuleInit("player/fader.pwn");

	return 1;
}

/*
 * MY CALLBACKS
 ******************************************************************************
 */
/// <summary>
/// Callback chamada ao fade ser concluído em um jogador específico.
/// Executa as funções definidas a serem seguidas após o término do fade.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <param name="fadeType">Tipo do fade.</param>
/// <param name="fromModule">Módulo que chamou executou o fade.</param>
/// <param name="fadeWaitingType">Conjunto de funções que serão executadas.</param>
/// <returns>Não retorna valores.</returns>
public OnFadeScreenPlayerChanged(playerid, fadeType, fromModule, fadeWaitingType)
{
	switch(fromModule)
	{
		case MODULE_LOGIN:
			FadeScreenCallFunctions(playerid, fadeType, fadeWaitingType);
	}
}

/*
 * HOOKS
 ******************************************************************************
 */
/// <summary>
/// Hook da função OnGameModeInit.</summary>
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit fader_OnGameModeInit
#if defined fader_OnGameModeInit
	forward fader_OnGameModeInit();
#endif