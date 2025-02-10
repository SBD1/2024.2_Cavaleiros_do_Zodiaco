from ..database import obter_cursor 

def verificar_boss(console, player_id):
   
    try:
        with obter_cursor() as cursor:
            try:
                cursor.execute("SELECT player_tem_boss(%s);", (player_id,))
                boss_id = cursor.fetchone()[0]  
                if boss_id is not None:
                # Verificar se o boss está vivo
                    cursor.execute("SELECT boss_hp_atual, boss_nome FROM boss_info_view WHERE id_boss = %s;", (boss_id,))
                    boss_hp, boss_nome = cursor.fetchone()
                    if boss_hp > 0:
                        console.print(f"[bold yellow]⚔️ O boss {boss_nome} iniciou um combate![/bold yellow]")
                        console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                        input()
                        return boss_id

            except Exception as e:
                console.print(f"[bold red]Erro ao verificar boss: {e.diag.message_primary}[/bold red]")
                return None  

    except Exception as e:
        console.print(f"[bold red]Erro de conexão com o banco de dados: {str(e)}[/bold red]")
        return None  
