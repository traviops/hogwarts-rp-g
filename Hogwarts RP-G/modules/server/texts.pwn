/*
	Arquivo:
		modules/server/texts.pwn

	Descrição:
		- Este módulo é responsável pela definição de todos os textos
		utilizados, em mensagens e dialogs.

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
/// <summary> 
///	Caracteres com cores utilizados em mensagens e dialogs.</summary>
#define WARNING_CHAR 		"{E84F33}<!>{BCD2EE} "
#define MESSAGE_ALERT_CHAR	"<!>{FFFFFF} "

new const

	/// <summary> 
	///	Textos utilizados nas mensagens.</summary>
	MESSAGE_ERROR_LOAD_SCENARIO[]		= MESSAGE_ALERT_CHAR "Não foi possível carregar o cenário.",
	MESSAGE_REGISTER_COMPLETED[]		= MESSAGE_ALERT_CHAR "Conta registrada com sucesso. Seja bem-vindo ao " GetModeName "!",
	MESSAGE_LOGIN_FAIL[]				= MESSAGE_ALERT_CHAR "Senha incorreta! Tentativa %d/%d.",
	MESSAGE_LOGIN_FAIL_KICK[]			= MESSAGE_ALERT_CHAR "Você errou a senha %d vezes e foi kickado!",
	MESSAGE_LOGIN_SUCCESSFUL[]			= MESSAGE_ALERT_CHAR "Bem-vindo de volta %s, seu último login foi dia %s.",
	MESSAGE_LOGIN_ERROR[]				= MESSAGE_ALERT_CHAR "Ops...algo deu errado, não foi possível carregar seus dados da database! Relogue e tente novamente.",
	MESSAGE_CURSOR_HIDED_IN_LOGIN[]		= MESSAGE_ALERT_CHAR "Você desativou o cursor, para ativá-lo tecle ~k~~GROUP_CONTROL_BWD~.",

	message_error_select_feature[]		= MESSAGE_ALERT_CHAR "Ops...houve um erro ao selecionar esta característica, tente novamente!"

;

new

	/// <summary> 
	///	Textos utilizados nas textdraws.</summary>
	text_character_new_char[]			= "Novo personagem",
	text_character_create_char[]		= "Criar novo personagem",
	text_character_last_acess[]			= "Acessado por ultimo às %02d:%02d de %02d/%02d/%d",
	text_character_blocked_char[]		= "BLOQUEADO",
	text_character_slot_unavailable[]	= "Este slot não está disponível.",
	text_char_feature_default_name[]	= "Inserir nome",

	/// <summary> 
	///	Textos utilizados nos dialogs do módulo 'player/login'.</summary>
	dialog_temrs_caption[]				= "Termos " GetModeName,
	dialog_temrs_info[]					= "Termos do servidor:\n\n\t1. ...\n\n\t2. ...",

	dialog_about_server_caption[]		= "Sobre " GetModeName,
	dialog_about_server_info[]				= GetModeName " é um modo de jogo onde...",

	dialog_insert_password_caption[] 	= "Inserir senha",
	dlg_insert_password_regist_info[] 	= "Insira uma senha com no mínimo 3 e no máximo %d caracteres.\n\n{E84F33}OBS{BCD2EE}: O " GetModeName " utiliza criptografia hash em senhas de ponta-a-ponta,\nde maneira que nem mesmo os desenvolvedores terão acesso a sua senha.",
	dlg_insert_password_login_info[] 	= "Insira sua senha abaixo. Caso errar mais que %d vezes, será kickado.",

	dialog_insert_email_caption[] 		= "Inserir email",
	dialog_register_email_info[] 		= "Insira um email válido, ele será vinculado a sua conta para medidas de\nsegurança e demais funções opcionais. Você poderá alterá-lo futuramente.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.",

	dialog_code_verification_info[] 	= "Inserir código de verificação",
	dialog_register_code_info[]			= "Insira abaixo o código de verificação recebido para concluir o registro.\n\n{E84F33}OBS¹{BCD2EE}: Caso não tenha recebido o email, clique em voltar e selecione a\nopção 'reenviar' para enviar novamente.\n\n{E84F33}OBS²{BCD2EE}: Se digitou o email errado, clique em voltar e selecione a opção\n'email' para alterar.",

	dlg_wait_invite_email_caption[]		= "Aguarde para reenviar email",
	dialog_wait_invite_email_info[]		= "Aguarde para enviar um email novamente. Normalmente\nos emails são enviados em menos de 1 minuto.\n\nCaso não o encontre em sua caixa de entrada, verifique\na caixa de spam!",
	dialog_email_resent_caption[]		= "Email reenviado",
	dialog_email_resent_info[]			= "Foi enviado um email com um novo código de verificação!\n\nCaso não o encontre em sua caixa de entrada, verifique a\ncaixa de spam!",

	dlg_wait_change_email_caption[]		= "Aguarde para alterar email",
	dialog_wait_change_email_info[]		= "Aguarde para alterar seu email novamente. Um email já foi enviado\npara {E84F33}%s{BCD2EE}, cheque sua caixa de entrada e spam.",

	dialog_change_email_caption[]		= "Alterar email",
	dialog_change_email_regist_info[]	= "Insira abaixo um novo email válido que você tenha acesso.\n\n{E84F33}OBS{BCD2EE}: Somente se você autorizar administradores poderão visualizar seu email.",

	dlg_change_name_sing_in_caption[]	= "Alterar nome",
	dlg_chg_name_sign_in_size_info[]	= WARNING_CHAR "Você deve inserir algum nome de 3 a 20 caracteres.\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.",
	dlg_chg_name_sign_in_invld_info[] 	= WARNING_CHAR "Nome inválido! Caracteres aceitos: A a Z, 0 a 9 e _(underline).\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.",
	dlg_chg_name_sing_in_equal_info[]	= WARNING_CHAR "Você já está utilizando esse nome!\n\nNome atual: {E84F33}%s{BCD2EE}\n\nDeseja registrar sua conta com outro nome? Insira abaixo, de 3 a 20 caracteres.\nNa próxima vez que se conectar, deverá utilizar o nome escolhido.",

	dlg_change_name_login_caption[]		= "Logar em outra conta",
	dlg_chg_name_login_size_info[]		= WARNING_CHAR "Nome de usuário inválido! O nome contém de\n3 a 20 caracteres.\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.",
	dlg_chg_name_login_invalid_info[]	= WARNING_CHAR "Nome de usuário inválido! O nome contém caracteres inválidos.\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.",
	dlg_chg_name_login_equal_info[] 	= WARNING_CHAR "Você já está utilizando esse nome usuário!\n\nConta de usuário atual: {E84F33}%s{BCD2EE}\n\nDeseja fazer login em outra conta? Insira abaixo\no usuário da conta que deseja logar.",

	dlg_chg_pass_sign_in_size_info[]	= WARNING_CHAR "Senha inválida! A senha deve conter entre 3 a %d caracteres.\n\n{E84F33}OBS{BCD2EE}: O " GetModeName " utiliza criptografia hash em senhas de ponta-a-ponta,\nde maneira que nem mesmo os desenvolvedores terão acesso a sua senha.",
	dlg_chg_pass_login_size_info[] 		= WARNING_CHAR "Senha inválida! As senhas possuem no mínimo 3 caracteres.\n\nInsira sua senha abaixo. Caso errar mais que %d vezes, será kickado.",

	/// <summary> 
	///	Textos dos botões dos dialogs.</summary>
	dialog_button_off[]			= "",
	dialog_button_continue[]	= "Continuar",
	dialog_button_confirm[]		= "Confirmar",
	dialog_button_change[]		= "Alterar",
	dialog_button_close[]		= "Fechar",
	dialog_button_back[]		= "Voltar"

;

/*
 * NATIVE CALLBACKS
 ******************************************************************************
 */
public OnGameModeInit()
{
	#if defined texts_OnGameModeInit
		texts_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo.
	/// </summary>

	ModuleInit("server/texts.pwn");
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
#define OnGameModeInit texts_OnGameModeInit
#if defined texts_OnGameModeInit
	forward texts_OnGameModeInit();
#endif