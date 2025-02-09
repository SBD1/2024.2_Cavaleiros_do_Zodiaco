from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from ..database import obter_cursor

def listar_equipamentos_ferreiro(console, jogador_id):
    """
    Lista as armaduras equipadas primeiro (ordenadas por parte do corpo) e depois as armazenadas no inventário.
    Retorna uma lista numerada com todas as opções disponíveis para seleção.
    """
    try:
        with obter_cursor() as cursor:
            cursor.execute("""
                SELECT 
                    id_instancia,
                    id_armadura,
                    parte_corpo,
                    nome,
                    descricao,
                    raridade_armadura,
                    durabilidade_atual,
                    ataque_fisico,
                    ataque_magico,
                    defesa_fisica,
                    defesa_magica,
                    status_armadura
                FROM armaduras_jogador_view
                WHERE id_player = %s
                ORDER BY 
                    CASE status_armadura 
                        WHEN 'equipada' THEN 1 
                        ELSE 2 
                    END,
                    CASE parte_corpo
                        WHEN 'Cabeça' THEN 1
                        WHEN 'Tronco' THEN 2
                        WHEN 'Braços' THEN 3
                        WHEN 'Pernas' THEN 4
                        ELSE 5
                    END;
            """, (jogador_id,))
            
            armaduras = cursor.fetchall()

            equipamentos_listados = []

            tabela_geral = Table(title="🛡️ Equipamentos do Jogador", show_lines=True)
            tabela_geral.add_column("#", style="cyan", justify="left", max_width=5)
            tabela_geral.add_column("Nome", style="cyan", justify="left", max_width=20)
            tabela_geral.add_column("Parte do\nCorpo", style="magenta", justify="left", max_width=10)
            tabela_geral.add_column("Raridade", justify="center", max_width=10)
            tabela_geral.add_column("Descrição", style="cyan", justify="left", max_width=50)
            tabela_geral.add_column("Durabilidade", style="yellow", justify="center", max_width=12)
            tabela_geral.add_column("Ataque\nFísico", style="green", justify="center", max_width=10)
            tabela_geral.add_column("Ataque\nMágico", style="blue", justify="center", max_width=10)
            tabela_geral.add_column("Defesa\nFísica", style="red", justify="center", max_width=10)
            tabela_geral.add_column("Defesa\nMágica", style="purple", justify="center", max_width=10)
            tabela_geral.add_column("Status", style="bold white", justify="center", max_width=12)

            indice = 1

            for armadura in armaduras:
                id_instancia, id_armadura, parte_corpo, nome, descricao, raridade, durabilidade, ataque_fisico, ataque_magico, defesa_fisica, defesa_magica, status = armadura

                tabela_geral.add_row(
                    str(indice), str(nome), str(parte_corpo), str(raridade),
                    str(descricao), str(durabilidade), str(ataque_fisico), str(ataque_magico),
                    str(defesa_fisica), str(defesa_magica), f"[bold green]{status}[/bold green]" if status == "equipada" else f"[bold yellow]{status}[/bold yellow]"
                )

                equipamentos_listados.append({
                    "indice": indice,
                    "id_instancia": id_instancia,
                    "nome": nome,
                    "parte_corpo": parte_corpo,
                    "status": status
                })

                indice += 1

            console.print(tabela_geral)

            return equipamentos_listados, tabela_geral
    
    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao listar armaduras: {e}[/bold red]", border_style="red"))
        return []
