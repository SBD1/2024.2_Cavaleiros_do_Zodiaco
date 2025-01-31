from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor
from .listar_sagas_disponiveis import listar_sagas_disponiveis

def mudar_saga(console, player_id):
    """
    Permite ao jogador mudar para uma nova saga, verificando se ele atende aos requisitos.
    O jogador escolhe a saga a partir da lista de sagas disponíveis.
    """
    try:
        sagas_disponiveis = listar_sagas_disponiveis(console, player_id)
        
        # Se não houver sagas disponíveis, encerra a função
        if not sagas_disponiveis:
            return None

        console.print("[bold cyan]Digite o número da saga desejada:[/bold cyan]")
        escolha = input("> ")

        # ESSA VERIFICAÇÃO NÃO FOI FEITA NO BANCO POR CONTA DE ESTÉTICA NO TERMINAL
        if escolha.isdigit() == False:
            console.print(Panel.fit(
                f"⛔ [bold red]Entrada inválida. Digite um número.[/bold red]",
                title="⛔ Mudança de Saga Negada",
                border_style="red"
            ))
            return

        # Chama a função SQL para mudar de saga
        with obter_cursor() as cursor:
            try:
                cursor.execute("SELECT mudar_saga(%s, %s);", (player_id, escolha))
                resultado = cursor.fetchone()[0]  # Captura a mensagem de retorno do banco
                console.print(Panel.fit(
                    f"✅ [bold green]{resultado}[/bold green]",
                    border_style="green"
                ))

            except Exception as e:
                console.print(Panel.fit(
                    f"⛔ [bold red]{e.diag.message_primary}[/bold red]",
                    title="⛔ Mudança de Saga Negada",
                    border_style="red"
                ))


    except Exception as e:
        console.print(Panel.fit(
            f"[bold red]⛔ {e.diag.message_primary} [/bold red]",
            border_style="red"
        ))
        return None
