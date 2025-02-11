from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor
from .tocar_musica import tocar_musica, parar_musica
from .iniciar_batalha import iniciar_batalha

def executar666(console, selected_player):
    tocar_musica("666.mp3", 0.5)

    with obter_cursor() as cursor:
        cursor.execute("SELECT id_boss FROM boss ORDER BY id_boss DESC LIMIT 1;")
        resultado = cursor.fetchone()

    if resultado and resultado[0]:  # Garante que um Boss foi encontrado
        try:
            iniciar_batalha(console, selected_player, int(resultado[0]))
        except Exception as e:
            console.print(f"[bold red]Erro ao iniciar a batalha: {e}[/bold red]")
    else:
        console.print("[bold red]Nenhum Boss encontrado![/bold red]")
    parar_musica()