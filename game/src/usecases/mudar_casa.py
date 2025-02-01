from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from .listar_casas_disponiveis import listar_casas_disponiveis
from ..database import obter_cursor


def mudar_casa(console, player_id):
    """
    Permite ao jogador mudar para uma nova casa, verificando se ele atende aos requisitos.
    O jogador escolhe a casa a partir da lista de casas disponíveis.
    """
    try:
        casas_disponiveis = listar_casas_disponiveis(console, player_id)
        
        # Se não houver casas disponíveis, encerra a função
        if not casas_disponiveis:
            return None

        console.print("[bold cyan]Digite o número da casa desejada:[/bold cyan]")
        escolha = input("> ")

        # ESSA VERIFICAÇÃO NÃO FOI FEITA NO BANCO POR CONTA DE ESTÉTICA NO TERMINAL
        if escolha.isdigit() == False:
            console.print(Panel.fit(
                f"⛔ [bold red]Entrada inválida. Digite um número.[/bold red]",
                title="⛔ Mudança de Casa Negada",
                border_style="red"
            ))
            return

        # Chama a função SQL para mudar de casa
        with obter_cursor() as cursor:
            try:
                cursor.execute("SELECT mudar_casa(%s, %s);", (player_id, escolha))
                resultado = cursor.fetchone()[0]  # Captura a mensagem de retorno do banco
                console.print(Panel.fit(
                    f"✅ [bold green]{resultado}[/bold green]",
                    border_style="green"
                ))

            except Exception as e:
                console.print(Panel.fit(
                    f"⛔ [bold red]{e.diag.message_primary}[/bold red]",
                    title="⛔ Mudança de Casa Negada",
                    border_style="red"
                ))


    except Exception as e:
        console.print(Panel.fit(
            f"[bold red]⛔ {e.diag.message_primary} [/bold red]",
            border_style="red"
        ))
        return None
