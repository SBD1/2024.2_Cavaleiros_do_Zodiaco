from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from ..util import limpar_terminal
from ..database import obter_cursor

def interagir_npc_ferreiro(console, jogador_id):
    """
    Interação com o NPC Ferreiro para restaurar durabilidade, melhorar raridade ou desmanchar armaduras.
    """

    try:
        with obter_cursor() as cursor:
            # Buscar informações do NPC Ferreiro
            cursor.execute("""
                SELECT nome, descricao, dialogo_inicial, dialogo_reparar, dialogo_upgrade, dialogo_desmanchar, dialogo_sair 
                FROM npc_ferreiro LIMIT 1
            """)
            npc = cursor.fetchone()

            if not npc:
                console.print("[bold red]❌ Erro: NPC Ferreiro não encontrado![/bold red]")
                return

            nome_npc, _, dialogo_inicial, dialogo_reparar, dialogo_upgrade, dialogo_desmanchar, dialogo_sair = npc

            while True:  # Loop para manter o jogador na forja até ele escolher sair
                limpar_terminal(console)
                console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_inicial}[/italic]", expand=False))

                # Buscar todas as armaduras do jogador através da VIEW
                cursor.execute("""
                    SELECT 
                        id_instancia,
                        id_parte_corpo_armadura,
                        raridade_armadura,
                        durabilidade_atual,
                        status_armadura
                    FROM armaduras_jogador_view
                    WHERE id_player = %s
                    ORDER BY status_armadura DESC, raridade_armadura DESC;
                """, (jogador_id,))
                
                armaduras = cursor.fetchall()

                if not armaduras:
                    console.print(Panel.fit("🔍 [bold yellow]Você não possui armaduras disponíveis![/bold yellow]", border_style="yellow"))
                    return

                # Criar tabela de armaduras disponíveis
                tabela_armaduras = Table(title="🛠️ Armaduras no Ferreiro", show_lines=True)
                tabela_armaduras.add_column("ID Instância", style="cyan", justify="center")
                tabela_armaduras.add_column("Parte do Corpo (ID)", style="magenta", justify="left")
                tabela_armaduras.add_column("Raridade", style="cyan", justify="center")
                tabela_armaduras.add_column("Durabilidade", style="yellow", justify="center")
                tabela_armaduras.add_column("Status", style="white", justify="center")

                for armadura in armaduras:
                    id_instancia, id_parte_corpo_armadura, raridade, durabilidade, status = armadura
                    tabela_armaduras.add_row(
                        str(id_instancia), str(id_parte_corpo_armadura), str(raridade),
                        str(durabilidade), status
                    )

                console.print(tabela_armaduras)

                # Opções do jogador
                console.print("\n[bold cyan]Escolha uma ação:[/bold cyan]")
                console.print("[bold yellow]1.[/bold yellow] Restaurar Durabilidade")
                console.print("[bold green]2.[/bold green] Melhorar Armadura (Aumentar Raridade)")
                console.print("[bold red]3.[/bold red] Desmanchar Armadura em Alma de Armadura")
                console.print("[bold white]4.[/bold white] Sair")

                escolha = input("\n🛠️ Escolha uma opção: ").strip()

                if escolha == "4":
                    limpar_terminal(console)
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_sair}[/italic]", expand=False))
                    console.print("[bold white]Você saiu da forja.[/bold white]")
                    break  # Sai do loop e retorna ao jogo

                if escolha not in ["1", "2", "3"]:
                    console.print("[bold red]❌ Opção inválida![/bold red]")
                    continue  # Volta ao menu

                # Exibir diálogo do NPC para a ação escolhida
                limpar_terminal(console)
                if escolha == "1":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_reparar}[/italic]", expand=False))
                elif escolha == "2":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_upgrade}[/italic]", expand=False))
                elif escolha == "3":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_desmanchar}[/italic]", expand=False))

                # Solicitar ID da armadura
                console.print("\n[bold cyan]Digite o ID da instância da armadura que deseja modificar:[/bold cyan]")
                id_instancia_escolhida = input("> ").strip()

                if not id_instancia_escolhida.isdigit():
                    console.print(Panel.fit("⛔ [bold red]Entrada inválida![/bold red]", border_style="red"))
                    continue

                id_instancia_escolhida = int(id_instancia_escolhida)

                # Chamar a procedure correta de acordo com a escolha
                try:
                    if escolha == "1":
                        cursor.execute("CALL restaurar_durabilidade(%s, %s);", (jogador_id, id_instancia_escolhida))
                        console.print("[bold green]✅ Durabilidade restaurada com sucesso![/bold green]")
                    
                    elif escolha == "2":
                        cursor.execute("CALL melhorar_armadura(%s, %s);", (jogador_id, id_instancia_escolhida))
                        console.print("[bold green]✅ Armadura melhorada com sucesso! Durabilidade restaurada para 100%.[/bold green]")
                    
                    elif escolha == "3":
                        cursor.execute("CALL desmanchar_armadura(%s, %s);", (jogador_id, id_instancia_escolhida))
                        console.print("[bold green]✅ Armadura desmanchada! Você recebeu Almas de Armadura.[/bold green]")

                    cursor.connection.commit()
                
                except Exception as e:
                    # Captura a mensagem do RAISE EXCEPTION corretamente
                    
                    console.print(Panel.fit(f"⛔ [bold red]Erro: {e.diag.message_primary}[/bold red]", border_style="red"))

                # Pausar para que o jogador veja o resultado
                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                input()

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao interagir com o ferreiro: {e}[/bold red]", border_style="red"))
