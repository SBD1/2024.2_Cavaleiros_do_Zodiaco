from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def listar_casas_disponiveis(console, player_id):
    """
    Lista todas as casas disponíveis para o jogador.
    casas disponíveis são aquelas com:
    - `id_missao_requisito` = NULL
    - Ou cuja missão pré-requisito foi concluída pelo jogador.
    """
    try:
        with obter_cursor() as cursor:
            # Consulta para buscar casas disponíveis
            try:
                cursor.execute("SELECT * FROM listar_casas(%s);", (player_id,))
                casas = cursor.fetchall()


                table = Table(title="🌌 Casas Disponíveis", show_lines=True, header_style="bold cyan")
                table.add_column("Opção", justify="center", style="bold green")
                table.add_column("📍 Nome da casa", justify="left", style="bold green")

                for casa in casas:
                    # Convertendo valores para string antes de adicionar à tabela
                    id_casa = str(casa[0])
                    nome_casa = casa[1]
                    table.add_row(id_casa, nome_casa)

                console.print(table)

                return casas
            
            except Exception as e:
                console.print(Panel.fit(
                    f"❌ [bold red]{e.diag.message_primary}:[/bold red]",
                    border_style="red"
                ))
                return []

    except Exception as e:
        console.print(Panel(
            f"[bold red]Erro ao buscar casas disponíveis:[/bold red] {e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
        return []
