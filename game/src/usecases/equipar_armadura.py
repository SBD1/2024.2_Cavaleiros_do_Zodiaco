from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from src.util import limpar_terminal

from ..database import obter_cursor
from .listar_equipamentos import listar_equipamentos

def equipar_armadura(console, jogador_id):
    
    with obter_cursor() as cursor:    
        try:
            while True:
                limpar_terminal(console)
                if listar_equipamentos(console, jogador_id):
                    console.print("[bold yellow]\nDeseja equipar uma armadura do inventário? (s/n)[/bold yellow]")
                    escolha = input("> ").strip().lower()

                    if escolha == "s":
                            console.print("[bold green]Digite o ID da instância da armadura que deseja equipar:[/bold green]")
                            id_instancia_equipar = input("> ").strip()

                            if not id_instancia_equipar.isdigit():
                                console.print(Panel.fit("⛔ [bold red]Entrada inválida! Por favor, insira um número válido.[/bold red]", border_style="red"))
                                return

                            id_instancia_equipar = int(id_instancia_equipar)

                            cursor.execute("CALL equipar_armadura(%s, %s)", (jogador_id, id_instancia_equipar))
                            cursor.connection.commit()

                            console.print(Panel.fit("✅ [bold green]A armadura foi equipada com sucesso![/bold green]", border_style="green"))
                            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                            input()

                    else:   
                        console.print("[bold cyan]Você decidiu não equipar nenhuma armadura.[/bold cyan]")

                        break
                else:
                    console.print("[bold cyan]Você não possui armaduras disponíveis para equipar.[/bold cyan]")
                    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
        except Exception as e:
            console.print(Panel.fit(f"⛔ [bold red]Erro ao equipar armadura: {e}[/bold red]", border_style="red"))
            cursor.connection.rollback()
            return