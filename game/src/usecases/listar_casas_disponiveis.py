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
            try:


                cursor_name = "get_casa_atual"
                cursor.connection.autocommit = False  
                cursor.execute("CALL get_casa_atual(%s, %s);", (player_id, cursor_name))
                cursor.execute(f"FETCH ALL FROM {cursor_name};")
                casa_atual = cursor.fetchone()

                cursor.execute(f"CLOSE {cursor_name};")

                cursor.connection.commit()




                if casa_atual:
                    id_casa_atual = casa_atual[0]
                else:
                    id_casa_atual = None
            except Exception as e:
                console.print(Panel.fit(
                    f"❌ [bold red]Erro ao obter a casa atual do jogador: {e}[/bold red]",
                    border_style="red"
                ))
                return []
            
            try:
                cursor.execute("SELECT * FROM listar_casas(%s);", (player_id,))
                casas = cursor.fetchall()


                table = Table(title="🌌 Casas Disponíveis", show_lines=True, header_style="bold cyan")
                table.add_column("Opção", justify="center", style="bold green")
                table.add_column("📍 Nome da casa", justify="left", style="bold green")

                for casa in casas:
                    id_casa = casa[0]
                    nome_casa = casa[1]

                    if id_casa == id_casa_atual:
                        table.add_row(f"[bold yellow]{str(id_casa)}[/bold yellow]", f"[bold yellow]{nome_casa} (Você está aqui.)[/bold yellow]")  # Destaque para a casa atual
                    else:
                        table.add_row(str(id_casa), nome_casa)
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
