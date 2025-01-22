from rich.panel import Panel
from rich.console import Console
from ..database import obter_cursor

console = Console()

def obter_nome_sala(id_sala):
    """🏰 Retorna o nome da sala com base no ID informado."""
    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT get_nome_sala(%s);", (id_sala,))
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                return resultado[0]  # Retorna o nome da sala
            
            console.print(Panel.fit(
                "⚠️ [bold yellow]Sala não encontrada![/bold yellow] 🚪",
                title="🔍 Busca de Sala",
                border_style="yellow"
            ))
            return None

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao buscar o nome da sala:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
        return None
