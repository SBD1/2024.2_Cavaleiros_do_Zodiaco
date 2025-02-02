from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def trocar_cavaleiro(console, player_id):
    """
    Permite ao jogador trocar um cavaleiro na party, garantindo o limite de 3 cavaleiros.
    """

    try:
        with obter_cursor() as cursor:

            cursor.execute("SELECT * FROM get_cavaleiros_disponiveis();")
            cavaleiros_disponiveis = cursor.fetchall()

            tabela = Table(title="🛡️ Cavaleiros Disponíveis para Adição", show_lines=True)
            tabela.add_column("ID", style="yellow", justify="center")
            tabela.add_column("Nome", style="cyan", justify="left")

            for cavaleiro in cavaleiros_disponiveis:
                tabela.add_row(str(cavaleiro[0]), cavaleiro[1])

            console.print(tabela)

            console.print("[bold yellow]Digite o ID do cavaleiro que deseja adicionar à party:[/bold yellow]")
            escolha = input("> ")

            if not escolha.isdigit():
                console.print(Panel.fit(
                    "⛔ [bold red]Entrada inválida! Digite um número válido.[/bold red]",
                    border_style="red"
                ))
                return

            id_cavaleiro_novo = int(escolha)

            cursor.execute("SELECT * FROM get_party_cavaleiros(%s);", (player_id,))
            cavaleiros_na_party = cursor.fetchall()

            if len(cavaleiros_na_party) >= 3:
                console.print("\n[bold red]A party já tem 3 cavaleiros! Escolha um para remover:[/bold red]")

                tabela_party = Table(title="🏰 Cavaleiros na Party", show_lines=True)
                tabela_party.add_column("ID", style="yellow", justify="center")
                tabela_party.add_column("Nome", style="cyan", justify="left")

                for cavaleiro in cavaleiros_na_party:
                    tabela_party.add_row(str(cavaleiro[0]), cavaleiro[1])

                console.print(tabela_party)

                console.print("[bold red]Digite o ID do cavaleiro que deseja remover:[/bold red]")
                escolha_remover = input("> ")

                if not escolha_remover.isdigit():
                    console.print(Panel.fit(
                        "⛔ [bold red]Entrada inválida! Digite um número válido.[/bold red]",
                        border_style="red"
                    ))
                    return

                id_cavaleiro_removido = int(escolha_remover)
            else:
                id_cavaleiro_removido = None

            cursor.execute("CALL trocar_cavaleiro_party(%s, %s, %s);", (player_id, id_cavaleiro_novo, id_cavaleiro_removido))
            cursor.connection.commit()

            console.print(Panel.fit(
                f"✅ [bold green]Cavaleiro foi atualizado na party![/bold green]",
                border_style="green"
            ))

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao trocar cavaleiro: {e}[/bold red]",
            border_style="red"
        ))
