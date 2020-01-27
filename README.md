# hogwarts-rp-g
Servidor de SA-MP modo Hogwarts RP/G

## Detalhes
- Versão do projeto: 0.0.1 Alfa
- Versão do SA-MP: 0.3.7 DL
- Compilador: Pawn Community Compiler

## Sobre
Este projeto é um modo de jogo desenvolvido para SA-MP, que tem por objetivo simular a ficção do mundo da trilogia Harry Potter.

Após anos (desde 2014) da idealização do projeto, foi decidido torná-lo open source para a comunidade do SA-MP. Ele está incompleto e não será continuado pela equipe de desenvolvimento oficial do projeto. Diversos problemas surgiram no desenvolvimento do mesmo, o que levou ao seu fim.

Apenas algumas funcionalidades estão prontas e incorporadas ao projeto, demais funcionalidades em desenvolvimento podem ser encontradas no diretório 'HOG DEV SYSTEMS'.

A quem deseja saber mais sobre o projeto pode consultar o tópico oficial no fórum: https://forum.sa-mp.com/showthread.php?t=596058

É importante frizar que não será dado suporte para quem desejar continuar com o projeto, você está por sua conta.
Também não estará aberto para PR's.

## Como compilar
No seu editor de texto, adicione um novo Build System com as seguintes configurações e aponte para o diretório `pawn-comp-lib`.
```
{
    "cmd": ["pawncc.exe", "$file", "-o$file_path\\\\$file_base_name", "-;+", "-(+", "-d3", "-Z+", "-Z"],
    "file_regex": "(.*?)[(]([0-9]*)[)]",
    "selector": "source.pwn",
    "working_dir": "c:\\diretório\\do\\projeto\\pawn-comp-lib"
}
```

As configurações do banco de dados se encontram em `modules\data\connection.pwn`.

## Desenvolvedores
### Programadores
- Adejair "Adejair_Junior" Júnior
- Bruno "Bruno13" Travi
- João "JPedro" Pedro

### Designers de modelos
- João "JPedro" Pedro

### Designers de mapas
- Bruno "Bruno13" Travi
- João "BarbaNegra" Paulo
- Renato "Misterix" Venancio

### Contribuidores
- Vitor "Vithinn" Santos
