from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from src.util import limpar_terminal
from ..database import obter_cursor




# Função para interagir com o NPC Mercador
def interagir_npc_mercador(console, selected_player_id):
    with obter_cursor() as cursor:
        try:
            # Buscar informações do NPC Mercador
            cursor.execute("SELECT nome, dialogo_inicial FROM npc_mercador LIMIT 1")
            npc = cursor.fetchone()

            if not npc:
                console.print("[bold red]❌ Erro: NPC Mercador não encontrado![/bold red]")
                return

            nome_npc, dialogo_inicial = npc

            while True:
                # Limpar o terminal e exibir o menu
                limpar_terminal(console)
                console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_inicial}[/italic]", expand=False))
                console.print(Panel("[bold cyan]Menu do Mercador[/bold cyan]", expand=False))
                console.print("1. [bold yellow]Comprar Armadura[/bold yellow]")
                console.print("2. [bold green]Comprar Consumíveis[/bold green]")
                console.print("3. [bold blue]Comprar Livros[/bold blue]")
                console.print("4. [bold magenta]Comprar Materiais[/bold magenta]")
                console.print("5. [bold red]Vender Itens[/bold red]")
                console.print("6. [bold cyan]Sair da Loja[/bold cyan]")

                escolha = input("\n🎯 Escolha uma opção: ").strip()

                if escolha == "1":
                    listar_itens_por_categoria(console, cursor, "armadura", selected_player_id)
                elif escolha == "2":
                    listar_itens_por_categoria(console, cursor, "consumivel", selected_player_id)
                elif escolha == "3":
                    listar_itens_por_categoria(console, cursor, "livro", selected_player_id)
                elif escolha == "4":
                    listar_itens_por_categoria(console, cursor, "material", selected_player_id)
                elif escolha == "5":
                    vender_itens(console, cursor, selected_player_id)
                elif escolha == "6":
                    console.print("[bold cyan]👋 Você saiu da loja.[/bold cyan]")
                    break
                else:
                    console.print("[bold red]❌ Opção inválida! Tente novamente.[/bold red]")
                    input("\n[Pressione Enter para continuar...]")

        except Exception as e:
            console.print(f"[bold red]Erro:[/bold red] {e}")


# Função para listar itens por categoria
def listar_itens_por_categoria(console, cursor, categoria, selected_player_id):
    try:
        categorias_para_visoes = {
            "armadura": "armadura_venda_view",
            "consumivel": "consumivel_venda_view",
            "livro": "livro_venda_view",
            "material": "material_venda_view"
        }

        if categoria not in categorias_para_visoes:
            console.print("[bold red]❌ Categoria inválida![/bold red]")
            return

        query = f"SELECT nome, descricao, preco_compra, nivel_minimo FROM {categorias_para_visoes[categoria]}"
        cursor.execute(query)
        itens = cursor.fetchall()

        if not itens:
            console.print(f"[bold yellow]⚠ Nenhum item disponível na categoria {categoria.capitalize()}.[/bold yellow]")
            input("\n[Pressione Enter para voltar ao menu...]")
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
            nome, descricao, preco, nivel_minimo = item
            table.add_row(str(idx), nome, descricao, f"{preco}", str(nivel_minimo))

        console.print(table)

        # Perguntar se o jogador quer comprar um item
        console.print("[bold green]\nDigite o número do item para comprá-lo ou 'S' para sair.[/bold green]")
        escolha = input("🎯 Escolha uma opção: ").strip()

        if escolha.lower() == 's':
            console.print("[bold cyan]Você voltou ao menu do mercador.[/bold cyan]")
            input("\n[Pressione Enter para continuar...]")
            limpar_terminal(console)
            return

        if not escolha.isdigit() or int(escolha) < 1 or int(escolha) > len(itens):
            console.print("[bold red]❌ Opção inválida![/bold red]")
            input("\n[Pressione Enter para continuar...]")
            limpar_terminal(console)
            return

        escolha_idx = int(escolha) - 1
        nome_item, descricao, preco, nivel_minimo = itens[escolha_idx]

        # Verificar nível do jogador
        cursor.execute("SELECT nivel FROM player WHERE id_player = %s", (selected_player_id,))
        jogador = cursor.fetchone()

        if not jogador:
            console.print("[bold red]❌ Jogador não encontrado![/bold red]")
            input("\n[Pressione Enter para continuar...]")
            limpar_terminal(console)
            return

        jogador_level = jogador[0]

        if jogador_level < nivel_minimo:
            console.print(f"[bold red]❌ Você precisa ser nível {nivel_minimo} para comprar {nome_item}.[/bold red]")
            input("\n[Pressione Enter para continuar...]")
            limpar_terminal(console)
            return

        # Processar compra (lógica de deduzir ouro do jogador e adicionar item ao inventário)
        console.print(f"[bold green]✅ Você comprou {nome_item} por {preco} moedas![/bold green]")

    except Exception as e:
        console.print(f"[bold red]Erro:[/bold red] {e}")
        input("\n[Pressione Enter para continuar...]")
        limpar_terminal(console)
