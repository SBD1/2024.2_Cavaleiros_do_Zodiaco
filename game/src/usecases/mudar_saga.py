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
        # Lista as sagas disponíveis
        sagas_disponiveis = listar_sagas_disponiveis(console, player_id)
        
        # Se não houver sagas disponíveis, encerra a função
        if not sagas_disponiveis:
            return None

        # Solicita ao jogador que escolha uma saga válida
        while True:
            console.print("[bold cyan]Digite o número da saga desejada:[/bold cyan]")
            escolha = input("> ")

            # Valida se a entrada é um número e se a saga está na lista
            if escolha.isdigit():
                escolha = int(escolha)
                if any(saga[0] == escolha for saga in sagas_disponiveis):
                    nova_saga_id = escolha
                    break
                else:
                    console.print("[bold yellow]Escolha inválida. Digite um número de saga disponível.[/bold yellow]")
            else:
                console.print("[bold red]Entrada inválida. Digite um número.[/bold red]")

        # Chama a função SQL para mudar de saga
        with obter_cursor() as cursor:
            cursor.execute("SELECT mudar_saga(%s, %s);", (player_id, nova_saga_id))
            resultado = cursor.fetchone()[0]  # Captura a mensagem de retorno do banco

            # Exibe o resultado com uma mensagem estilizada
            if "✅" in resultado:
                console.print(Panel(
                    f"[bold green]{resultado}[/bold green]",
                    title="🎉 Saga Atualizada",
                    border_style="green"
                ))
            else:
                console.print(Panel(
                    f"[bold red]{resultado}[/bold red]",
                    title="⛔ Mudança de Saga Negada",
                    border_style="red"
                ))


    except Exception as e:
        console.print(Panel(
            f"[bold red]Erro ao tentar mudar de saga:[/bold red] {e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
        return None
