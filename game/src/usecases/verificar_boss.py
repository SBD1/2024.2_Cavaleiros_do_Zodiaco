from ..database import obter_cursor 

def verificar_boss(console, player_id):
   
    try:
        with obter_cursor() as cursor:
            try:
                cursor.execute("SELECT player_tem_boss(%s);", (player_id,))
                return cursor.fetchone()[0]  

            except Exception as e:
                console.print(f"[bold red]Erro ao verificar boss: {e.diag.message_primary}[/bold red]")
                return None  

    except Exception as e:
        console.print(f"[bold red]Erro de conexão com o banco de dados: {str(e)}[/bold red]")
        return None  
