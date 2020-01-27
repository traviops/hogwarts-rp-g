/*
	Arquivo:
		modules/core/complements.pwn

	Descrição:
		- Este módulo é utilizado para declarar funções complementares de diferentes
		naturezas.

	Última atualização:
		11/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		João "JPedro" Pedro,
		Renato "Misterix" Venancio)

	Esqueleto do código:
	|
	 *
	 * NATIVE CALLBACKS
	 *
	|
	 *
	 * FUNCIONS
	 *
	|
	 *
	 * HOOKS
	 *
	|
*/
/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined complements_OnGameModeInit
		complements_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo;
	/// </summary>

	ModuleInit("core/complements.pwn");
	return 1;
}

/*
 * FUNCIONS
 ******************************************************************************
 */
/// <author>Toribio.</author>
/// <summary>
/// Converte um texto específico com acentos para ser utilizado em TextDraws ou
/// GameTexts.
/// </summary>
/// <param name="in">Texto.</param>
/// <returns>Texto convertido.</returns>
ConvertToGameText(const in[])
{
	new string[256],
		i;

	for(i = 0; in[i]; ++i)
	{
		string[i] = in[i];
		switch(string[i])
		{
			case 0xC0 .. 0xC3: string[i] -= 0x40;
			case 0xC7 .. 0xC9: string[i] -= 0x42;
			case 0xD2 .. 0xD5: string[i] -= 0x44;
			case 0xD9 .. 0xDC: string[i] -= 0x47;
			case 0xE0 .. 0xE3: string[i] -= 0x49;
			case 0xE7 .. 0xEF: string[i] -= 0x4B;
			case 0xF2 .. 0xF5: string[i] -= 0x4D;
			case 0xF9 .. 0xFC: string[i] -= 0x50;
			case 0xC4, 0xE4: string[i] = 0x83;
			case 0xC6, 0xE6: string[i] = 0x84;
			case 0xD6, 0xF6: string[i] = 0x91;
			case 0xD1, 0xF1: string[i] = 0xEC;
			case 0xDF: string[i] = 0x96;
			case 0xBF: string[i] = 0xAF;
		}
	}
	return string;
}

/// <summary>
/// Obtém e retorna o nome de um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Nome do jogador.</returns>
GetNameOfPlayer(playerid)
{
	static playerName[MAX_PLAYER_NAME];
	return (GetPlayerName(playerid, playerName, MAX_PLAYER_NAME), playerName);
}

/// <author>Bruno "Bruno13" Travi.</author>
/// <summary>
/// Valida se um nome específico é válido como nome de jogador.
/// </summary>
/// <param name="playerName">Nome.</param>
/// <returns>True se for, False se não.</returns>
IsValidPlayerName(playerName[])
{
	for(new i; i < strlen(playerName); i++)
	{
		switch(playerName[i])
		{
			case 'A'..'Z', 'a'..'z', '0'..'9', '_': continue;
			default: return false;
		}
	}	
	return true;
}

/// <author>
/// Bruno "Bruno13" Travi.
/// </author>
/// <summary>
/// Valida se um email específico é válido.
/// </summary>
/// <param name="email">Email.</param>
/// <returns>True se for, False se não.</returns>
IsValidEmail(const email[])
{
	new size = strlen(email);

	if(size < 7)
		return false;

	new atFinded,
		i;

	for(i = 0; i < size; i++)
	{
		switch(email[i])
		{
			case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '-': continue;
			default:
			{
				if(email[i] == '@')
				{
					atFinded++;
					continue;
				}

				return false;
			}
		}
	}

	return (atFinded == 1);
}

/// <author>Bruno "Bruno13" Travi.</author>
/// <summary>
/// Desativa os controles da skin de um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
stock FreezePlayer(playerid, bool:toggleControllable = true)
{
	if(toggleControllable)
		TogglePlayerControllable(playerid, true);

    ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 1, 1, 1, 0, 0, 1);
}

/// <author>Bruno "Bruno13" Travi.</author>
/// <summary>
/// Ativa os controles da skin de um jogador específico.
/// </summary>
/// <param name="playerid">ID do jogador.</param>
/// <returns>Não retorna valores.</returns>
stock UnfreezePlayer(playerid, bool:toggleControllable = false)
{
	ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 1, 1, 1);

	if(toggleControllable)
		TogglePlayerControllable(playerid, true);
}

/// <author>Bruno13.</author>
/// <summary>
/// Converte um inteiro em string retornando a mesma.
/// </summary>
/// <param name="value">Valor inteiro.</param>
/// <returns>String convertida.</returns>
ConvertIntToString(value)
{
	new result[12];
	return ((format(result, sizeof(result), "%d", value)), result);
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
#define OnGameModeInit complements_OnGameModeInit
#if defined complements_OnGameModeInit
	forward complements_OnGameModeInit();
#endif