
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
            # Nome do cursor
            cursor_name = "inventario_cursor"

            # Iniciando uma transação manualmente para manter o cursor aberto
            cursor.connection.autocommit = False  

            # Chamando a procedure para abrir o cursor
            cursor.execute("CALL get_inventario_cursor(%s, %s);", (player_id, cursor_name))

            # Obtendo os dados do cursor dentro da mesma transação
            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            inventario = cursor.fetchall()

            # Fechando o cursor explicitamente
            cursor.execute(f"CLOSE {cursor_name};")

            # Confirmando a transação para evitar bloqueios
            cursor.connection.commit()

            # Se o inventário estiver vazio
            if not inventario:
                console.print(Panel.fit(
                    "🔍 [bold yellow]Nenhum item encontrado no inventário![/bold yellow]",
                    border_style="yellow"
                ))
                return
            
            # Criando a tabela para exibição
            tabela = Table(title=f"🎒 Inventário do Jogador {player_id}", show_lines=True)
            tabela.add_column("Nome", style="cyan", justify="left")
            tabela.add_column("Preço", style="green", justify="right")
            tabela.add_column("Descrição", style="white", justify="left")
            tabela.add_column("Tipo", style="magenta", justify="center")

            # Preenchendo a tabela com os dados do inventário
            for item in inventario:
                nome, preco_venda, descricao, tipo_item, _ = item  # Ignoramos o id_player
                tabela.add_row(nome, f"R$ {preco_venda:.2f}", descricao, tipo_item)

            # Exibindo a tabela no terminal
            console.print(tabela)

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao recuperar o inventário: {e}[/bold red]",
            border_style="red"
        ))
