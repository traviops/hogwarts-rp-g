/*
	Arquivo:
		modules/server/mailer.pwn

	Descrição:
		- Este módulo é responsável pelo envio de emails.
		Desenvolvido por: NicK_.

	Última atualização:
		22/08/17

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
	 * MY CALLBACKS
	 *
	|
	 *
	 * FUNCTIONS
	 *
	|

	native SendEmail(nomerem[], de[], para[], titulo[], mensagem[], charset[] = "utf-8", type[]="text/html");
	native SendEmailSMTP(nomerem[], user_smtp[], senha_smtp[], para[], titulo[], mensagem[], host_smtp[]=SMTP_HOST, porta_smtp=SMTP_PORT, authtype_smtp[] = "PLAIN", charset[] = "utf-8", type[]="text/html");
*/
/*
 * INCLUDES
 ******************************************************************************
 */
#if !defined n_mail_include
	#define n_mail_include
#endif

/*
 * DEFINITONS
 ******************************************************************************
 */
forward Mail_HTTP(index, response_code, data[]);

/*
 * VARIABLES
 ******************************************************************************
 */
static nmail_http_request, m_mailmail[1024];

/*
 * MY CALLBACKS
 ******************************************************************************
 */
public Mail_HTTP(index, response_code, data[]) {
	nmail_http_request++;
	if(strlen(data) > 0)
		printf("[NMail] Script: %s", data);
	return 1;
}

/*
 * FUNCTIONS
 ******************************************************************************
 */
stock SendEmail(nomerem[], de[], para[], titulo[], mensagem[], charset[]="utf-8", type[]="text/html") {
	format(m_mailmail, sizeof(m_mailmail), "nomerem=%s&de=%s&para=%s&tit=%s&msg=%s&charset=%s&type=%s", nomerem, de, para, titulo, mensagem, charset, type);
	return HTTP(nmail_http_request, HTTP_POST, MAILER_URL, m_mailmail, "Mail_HTTP");
}

stock SendEmailSMTP(nomerem[], user_smtp[], senha_smtp[], para[], titulo[], mensagem[], host_smtp[]=SMTP_HOST, porta_smtp = SMTP_PORT, authtype_smtp[] = "PLAIN", charset[]="utf-8", type[]="text/html") {
	format(m_mailmail, sizeof(m_mailmail),"nomerem=%s&de=%s&senha=%s&para=%s&tit=%s&msg=%s&host=%s&porta=%i&auth=%s&charset=%s&type=%s", nomerem, user_smtp, senha_smtp, para, titulo, mensagem, host_smtp, porta_smtp, authtype_smtp, charset, type);
	return HTTP(nmail_http_request, HTTP_POST, ""#MAILER_URL"?autenticado=1", m_mailmail, "Mail_HTTP");
}