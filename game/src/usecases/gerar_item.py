from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def gerar_item(console, jogador_id):
    """
    Permite ao jogador criar um item baseado nas receitas disponíveis, 
    verificando se ele tem materiais suficientes no inventário.
    """
    try:
        with obter_cursor() as cursor:
            # Buscar as receitas que o jogador pode criar corretamente
            cursor.execute("""
                SELECT r.id_item_gerado, 
                       m.nome AS item_gerado,
                       STRING_AGG(mat.nome || ' (' || mr.quantidade || ')', ', ') AS materiais, 
                       r.nivel_minimo
                FROM receita r
                JOIN material m ON r.id_item_gerado = m.id_material
                JOIN material_receita mr ON r.id_item_gerado = mr.id_receita
                JOIN material mat ON mr.id_material = mat.id_material
                LEFT JOIN item_armazenado ia 
                    ON ia.id_item = mr.id_material 
                    AND ia.id_inventario = %s
                WHERE r.nivel_minimo <= (SELECT nivel FROM player WHERE id_player = %s)
                GROUP BY r.id_item_gerado, m.nome, r.nivel_minimo
                HAVING COUNT(mr.id_material) = SUM(CASE 
                                                    WHEN ia.quantidade >= mr.quantidade THEN 1 
                                                    ELSE 0 
                                                 END)
            """, (jogador_id, jogador_id,))

            receitas_disponiveis = cursor.fetchall()

            if not receitas_disponiveis:
                console.print(Panel.fit(
                    "❌ [bold red]Você não tem materiais suficientes para criar nenhum item.[/bold red]",
                    border_style="red"
                ))
                return

            # Criando a tabela para exibir apenas as receitas disponíveis
            tabela_disponiveis = Table(title="✅ Receitas Que Você Pode Criar", show_lines=True)
            tabela_disponiveis.add_column("Opção", style="yellow", justify="center", no_wrap=True)
            tabela_disponiveis.add_column("Item Gerado", style="cyan", justify="left", no_wrap=True)
            tabela_disponiveis.add_column("Materiais Necessários", style="yellow", justify="left")
            tabela_disponiveis.add_column("Level Mínimo", justify="center", style="cyan")

            # Associar índices a receitas disponíveis
            index_map = {}
            for index, (id_item_gerado, item_gerado, materiais, nivel_minimo) in enumerate(receitas_disponiveis, start=1):
                tabela_disponiveis.add_row(str(index), item_gerado, materiais, str(nivel_minimo))
                index_map[index] = id_item_gerado

            console.print(tabela_disponiveis)

            # Perguntar ao jogador qual item ele deseja criar
            console.print("[bold yellow]Digite o número da opção que deseja criar:[/bold yellow]")
            escolha = input("> ").strip()

            if not escolha.isdigit() or int(escolha) not in index_map:
                console.print(Panel.fit(
                    "⛔ [bold red]Entrada inválida! Escolha um número válido da lista.[/bold red]",
                    border_style="red"
                ))
                return

            # Obter o ID do item baseado no índice escolhido
            id_item_gerado = index_map[int(escolha)]

            # Chamar a procedure para criar o item
            cursor.execute("CALL criar_item(%s, %s);", (jogador_id, id_item_gerado))
            cursor.connection.commit()

            console.print(Panel.fit(
                f"✅ [bold green]O item foi criado com sucesso![/bold green]",
                border_style="green"
            ))

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao criar item: {e}[/bold red]",
            border_style="red"
        ))
