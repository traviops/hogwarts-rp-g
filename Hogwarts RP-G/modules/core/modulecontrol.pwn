/*
	Arquivo:
		modules/core/modulecontrol.pwn

	Descrição:
		- Este arquivo é responsável por fazer o controle dos módulos carregados.

	Última atualização:
		08/08/17

	Copyright (C) 2017 Hogwarts RP/G
		(Adejair "Adejair_Junior" Júnior,
		Bruno "Bruno13" Travi,
		João "BarbaNegra" Paulo,
		Renato "Misterix" Venancio)

	Esqueleto do código:
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
	 * FUNCTIONS
	 *
	|
	 *
	 * HOOKS
	 *
	|
*/
/*
 * VARIABLES
 ******************************************************************************
*/
new
	/// <summary>
	///	Variável para armazenar o total de módulos carregados.</summary>
	modulesLoaded;

/*
 * NATIVE CALLBACKS
 ******************************************************************************
*/
public OnGameModeInit()
{
	#if defined modulecontrol_OnGameModeInit
		modulecontrol_OnGameModeInit();
	#endif
	/// <summary>
	/// Nesta callback:
	///		- inicia o módulo;
	/// </summary>

	ModuleInit("core/modulecontrol.pwn");
	
	return 1;
}

/*
 * FUNCTIONS
 ******************************************************************************
*/
/// <summary>
/// Função para alertar o carregamento de um módulo específico no console.
///	Imprime um cabeçalho avisando o início do carregamento dos módulos caso
/// nenhum módulo tenha sido carregado.
/// </summary>
/// <param name="moduleName">Nome do módulo.</param>
/// <returns>Não retorna valores.</returns>
ModuleInit(moduleName[])
{
	if(!modulesLoaded)
		print("________________________________________\n\n  > Carregando módulos\n");

	printf("  + modules/%s", moduleName);
	modulesLoaded++;
}

/*
 * FUNCTIONS
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
#define OnGameModeInit modulecontrol_OnGameModeInit
#if defined modulecontrol_OnGameModeInit
	forward modulecontrol_OnGameModeInit();
#endif