
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def ver_inventario(console, player_id):
    """
    Exibe o inventário do jogador chamando a procedure get_inventario_cursor.
    """

    try:
        with obter_cursor() as cursor:

            cursor_name = "inventario_cursor"

            cursor.connection.autocommit = False  

            cursor.execute("CALL get_inventario_cursor(%s, %s);", (player_id, cursor_name))

            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            inventario = cursor.fetchall()

            cursor.execute(f"CLOSE {cursor_name};")

            cursor.connection.commit()

            if not inventario:
                console.print(Panel.fit(
                    "🔍 [bold yellow]Nenhum item encontrado no inventário![/bold yellow]",
                    border_style="yellow"
                ))
                return
            
            tabela = Table(title=f"🎒 Inventário ", show_lines=True)
            tabela.add_column("Nome", style="cyan", justify="left")
            tabela.add_column("Quantidade", style="green", justify="center")
            tabela.add_column("Preço", style="green", justify="right")
            tabela.add_column("Descrição", style="white", justify="left")
            tabela.add_column("Tipo", style="magenta", justify="center")
            
            for item in inventario:
                nome, preco_venda, descricao, tipo_item,quantidade, _ = item  # Ignoramos o id_player
                tabela.add_row(nome,str(quantidade), f"R$ {preco_venda:.2f}", descricao, tipo_item)

            console.print(tabela)

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao recuperar o inventário: {e}[/bold red]",
            border_style="red"
        ))
