from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def listar_sagas_disponiveis(console, player_id):
    """
    Lista todas as sagas disponíveis para o jogador.
    sagas disponíveis são aquelas com:
    - `id_missao_requisito` = NULL
    - Ou cuja missão pré-requisito foi concluída pelo jogador.
    """
    try:
        with obter_cursor() as cursor:
            # Consulta para buscar sagas disponíveis
            try:
                cursor.execute("SELECT * FROM listar_sagas(%s);", (player_id,))
                sagas = cursor.fetchall()


                table = Table(title="🌌 Sagas Disponíveis", show_lines=True, header_style="bold cyan")
                table.add_column("Opção", justify="center", style="bold green")
                table.add_column("📍 Nome da Saga", justify="left", style="bold green")

                for saga in sagas:
                    # Convertendo valores para string antes de adicionar à tabela
                    id_saga = str(saga[0])
                    nome_saga = saga[1]
                    table.add_row(id_saga, nome_saga)

                console.print(table)

                return sagas
            
            except Exception as e:
                console.print(Panel.fit(
                    f"❌ [bold red]{e.diag.message_primary}:[/bold red]",
                    border_style="red"
                ))
                return []

    except Exception as e:
        console.print(Panel(
            f"[bold red]Erro ao buscar sagas disponíveis:[/bold red] {e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
        return []
