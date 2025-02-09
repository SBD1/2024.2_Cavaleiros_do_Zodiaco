from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def listar_todas_receitas_armaduras(console,jogador_id):
    """
    Exibe todas as receitas disponíveis no jogo, listando o item gerado e os materiais necessários em uma única tabela.
    """

    try:
        with obter_cursor() as cursor:
            console.print(Panel(f"[bold cyan]Mu de Áries[/bold cyan]: [italic]Observar as receitas é o primeiro passo para entender o verdadeiro poder das armaduras. Lembre-se, cada uma delas é uma obra de arte criada com dedicação e propósito.[/italic]\n", expand=False))
            
            cursor.execute("""
                SELECT *
                FROM receitas_armadura_view;
            """)
            receitas = cursor.fetchall()

            if not receitas:
                console.print(Panel.fit(
                    "🔍 [bold yellow]Nenhuma receita encontrada![/bold yellow]",
                    border_style="yellow"
                ))
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()
                return

            # Criando a tabela para exibir todas as receitas
            tabela = Table(title="📜 Receitas", show_lines=True)
            tabela.add_column("Opção", justify="center", style="bold cyan")
            tabela.add_column("Nome da Armadura", style="bold yellow", justify="left")
            tabela.add_column("Parte do Corpo", style="bold magenta", justify="center")
            tabela.add_column("Raridade", style="magenta", justify="center")
            tabela.add_column("Materiais Necessários", style="dim", justify="left")
            tabela.add_column("Alma Necessária", style="green", justify="center")
            tabela.add_column("Nível Mínimo", style="cyan", justify="center")
            tabela.add_column("Defesa Física", style="red", justify="center")
            tabela.add_column("Defesa Mágica", style="blue", justify="center")
            tabela.add_column("Ataque Físico", style="green", justify="center")
            tabela.add_column("Ataque Mágico", style="blue", justify="center")

            for idx, receita in enumerate(receitas, start=1):
                id_item, nome, materiais, nivel_minimo, alma_necessaria, parte_corpo, raridade, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico = receita
                tabela.add_row(
                    str(idx), nome, parte_corpo, raridade,
                    materiais if materiais != '-' else '[dim]-[/dim]',
                    str(alma_necessaria), str(nivel_minimo), str(defesa_magica), str(defesa_fisica), str(ataque_magico), str(ataque_fisico)
                )
                

            console.print(tabela)
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            input()

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao consultar receitas: {e}[/bold red]",
            border_style="red"
        ))
        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
        input()