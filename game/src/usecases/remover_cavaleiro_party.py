from rich.console import Console
from rich.panel import Panel
from src.util import limpar_terminal
from .listar_cavaleiros_party import listar_cavaleiros_party

def remover_cavaleiro_party(cursor, console, player_id):
    while True:
        limpar_terminal(console)
        party_options, fora_party_options = listar_cavaleiros_party(console, player_id)

        if not party_options:
            console.print(Panel.fit("[bold red]❌ Não há cavaleiros na party para remover![/bold red]", border_style="red"))
            return

        console.print("\n[bold cyan]Escolha um cavaleiro para remover da party:[/bold cyan]")
        for idx, (_, _, nome) in enumerate(party_options, 1):
            console.print(f"{idx}. {nome}")

        try:
            remover = int(input("\n🎯 Escolha o número do cavaleiro para remover: ").strip())

            if 1 <= remover <= len(party_options):
                cavaleiro_removido = party_options[remover - 1][1]
                cursor.execute("CALL remover_cavaleiro_party(%s, %s);", (cavaleiro_removido, player_id))
                console.print(Panel.fit("[bold green]✅ Cavaleiro removido da party com sucesso![/bold green]", border_style="green"))
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()

                break
            else:
                console.print(Panel.fit("[bold red]❌ Escolha inválida![/bold red]", border_style="red"))

        except ValueError:
            console.print(Panel.fit("[bold red]❌ Entrada inválida! Digite um número válido.[/bold red]", border_style="red"))
