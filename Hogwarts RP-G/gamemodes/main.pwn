/*
		  __   __			  __  ___  __	   __   __	  /  __
	|__| /  \ / _` |  |  /\  |__)  |  /__`    |__) |__)  /  / _`
	|  | \__/ \__> |/\| /~~\ |  \  |  .__/    |  \ |    /   \__>

	Arquivo:
		main.pwn

	Descrição:
		- Este arquivo é responsável por carregar todos os módulos.

	Última atualização:
		03/08/17

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
	 * LIBRARIES
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
	 * INPUT METHOD
	 *
	|
*/
#include <a_samp>
#include <a_http>
#include <crashdetect>

/*
 * DEFINITIONS
 ******************************************************************************
 */

/// <summary> 
///	Definição Copyright e desenvolvedores.</summary>
new const
	hogsDevelopers[] = {
		"\tBruno \"Bruno13\" Travi,\n\
		\tJoão \"BarbaNegra\" Paulo,\n\
		\tJoão \"JPedro\" Pedro,\n\
		\tJoão \"Vithinn\" Vitor,\n\
		\tRenato \"Misterix\" Venancio."
	};

/// <summary> 
///	Definições do modo.</summary>
#define MODE_NAME "Hogwarts"
#define MODE_TYPE "RP/G"
#define GetModeName	#MODE_NAME " " #MODE_TYPE

/// <summary> 
///	Definições da versão.</summary>
#define VERSION_MAJOR			0
#define VERSION_MINOR			0
#define VERSION_BUILD			1
#define VERSION_RELEASE			"alfa"
#define VERSION_RELEASE_ABBREV	"A"
#define GetVersion				#VERSION_MAJOR "." #VERSION_MINOR "." #VERSION_BUILD " " #VERSION_RELEASE

/// <summary>
/// Definições de email da include 'mailer'.</summary>
#define MAILER_URL		"ip.mail.sender/index.php"
#define MAILER_SENDER	"contact@gmail.com"
#define MAILER_PASS		"password"
#define SMTP_HOST		"smtp.gmail.com"
#define SMTP_PORT		587

/// <summary>
///	Definição do máximo de jogadores.</summary>
#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS	100

/*
 * VARIABLES
 ******************************************************************************
 */

/*
 * LIBRARIES
 ******************************************************************************
 */
#include <filemanager>
#include <streamer>
#include <a_mysql>
#include <mailer>
#include <zcmd>
#include <YSI\y_timers>
#include <hogfader>

/// <summary>
///	Necessita ficar no topo.</summary>
#include <../../modules/core/complements.pwn>
#include <../../modules/core/macros.pwn>
#include <../../modules/core/colors.pwn>
#include <../../modules/core/definitions.pwn>
#include <../../modules/core/textdrawcontrol.pwn>
#include <../../modules/core/fixes.pwn>

/// <summary>
///	Visual modules.</summary>
#include <../../modules/visual/maps.pwn>

/// <summary>
/// Server modules.</summary>
#include <../../modules/server/texts.pwn>
#include <../../modules/server/mailmessages.pwn>

/// <summary>
///	Data modules.</summary>
#include <../../modules/data/connection.pwn>
#include <../../modules/data/player.pwn>

/// <summary>
///	Player modules.</summary>
#include <../../modules/player/controls.pwn>
#include <../../modules/player/fader.pwn>
#include <../../modules/player/spawn.pwn>
#include <../../modules/player/character.pwn>
#include <../../modules/player/login.pwn>

/// <summary>
///	Core modules.</summary>
#include <../../modules/core/textfix.pwn>
#include <../../modules/core/modulecontrol.pwn>

/*
 * INPUT METHOD
 ******************************************************************************
 */
main()
{
	SendRconCommand("hostname " GetModeName);
	SetGameModeText(MODE_TYPE);

	printf("\n  > %s v%s", GetModeName, GetVersion);
	printf("  > Desenvolvedores\n%s", hogsDevelopers);
	printf("  > %d módulo%s carregado%s", modulesLoaded, (modulesLoaded == 1) ? ("") : ("s"), (modulesLoaded == 1) ? ("") : ("s"));
	printf("  > %d textdraws globais criadas de %d", GetTotalGlobalTextDraws(), LIMIT_GLOBAL_TEXTDRAWS);
	printf("__________________________________________\n");
}