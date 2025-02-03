from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from src.util import limpar_terminal
from ..database import obter_cursor


# Função para interagir com o NPC Mercador
# Função para interagir com o NPC Mercador
def interagir_npc_mercador(console, selected_player_id):
    with obter_cursor() as cursor:
        try:
            # Buscar informações do NPC Mercador
            cursor.execute("SELECT nome, dialogo_inicial, dialogo_comprar, dialogo_vender, dialogo_sair FROM npc_mercador LIMIT 1")
            npc = cursor.fetchone()

            if not npc:
                console.print("[bold red]❌ Erro: NPC Mercador não encontrado![/bold red]")
                return

            nome_npc, dialogo_inicial, dialogo_comprar, dialogo_vender, dialogo_sair = npc

            while True:
                # Limpar o terminal e exibir o menu
                limpar_terminal(console)
                console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_inicial}[/italic]", expand=False))
                console.print(Panel("[bold cyan]Menu do Mercador[/bold cyan]", expand=False))
                console.print("1.🛡️ [bold yellow]Comprar Armadura[/bold yellow]")
                console.print("2.🧴 [bold green]Comprar Consumíveis[/bold green]")
                console.print("3.📚 [bold blue]Comprar Livros[/bold blue]")
                console.print("4.🔧 [bold magenta]Comprar Materiais[/bold magenta]")
                console.print("5.💰 [bold red]Vender Itens[/bold red]")
                console.print("6.🚪 [bold cyan]Sair da Loja[/bold cyan]")

                escolha = input("\n🎯 Escolha uma opção: ").strip()

                if escolha == "1":
                    listar_itens_por_categoria(console, cursor, "armadura", selected_player_id, dialogo_comprar, nome_npc)
                elif escolha == "2":
                    listar_itens_por_categoria(console, cursor, "consumivel", selected_player_id, dialogo_comprar, nome_npc)
                elif escolha == "3":
                    listar_itens_por_categoria(console, cursor, "livro", selected_player_id, dialogo_comprar, nome_npc)
                elif escolha == "4":
                    listar_itens_por_categoria(console, cursor, "material", selected_player_id, dialogo_comprar, nome_npc)
                elif escolha == "5":
                    vender_itens(console, cursor, selected_player_id, nome_npc, dialogo_vender)
                elif escolha == "6":
                    limpar_terminal(console)
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_sair}[/italic] 👋", expand=False))
                    console.print("[bold cyan] Você saiu da loja.[/bold cyan]")
                    break
                else:
                    console.print("[bold red]❌ Opção inválida! Tente novamente.[/bold red]")
                    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")

        except Exception as e:
            console.print(f"[bold red]Erro:[/bold red] {e}")


# Função para listar itens por categoria e processar a compra
def listar_itens_por_categoria(console, cursor, categoria, selected_player_id, dialogo_comprar, nome_npc):
    try:
        limpar_terminal(console)
        console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_comprar}[/italic]", expand=False))
        categorias_para_visoes = {
            "armadura": "armadura_venda_view",
            "consumivel": "consumivel_venda_view",
            "livro": "livro_venda_view",
            "material": "material_venda_view"
        }

        if categoria not in categorias_para_visoes:
            console.print("[bold red]❌ Categoria inválida![/bold red]")
            return

        query = f"SELECT * FROM {categorias_para_visoes[categoria]}"
        cursor.execute(query)
        itens = cursor.fetchall()

        if not itens:
            console.print(f"\n[bold yellow]⚠ Nenhum item disponível na categoria {categoria.capitalize()}.[/bold yellow]")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            input()
            limpar_terminal(console)
            return

        # Criar tabela com os itens disponíveis
        table = Table(title=f"📜 Itens Disponíveis - {categoria.capitalize()}")
        table.add_column("Opção", justify="center", style="bold cyan")
        table.add_column("Nome", justify="center", style="bold")
        table.add_column("Descrição", justify="center", style="bold")
        table.add_column("Preço", justify="right", style="green")
        table.add_column("Level Mínimo", justify="right", style="cyan")

        for idx, item in enumerate(itens, start=1):
            _, nome, preco, descricao, nivel_minimo = item
            table.add_row(str(idx), nome, descricao, f"{preco}", str(nivel_minimo))

        console.print("\n", table)

        # Perguntar se o jogador quer comprar um item
        console.print("[bold green]\nDigite o número do item para comprá-lo ou 'S' para sair.[/bold green]")
        escolha = input("🎯 Escolha uma opção: ").strip()

        if escolha.lower() == 's':
            console.print("[bold cyan]Você voltou ao menu do mercador.[/bold cyan]")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            limpar_terminal(console)
            return

        if not escolha.isdigit() or int(escolha) < 1 or int(escolha) > len(itens):
            console.print("[bold red]❌ Opção inválida![/bold red]")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            limpar_terminal(console)
            return

        escolha_idx = int(escolha) - 1
        id_item, nome_item, preco, descricao, nivel_minimo = itens[escolha_idx]

        # Processar a compra chamando a procedure
        try:
            cursor.execute("CALL comprar_item(%s, %s)", (selected_player_id, id_item))
            console.print(Panel(f"[italic]Você comprou [cyan]{nome_item}[/cyan] por [yellow]{preco} moedas![/yellow][/italic]", expand=False))
            input()
        except Exception as e:
            console.print(f"[bold red]Erro ao comprar o item:[/bold red] {e.diag.message_primary}")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            input()
            limpar_terminal(console)

    except Exception as e:
        console.print(f"[bold red]Erro:[/bold red] {e}")
        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
        input()
        limpar_terminal(console)


