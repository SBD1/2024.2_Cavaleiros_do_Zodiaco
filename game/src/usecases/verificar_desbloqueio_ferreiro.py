from rich.console import Console
from ..database import obter_cursor

console = Console()

def verificar_desbloqueio_ferreiro(id_jogador_selecionado):
    """Verifica se o NPC Ferreiro foi desbloqueado pelo jogador."""
    if id_jogador_selecionado is None:
        console.print("[bold red]Erro: Nenhum jogador selecionado.[/bold red]")
        return False

    try:
        with obter_cursor() as cursor:
            # Verificar se o ferreiro está desbloqueado
            cursor.execute("SELECT verificar_desbloqueio_ferreiro(%s);", (id_jogador_selecionado,))
            return cursor.fetchone()[0] 


    except Exception as e:
        console.print(f"[bold red]Erro ao verificar o desbloqueio do NPC Ferreiro:[/bold red] {e}")
        return False
