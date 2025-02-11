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
                table.add_column("HP", justify="left", style="dim", max_width=40, overflow="fold")
                table.add_column("Cosmo", justify="center", style="bold red", width=12)
                table.add_column("Dinheiro", justify="center", style="bold red", width=12)
                table.add_column("Ataque Fisico", justify="center", style="bold green", width=12)
                table.add_column("Ataque Mágico", justify="center", style="bold green", width=12)

                # Ícones personalizados para os elementos
                elementos_config = {
                    "Fogo": {"emoji": "🔥", "cor": "bold red"},
                    "Água": {"emoji": "💧", "cor": "bold blue"},
                    "Terra": {"emoji": "🌿", "cor": "bold green"},
                    "Vento": {"emoji": "🌀", "cor": "white"},
                    "Trovão": {"emoji": "⚡", "cor": "bold yellow"},
                    "Luz": {"emoji": "✨", "cor": "bold white"},
                    "Trevas": {"emoji": "🌑", "cor": "bold magenta"},
                }


                # Preenchendo a tabela com os jogadores
                for index, (id_player, nome, nivel, elemento, hp_max, magia_max, hp_atual, magia_atual, ataque_fisico, ataque_magico, dinheiro) in enumerate(jogadores):
                    elemento_icon = elementos_config.get(elemento, {}).get("emoji", "❓")
                    elemento_cor = elementos_config.get(elemento, {}).get("cor", "bold white")
                    
                    table.add_row(
                        f"[white]{id_player}[/white]",  # Exibição do Número do jogador
                        f"[cyan]{nome}[/cyan]", 
                        f"[yellow]{nivel}[/yellow]", 
                        f"[{elemento_cor}]{elemento_icon} {elemento}[/{elemento_cor}]",
                        f"[bold red]{hp_max}/{hp_atual}[/bold red]",  # HP formatado como "hp_max/hp_atual"
                        f"[bold blue]{magia_max}/{magia_atual}[/bold blue]",  # Magia formatada como "magia_max/magia_atual"
                        f"[bold green]{dinheiro}[/bold green]", 
                        f"[bold grey]{ataque_fisico}[/bold grey]",
                        f"[slate_blue3]{ataque_magico}[/slate_blue3]"
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