# Função para vender itens
def vender_itens(console, cursor, selected_player_id, nome_npc, dialogo_vender):
    limpar_terminal(console)
    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_vender}[/italic]", expand=False))
    try:
        # Buscar itens do inventário do jogador disponíveis para venda
        cursor.execute("""
            SELECT nome, descricao, quantidade, preco_venda
            FROM inventario_view
            WHERE id_player = %s
              AND preco_venda > 0
        """, (selected_player_id,))
        itens = cursor.fetchall()

        if not itens:
            console.print("\n[bold yellow]⚠ Nenhum item disponível para venda.[/bold yellow]")
            input("\n[Pressione Enter para voltar ao menu...]")
            limpar_terminal(console)
            return

        # Criar tabela com os itens do inventário
        table = Table(title="📜 Itens Disponíveis para Venda")
        table.add_column("Opção", justify="center", style="bold cyan")
        table.add_column("Nome", justify="left", style="blue")
        table.add_column("Descrição", justify="left", style="dim")
        table.add_column("Quantidade", justify="right", style="green")
        table.add_column("Preço de Venda", justify="right", style="yellow")

        for idx, item in enumerate(itens, start=1):
            nome, descricao, quantidade, preco_venda = item
            table.add_row(str(idx), nome, descricao, str(quantidade), f"{preco_venda} moedas")

        console.print(table)

        # Perguntar se o jogador quer vender um item
        console.print("[bold green]\nDigite o número do item para vendê-lo ou 'S' para sair.[/bold green]")
        escolha = input("🎯 Escolha uma opção: ").strip()

        if escolha.lower() == 's':
            console.print("[bold cyan]Você voltou ao menu do mercador.[/bold cyan]")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            limpar_terminal(console)
            return

        if not escolha.isdigit() or int(escolha) < 1 or int(escolha) > len(itens):
            console.print("[bold red]❌ Opção inválida![/bold red]")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            limpar_terminal(console)
            return

        escolha_idx = int(escolha) - 1
        nome_item, descricao, quantidade, preco_venda = itens[escolha_idx]

        # Processar a venda chamando a procedure
        try:
            cursor.execute("CALL vender_item(%s, %s)", (selected_player_id, nome_item))
            console.print(f"[bold green]✅ Você vendeu {nome_item} por {preco_venda} moedas![/bold green]")
            input("\n[Pressione ENTER para continuar...]")
            limpar_terminal(console)
        except Exception as e:
            console.print(f"[bold red]Erro ao vender o item:[/bold red] {e.diag.message_primary}")
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            input()
            limpar_terminal(console)

    except Exception as e:
        console.print(f"[bold red]Erro:[/bold red] {e}")
        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
        input()
        limpar_terminal(console)
