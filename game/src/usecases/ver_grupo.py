from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def ver_grupo(console, player_id):
    """
    Exibe as informações do grupo do jogador chamando a procedure get_grupo_cursor.
    """

    try:
        with obter_cursor() as cursor:

            cursor_name = "grupo_cursor"

            cursor.connection.autocommit = False  

            cursor.execute("CALL get_grupo_cursor(%s, %s);", (player_id, cursor_name))

            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            grupo = cursor.fetchall()

            cursor.execute(f"CLOSE {cursor_name};")

            cursor.connection.commit()

            if not grupo:
                console.print(Panel.fit(
                    "🔍 [bold yellow]Nenhum membro do grupo encontrado![/bold yellow]",
                    border_style="yellow"
                ))
                return
            
            tabela = Table(title=f"⚔️ Grupo do Jogador ", show_lines=True)
            tabela.add_column("Cavaleiro", style="cyan", justify="center", no_wrap=True)
            tabela.add_column("Elemento", style="blue", justify="center", no_wrap=True)
            tabela.add_column("Nível", style="green", justify="center", no_wrap=True)
            tabela.add_column("XP Atual", style="yellow", justify="center", no_wrap=True)
            tabela.add_column("HP Máx", style="red", justify="center", no_wrap=True)
            tabela.add_column("Magia Máx", style="magenta", justify="center", no_wrap=True)
            tabela.add_column("HP Atual", style="red", justify="center", no_wrap=True)
            tabela.add_column("Magia Atual", style="magenta", justify="center", no_wrap=True)
            tabela.add_column("Velocidade", style="white", justify="center", no_wrap=True)
            tabela.add_column("Ataque Físico", style="orange1", justify="center", no_wrap=True)
            tabela.add_column("Ataque Mágico", style="purple", justify="center", no_wrap=True)

            for item in grupo:
                (
                    nome, elemento, nivel, xp_atual, hp_max, magia_max, 
                    hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico, _
                ) = item  

                tabela.add_row(
                    nome, elemento, str(nivel), str(xp_atual), 
                    str(hp_max), str(magia_max), str(hp_atual), 
                    str(magia_atual), str(velocidade), str(ataque_fisico), str(ataque_magico)
                )

            console.print(tabela)

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao recuperar o grupo: {e}[/bold red]",
            border_style="red"
        ))
