from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def listar_todas_receitas_materiais(console,jogador_id):
    """
    Exibe todas as receitas disponíveis no jogo, listando o item gerado e os materiais necessários em uma única tabela.
    """

    try:
        with obter_cursor() as cursor:
            # Buscar todas as receitas com os materiais concatenados
            cursor.execute("""
                SELECT *
                FROM receitas_materiais_view;
            """)
            receitas = cursor.fetchall()

            if not receitas:
                console.print(Panel.fit(
                    "🔍 [bold yellow]Nenhuma receita encontrada![/bold yellow]",
                    border_style="yellow"
                ))
                return

            # Criando a tabela para exibir todas as receitas
            tabela = Table(title="📜 Receitas", show_lines=True)
            tabela.add_column("Item Gerado", style="cyan", justify="left", no_wrap=True)
            tabela.add_column("Materiais Necessários", style="yellow", justify="left")
            tabela.add_column("Nível Minimo", style="blue", justify="center")

            for id_item_gerado, item_gerado, materiais, nivel_minimo in receitas:
                tabela.add_row(item_gerado, materiais, str(nivel_minimo))

            console.print(tabela)

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao consultar receitas: {e}[/bold red]",
            border_style="red"
        ))