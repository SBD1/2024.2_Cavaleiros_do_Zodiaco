from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def listar_todas_receitas(console,jogador_id):
    """
    Exibe todas as receitas disponíveis no jogo, listando o item gerado e os materiais necessários em uma única tabela.
    """

    try:
        with obter_cursor() as cursor:
            # Buscar todas as receitas com os materiais concatenados
            cursor.execute("""
                SELECT r.id_item_gerado, 
                       m.nome AS item_gerado,
                       STRING_AGG(mat.nome || ' (' || mr.quantidade || ')', ', ') AS materiais
                FROM receita r
                JOIN material m ON r.id_item_gerado = m.id_material
                JOIN material_receita mr ON r.id_item_gerado = mr.id_receita
                JOIN material mat ON mr.id_material = mat.id_material
                GROUP BY r.id_item_gerado, m.nome;
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

            for id_item_gerado, item_gerado, materiais in receitas:
                tabela.add_row(item_gerado, materiais)

            console.print(tabela)

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao consultar receitas: {e}[/bold red]",
            border_style="red"
        ))