
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def ver_missoes(console, player_id):


    try:
        with obter_cursor() as cursor:
            cursor_name = "missoes"
            cursor.connection.autocommit = False  
            cursor.execute("CALL get_missoes_cursor(%s, %s);", (player_id, cursor_name))
            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            missoes = cursor.fetchall()

            cursor.execute(f"CLOSE {cursor_name};")
            cursor.connection.commit()



            # if not missoes:
            #     console.print(Panel.fit(
            #         "🔍 [bold yellow]Nenhum item encontrado no inventário![/bold yellow]",
            #         border_style="yellow"
            #     ))
            #     return
            
            # Criando a tabela para exibição
            missoes_iniciadas = Table(title=f"Missões Iniciadas", show_lines=True)
            missoes_iniciadas.add_column("Nome", style="cyan", justify="left")
            missoes_iniciadas.add_column("Descrição", style="green", justify="left")
            missoes_iniciadas.add_column("Item Necessário", style="white", justify="left")
            missoes_iniciadas.add_column("Local", style="magenta", justify="left")

            missoes_concluidas = Table(title=f"Missões Concluídas", show_lines=True)
            missoes_concluidas.add_column("Nome", style="cyan", justify="left")
            missoes_concluidas.add_column("Descrição", style="green", justify="left")
            missoes_concluidas.add_column("Item Necessário", style="white", justify="left")
            missoes_concluidas.add_column("Local", style="magenta", justify="left")

            # Preenchendo a tabela com os dados do inventário
            for missao in missoes:
                nome, descricao_durante, descricao_final, status_missao, nome_item, nome_sala, nome_casa, nome_saga = missao  
                if status_missao == 'i':
                     missoes_iniciadas.add_row(nome, f"{descricao_durante}", f"{nome_item}", f"Saga: {nome_saga} \n Casa: {nome_casa} \n Sala: {nome_sala}")
                elif status_missao == 'c':
                    missoes_concluidas.add_row(nome, f"{descricao_final}", f"{nome_item}", f"Saga: {nome_saga} \n Casa: {nome_casa} \n Sala: {nome_sala}")
            # Exibindo a tabela no terminal
            console.print(missoes_iniciadas)
            console.print(missoes_concluidas)

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao recuperar missões: {e}[/bold red]",
            border_style="red"
        ))
