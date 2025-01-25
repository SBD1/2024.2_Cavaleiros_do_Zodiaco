from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def ver_salas_disponiveis(console, selected_player_id):
    """🔍 Exibe as salas conectadas disponíveis para o jogador com direções (Norte, Sul, Leste, Oeste)."""

    if selected_player_id is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🛑",
            title="⚠️ Aviso",
            border_style="red"
        ))
        return

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT * FROM get_salas_conectadas(%s);", (selected_player_id,))
            salas = cursor.fetchall()

            if salas:
                table = Table(title="🏰 Salas Disponíveis", show_lines=True, header_style="bold cyan")
                table.add_column("🧭 Direção", justify="center", style="bold magenta")
                table.add_column("📍 Nome da Sala", justify="left", style="bold green")

                for sala in salas:
                    direcao, nome = sala[2], sala[1]
                    table.add_row(direcao, nome)

                console.print(table)
            else:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Nenhuma sala conectada disponível.[/bold yellow] 🤷‍♂️",
                    title="🔍 Nada Encontrado",
                    border_style="yellow"
                ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao buscar salas disponíveis:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
