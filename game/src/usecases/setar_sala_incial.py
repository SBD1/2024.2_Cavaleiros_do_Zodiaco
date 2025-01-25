from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor

def setar_sala_inicial(id_player):
    """🎮 Define a sala inicial para o jogador e exibe o resultado."""
    
    console = Console()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT setar_sala_inicial(%s);", (id_player,))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao definir a sala inicial:[/bold red] {e}",
            title="⚠️ Erro",
            border_style="red"
        ))
