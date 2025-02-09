from rich.console import Console
from rich.panel import Panel
from src.util import limpar_terminal
from .listar_cavaleiros_party import listar_cavaleiros_party
from .adicionar_cavaleiro_party import adicionar_cavaleiro_party
from .remover_cavaleiro_party import remover_cavaleiro_party
from ..database import obter_cursor
from .trocar_cavaleiro_party import trocar_cavaleiro_party

def modificar_grupo(console: Console, player_id):
    """Permite ao jogador visualizar e modificar o grupo (adicionar/remover cavaleiros)."""
    try:
        with obter_cursor() as cursor:
            cursor.connection.autocommit = False

            while True:
                # Atualiza as tabelas e listas de cavaleiros
                limpar_terminal(console)
                party_options, fora_party_options = listar_cavaleiros_party(console, player_id)
                # Exibe as opções de ações
                options = []
                if fora_party_options:
                    options.append(("Adicionar cavaleiro na party", adicionar_cavaleiro_party))
                if len(party_options) >= 1 and len(fora_party_options) >= 1:  
                    options.append(("Trocar cavaleiro da party", trocar_cavaleiro_party)) 
                if len(party_options) >= 1:  # O player não pode ser removido
                    options.append(("Remover cavaleiro da party", remover_cavaleiro_party))
                options.append(("Sair", None))

                # Exibe o menu interativo
                console.print("\n[bold yellow]Escolha uma ação:[/bold yellow]")
                for idx, (texto, _) in enumerate(options, 1):
                    console.print(f"{idx}. {texto}")

                escolha = input("\n🎯 Escolha uma ação: ").strip()

                # Verifica a entrada do jogador
                if escolha.isdigit():
                    escolha = int(escolha)
                    if 1 <= escolha <= len(options):
                        acao = options[escolha - 1][1]
                        if acao:  # Adicionar ou remover
                            acao(cursor, console, player_id)  # Passa o cursor corretamente aqui
                        else:  # Sair
                            console.print("\n[bold green]Você saiu do menu de grupo.[/bold green]")
                            break
                    else:
                        console.print(Panel.fit("[bold red]❌ Escolha inválida! Tente novamente.[/bold red]", border_style="red"))
                        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                        input()
                else:
                    console.print(Panel.fit("[bold red]❌ Entrada inválida! Digite um número válido.[/bold red]", border_style="red"))
                    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                    input()
                cursor.connection.commit()

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao modificar o grupo: {e}[/bold red]", border_style="red"))
        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
        input()
        limpar_terminal(console)