from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.prompt import Prompt
from ..database import obter_cursor

console = Console()

def listar_jogadores():
    """📜 Lista os jogadores disponíveis no banco de dados de forma estilizada com forças e fraquezas."""

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT * FROM listar_jogadores_formatados_v2();")
            jogadores = cursor.fetchall()

            if jogadores:
                table = Table(title="⚔️ Selecione seu Cavaleiro!", border_style="bright_blue")

                # Definição das colunas com tamanhos ajustados
                table.add_column("Número", justify="center", style="bold white", width=7)
                table.add_column("Nome", justify="left", style="bold cyan", width=12)
                table.add_column("Nível", justify="center", style="bold yellow", width=7)
                table.add_column("Elemento", justify="center", style="bold magenta", width=10)
                table.add_column("Descrição", justify="left", style="dim", max_width=40, overflow="fold")
                table.add_column("Fraco Contra", justify="center", style="bold red", width=12)
                table.add_column("Forte Contra", justify="center", style="bold green", width=12)

                # Ícones personalizados para os elementos
                elementos_emoji = {
                    "Fogo": "🔥",
                    "Água": "💧",
                    "Terra": "🌿",
                    "Vento": "🌪️",
                    "Trovão": "⚡"
                }

                # Preenchendo a tabela com os jogadores
                for index, (id_player, nome, nivel, elemento, descricao, fraco_contra, forte_contra) in enumerate(jogadores):
                    elemento_icon = elementos_emoji.get(elemento, "❓")
                    fraco_contra_icon = elementos_emoji.get(fraco_contra, "❓")
                    forte_contra_icon = elementos_emoji.get(forte_contra, "❓")

                    table.add_row(
                        f"[white]{id_player}[/white]",  # Exibição do Número do jogador
                        f"[cyan]{nome}[/cyan]", 
                        f"[yellow]{nivel}[/yellow]", 
                        f"[magenta]{elemento_icon} {elemento}[/magenta]",
                        f"[dim]{descricao}[/dim]",
                        f"[red]{fraco_contra_icon} {fraco_contra}[/red]",
                        f"[green]{forte_contra_icon} {forte_contra}[/green]"
                    )

                    # Adiciona uma linha divisória entre os jogadores (exceto o último)
                    if index < len(jogadores) - 1:
                        table.add_section()  

                console.print(table)
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
