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
                       STRING_AGG(mat.nome || ' (' || mr.quantidade || ')', ', ') AS materiais
                FROM receita r
                JOIN material m ON r.id_item_gerado = m.id_material
                JOIN material_receita mr ON r.id_item_gerado = mr.id_receita
                JOIN material mat ON mr.id_material = mat.id_material
                LEFT JOIN item_armazenado ia 
                    ON ia.id_item = mr.id_material 
                    AND ia.id_inventario = %s
                GROUP BY r.id_item_gerado, m.nome
                HAVING COUNT(mr.id_material) = SUM(CASE 
                                                    WHEN ia.quantidade >= mr.quantidade THEN 1 
                                                    ELSE 0 
                                                 END)
            """, (jogador_id,))

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

            for id_item_gerado, item_gerado, materiais in receitas_disponiveis:
                tabela_disponiveis.add_row(str(id_item_gerado), item_gerado, materiais)

            console.print(tabela_disponiveis)

            # Perguntar ao jogador qual item ele deseja criar
            console.print("[bold yellow]Digite a opção do item que deseja criar:[/bold yellow]")
            escolha = input("> ").strip()

            if not escolha.isdigit():
                console.print(Panel.fit(
                    "⛔ [bold red]Entrada inválida! Digite um número válido.[/bold red]",
                    border_style="red"
                ))
                return

            id_item_gerado = int(escolha)

            # Verificar se o item escolhido está na lista de receitas disponíveis
            if id_item_gerado not in [r[0] for r in receitas_disponiveis]:
                console.print(Panel.fit(
                    "⛔ [bold red]Este item não pode ser criado! Escolha um da lista.[/bold red]",
                    border_style="red"
                ))
                return

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

