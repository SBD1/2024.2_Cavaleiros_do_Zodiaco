from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor

def listar_jogadores():
    """📜 Lista os jogadores disponíveis no banco de dados de forma estilizada."""
    
    console = Console()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT listar_jogadores_formatados();")
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                console.print(Panel.fit(
                    f"🎭 [bold cyan]Jogadores Disponíveis:[/bold cyan] 🎭\n\n"
                    f"[bold yellow]{resultado[0]}[/bold yellow]",
                    title="⚔️ Selecione seu Cavaleiro! 🛡",
                    border_style="bright_blue"
                ))
            else:
                console.print(Panel.fit(
                    "😞 [bold red]Nenhum jogador disponível no momento.[/bold red]",
                    title="📜 Lista Vazia",
                    border_style="red"
                ))
    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao listar jogadores:[/bold red] {e}",
            title="⚠️ Erro",
            border_style="red"
        ))
