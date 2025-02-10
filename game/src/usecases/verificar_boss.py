from ..database import obter_cursor 
from rich.panel  import Panel


def verificar_boss(console, player_id):
    """Chama a função do SQL que verifica se há um Boss na sala do Player e retorna mensagens apropriadas."""

    with obter_cursor() as cursor:
        cursor.execute("SELECT * FROM verificar_boss_sala(%s);", (player_id,))
        boss = cursor.fetchone()

        if boss:
            id_boss, nome_boss, hp_atual, id_missao, status_missao, id_missao_anterior, nome_missao_anterior = boss

            if hp_atual <= 0:
                console.print(Panel(
                    f"[bold red]☠️ Você sente um silêncio mortal na sala... {nome_boss} já foi derrotado.[/bold red]", 
                    expand=False
                ))
                return None

            if id_missao_anterior and nome_missao_anterior and status_missao == 'ni':
                console.print(Panel(
                    f"[bold yellow]⚠️ Você precisa completar a missão [cyan]{nome_missao_anterior}[/cyan] antes de enfrentar [red]{nome_boss}[/red]![/bold yellow]", 
                    expand=False
                ))
                return None

            if id_missao and status_missao == 'ni':
                console.print(Panel(
                    f"[bold yellow]⚠️ {nome_boss} está aqui, mas você não aceitou a missão para enfrentá-lo![/bold yellow]", 
                    expand=False
                ))
                return None

            return id_boss  # Retorna o ID do Boss que pode ser enfrentado
        
        console.print("[bold green]✅ Nenhum Boss nesta sala. Você está seguro... por enquanto.[/bold green]")
        return None
