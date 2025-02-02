from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor



# Função para interagir com Saori Kido e listar missões disponíveis
def interagir_npc_quest(console,selected_player_id):
    with obter_cursor() as cursor:
        try:

            cursor.execute("SELECT nome, dialogo_inicial FROM npc_quest LIMIT 1")
            npc = cursor.fetchone()

            if not npc:
                console.print("[bold red]❌ Erro: NPC não encontrado![/bold red]")
                return

            nome_npc, dialogo_inicial = npc

            # Exibir diálogo inicial do NPC
            console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_inicial}[/italic]", expand=False))

            # Buscar missões disponíveis para o jogador
            cursor.execute("""
                SELECT m.id_missao, m.nome
                FROM Missao m
                LEFT JOIN Player_missao pm ON m.id_missao = pm.id_missao AND pm.id_player = 1
                LEFT JOIN Player_missao pm_anterior ON m.id_missao_anterior = pm_anterior.id_missao AND pm_anterior.id_player = 1
                WHERE (m.id_missao_anterior IS NULL  -- Missões sem pré-requisito
                    OR pm_anterior.status_missao = 'c')  -- Ou missões cuja anterior foi concluída
                AND (pm.status_missao IS NULL OR pm.status_missao = 'ni');  -- Apenas missões não iniciadas


            """, (selected_player_id,))
            
            missoes = cursor.fetchall()

            if not missoes:
                console.print("[bold yellow]⚠ Nenhuma missão disponível no momento.[/bold yellow]")
                return

            # Criar tabela com as missões disponíveis
            table = Table(title="📜 Missões Disponíveis")
            table.add_column("#", justify="center", style="bold")
            table.add_column("Nome da Missão", style="cyan")

            for idx, (id_missao, nome_missao) in enumerate(missoes, start=1):
                table.add_row(str(idx), nome_missao)

            console.print(table)

            # Opções do jogador
            console.print("\n[bold green]Digite o número da missão para aceitar ou 'T' para aceitar todas.[/bold green]")
            escolha = input("🎯 Escolha uma opção: ").strip().lower()

            if escolha == 't':
                for id_missao, _ in missoes:
                    cursor.execute("""
                        UPDATE Player_missao 
                        SET status_missao = 'i' 
                        WHERE id_player = %s AND id_missao = %s;
                    """, (selected_player_id, id_missao))
                console.print("[bold green]✅ Todas as missões foram aceitas![/bold green]")
            
            elif escolha.isdigit():
                escolha = int(escolha)
                if 1 <= escolha <= len(missoes):
                    id_missao_escolhida = missoes[escolha - 1][0]
                    cursor.execute("""
                        UPDATE Player_missao 
                        SET status_missao = 'i' 
                        WHERE id_player = %s AND id_missao = %s;
                    """, (selected_player_id, id_missao_escolhida))
                    console.print(f"[bold green]✅ Missão '{missoes[escolha - 1][1]}' aceita![/bold green]")
                else:
                    console.print("[bold red]❌ Opção inválida![/bold red]")


        except Exception as e:
            console.print(f"[bold red]Erro:[/bold red] {e}")


