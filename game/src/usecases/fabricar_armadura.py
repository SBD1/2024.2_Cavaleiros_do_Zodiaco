from rich.console import Console
from rich.panel import Panel

from .listar_todas_receitas_armaduras import listar_todas_receitas_armaduras
from .fabricar_armadura_especifica import fabricar_armadura_especifica
from ..util import limpar_terminal


def fabricar_armadura(console, jogador_id):
    """
    Permite ao jogador visualizar todas as receitas ou fabricar uma armadura específica.
    """
    try:
        while True:
            limpar_terminal(console)
            console.print(Panel(f"[bold cyan]Mu de Áries[/bold cyan]: [italic]Bem-vindo, jovem guerreiro. Aqui na minha forja, moldamos não apenas metal, mas a essência de proteção e poder. O que deseja realizar hoje?[/italic]\n", expand=False))
            console.print(Panel("[bold cyan]🏭 Fábrica de Armaduras[/bold cyan]", expand=False))

            # Exibe o menu de opções
            console.print("[bold yellow]1.[/bold yellow] Ver todas as receitas de armaduras")
            console.print("[bold green]2.[/bold green] Fabricar uma armadura específica")
            console.print("[bold white]3.[/bold white] Sair")

            # Entrada do jogador
            escolha = input("\n🛠️ Escolha uma opção: ").strip()

            if escolha == "1":
                # Lista todas as receitas de armaduras
                limpar_terminal(console)
                listar_todas_receitas_armaduras(console, jogador_id)


            elif escolha == "2":
                # Permite fabricar uma armadura específica
                limpar_terminal(console)
                fabricar_armadura_especifica(console, jogador_id)

            elif escolha == "3":
                # Sai da função
                console.print("[bold cyan]Você saiu da fábrica de armaduras.[/bold cyan]")
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()
                break

            else:
                # Opção inválida
                console.print(Panel.fit("[bold red]❌ Opção inválida! Tente novamente.[/bold red]", border_style="red"))
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()
                continue

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro: {e}[/bold red]", border_style="red"))
