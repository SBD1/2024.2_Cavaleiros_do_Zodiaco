from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor

def ver_sala_atual(console, selected_player_id):
    """🏰 Exibe a sala atual do jogador com estilo e feedback visual."""

    if selected_player_id is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🛑",
            title="⚠️ Aviso",
            border_style="red"
        ))
        return

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT get_sala_atual(%s);", (selected_player_id,))
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                console.print(Panel.fit(
                    f"📍 [bold cyan]Sala Atual:[/bold cyan]\n🏛️ [bold]{resultado[0]}[/bold]",
                    title="🏰 Localização",
                    border_style="cyan"
                ))
            else:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Sala atual não encontrada para o jogador selecionado.[/bold yellow] 🤷‍♂️",
                    title="🔍 Não Encontrado",
                    border_style="yellow"
                ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao buscar a sala atual:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
