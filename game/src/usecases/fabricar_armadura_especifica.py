from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..util import limpar_terminal
from ..database import obter_cursor

def fabricar_armadura_especifica(console, jogador_id):
    """
    Permite ao jogador escolher e fabricar uma armadura disponível, verificando os requisitos de alma e materiais.
    """
    try:
        with obter_cursor() as cursor:
            # Introdução do NPC
            console.print(Panel(f"[bold cyan]Mu de Áries[/bold cyan]: [italic]Ah, vejo que deseja forjar uma nova armadura. Escolha sabiamente, pois ela será sua companheira nos momentos mais difíceis. Vamos começar a dar forma ao seu desejo.[/italic]\n", expand=False))

            # Buscar armaduras que o jogador pode fabricar
            cursor.execute("""
                SELECT id_item_gerado, item_gerado, materiais, nivel_minimo, alma_armadura, parte_corpo, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico
                FROM receitas_armadura_view
                WHERE nivel_minimo <= (SELECT nivel FROM player WHERE id_player = %s)
            """, (jogador_id,))
            receitas = cursor.fetchall()

            if not receitas:
                console.print(Panel.fit(
                    "❌ [bold yellow]Nenhuma receita de armadura está disponível para você no momento.[/bold yellow]",
                    border_style="yellow"
                ))
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()
                return

            # Criar tabela para exibir receitas disponíveis
            tabela_receitas = Table(title="⚔️ Receitas Disponíveis para Fabricação", show_lines=True)
            tabela_receitas.add_column("Opção", justify="center", style="bold cyan")
            tabela_receitas.add_column("Nome da Armadura", style="bold yellow", justify="left")
            tabela_receitas.add_column("Parte do Corpo", style="bold magenta", justify="center")
            tabela_receitas.add_column("Raridade", style="magenta", justify="center")
            tabela_receitas.add_column("Materiais Necessários", style="dim", justify="left")
            tabela_receitas.add_column("Alma Necessária", style="green", justify="center")
            tabela_receitas.add_column("Nível Mínimo", style="cyan", justify="center")
            tabela_receitas.add_column("Defesa Física", style="red", justify="center")
            tabela_receitas.add_column("Defesa Mágica", style="blue", justify="center")
            tabela_receitas.add_column("Ataque Físico", style="green", justify="center")
            tabela_receitas.add_column("Ataque Mágico", style="blue", justify="center")

            for idx, receita in enumerate(receitas, start=1):
                id_item, nome, materiais, nivel_minimo, alma_necessaria, parte_corpo, raridade, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico = receita
                tabela_receitas.add_row(
                    str(idx), nome, parte_corpo, raridade,
                    materiais if materiais != '-' else '[dim]-[/dim]',
                    str(alma_necessaria), str(nivel_minimo), str(defesa_magica), str(defesa_fisica), str(ataque_magico), str(ataque_fisico)
                )

            console.print("\n", tabela_receitas)

            # Escolher uma armadura para fabricar
            console.print("\n[bold yellow]Digite o número da armadura que deseja fabricar ou 'S' para sair:[/bold yellow]")
            escolha = input("🎯 Escolha uma opção: ").strip()

            if escolha.lower() == 's':
                console.print("[bold cyan]Você decidiu sair da forja de armaduras.[/bold cyan]")
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()
                limpar_terminal(console)
                return

            if not escolha.isdigit() or int(escolha) < 1 or int(escolha) > len(receitas):
                console.print(Panel.fit(
                    "❌ [bold red]Opção inválida! Escolha um número da lista ou 'S' para sair.[/bold red]",
                    border_style="red"
                ))
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()
                return

            escolha_idx = int(escolha) - 1
            id_item_gerado, nome_armadura, materiais, _, alma_necessaria, _, _, _, _, _, _ = receitas[escolha_idx]

            # Verificar requisitos de alma e materiais
            try:
                cursor.execute("CALL fabricar_armadura(%s, %s);", (jogador_id, id_item_gerado))
                cursor.connection.commit()

                console.print(Panel.fit(
                    f"✅ [bold green]A armadura [cyan]{nome_armadura}[/cyan] foi forjada com sucesso![/bold green]",
                    border_style="green"
                ))
            except Exception as e:
                console.print(Panel.fit(
                    f"⛔ [bold red]Erro ao fabricar a armadura: {e}[/bold red]",
                    border_style="red"
                ))

            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            input()

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao acessar a forja: {e}[/bold red]",
            border_style="red"
        ))
        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
        input()
