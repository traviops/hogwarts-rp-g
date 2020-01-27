/*
	Arquivo:
		modules/server/mailmessages.pwn

	Descrição:
		- Este módulo é responsável pelas mensagens de email estruturadas em HTML.

	Última atualização:
		23/08/17

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
	 * FUNCTIONS
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
new const

	/// <summary>
	///	Variável para armazenar o formato da mensagem de email para código de verificação.</summary>
	messageRegisterCode[] =
		"<!DOCTYPE html>\
		<html lang=\"pt-BR\">\
			<body>\
				<h1>Código de verificação</h1>\
				<p>%s %s, para concluir seu registro no " GetModeName " insira o código abaixo.<p>\
				<p>Código de verificação: %d.</p>\
			</body>\
		</html>",

	/// <summary>
	///	Variável para armazenar o formato da mensagem de email para código de verificação para recuperar senha.</summary>
	messagePasswordRecoverCode[] =
		"<!DOCTYPE html>\
		<html lang=\"pt-BR\">\
			<body>\
				<h1>Código de verificação</h1>\
				<p>%s %s, você solicitou uma recuperação de senha no " GetModeName ", insira o código abaixo para redefinir a mesma.<p>\
				<p>Código de verificação: %d.</p>\
			</body>\
		</html>";

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined mailmessages_OnGameModeInit
		mailmessages_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo.
	/// </summary>

	ModuleInit("server/mailmessages.pwn");

	return 1;
}

/*
 * FUNCIONS
 ******************************************************************************
 */
/// <summary>
/// Formata a mensagem do código de ativação que será enviada por email com um
/// nome e um código específico.
/// </summary>
/// <param name="playerName">Nome do jogador.</param>
/// <param name="code">Código.</param>
/// <returns>Mensagem formatada.</returns>
MailRegisterCode(const playerName[], code)
{
	new output[(198 - 6) + 10 + MAX_PLAYER_NAME + 4];

	format(output, sizeof(output), messageRegisterCode, GetGreetings(), playerName, code);

	return output;
}

/// <summary>
/// Formata a mensagem do código de verificação para recuperar senha que será
/// enviada por email com um nome e um código específico.
/// </summary>
/// <param name="playerName">Nome do jogador.</param>
/// <param name="code">Código.</param>
/// <returns>Mensagem formatada.</returns>
MailRecoverPasswordCode(const playerName[], code)
{
	new output[(235 - 6) + 10 + MAX_PLAYER_NAME + 4 + 1];

	format(output, sizeof(output), messagePasswordRecoverCode, GetGreetings(), playerName, code);

	return output;
}

/// <summary>
/// Obtém as saudações conforme a hora atual.
/// </summary>
/// <returns>Saudações em string.</returns>
GetGreetings()
{
	new hour,
		mmss,
		greetings[10];

	gettime(hour, mmss, mmss);

	if (6 < hour < 12)
		greetings = "Bom dia";
	else if (12 <= hour < 18)
		greetings = "Boa tarde";
	else
		greetings = "Boa noite";

	return greetings;
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
#define OnGameModeInit mailmessages_OnGameModeInit
#if defined mailmessages_OnGameModeInit
	forward mailmessages_OnGameModeInit();
#endif