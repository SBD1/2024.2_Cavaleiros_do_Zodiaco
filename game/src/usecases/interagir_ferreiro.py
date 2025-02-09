from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from .listar_todas_receitas_armaduras import listar_todas_receitas_armaduras
from .fabricar_armadura import fabricar_armadura
from .listar_equipamentos import listar_equipamentos

from ..util import limpar_terminal
from ..database import obter_cursor


def interagir_ferreiro(console, jogador_id):
    """
    Interação com o NPC Ferreiro para fabricar, restaurar durabilidade, melhorar raridade ou desmanchar armaduras.
    """

    try:
        with obter_cursor() as cursor:
            # Buscar informações do NPC Ferreiro
            cursor.execute("""
                SELECT nome, descricao, dialogo_inicial, dialogo_reparar, dialogo_upgrade, dialogo_desmanchar, dialogo_sair 
                FROM ferreiro LIMIT 1
            """)
            npc = cursor.fetchone()

            if not npc:
                console.print("[bold red]❌ Erro: NPC Ferreiro não encontrado![/bold red]")
                return

            nome_npc, _, dialogo_inicial, dialogo_reparar, dialogo_upgrade, dialogo_desmanchar, dialogo_sair = npc

            while True:  # Loop para manter o jogador na forja até ele escolher sair
                limpar_terminal(console)
                console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_inicial}[/italic]", expand=False))

                listar_equipamentos(console, jogador_id)

                # Opções do jogador
                console.print("\n[bold cyan]Escolha uma ação:[/bold cyan]")
                console.print("[bold yellow]1.[/bold yellow] Restaurar Durabilidade")
                console.print("[bold green]2.[/bold green] Melhorar Armadura (Aumentar Raridade)")
                console.print("[bold red]3.[/bold red] Desmanchar Armadura em Alma de Armadura")
                console.print("[bold blue]4.[/bold blue] Fabricar uma nova armadura")
                console.print("[bold white]5.[/bold white] Sair")

                escolha = input("\n🛠️ Escolha uma opção: ").strip()

                if escolha == "5":
                    limpar_terminal(console)
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_sair}[/italic]", expand=False))
                    console.print("[bold white]Você saiu da forja.[/bold white]")
                    break  # Sai do loop e retorna ao jogo

                if escolha not in ["1", "2", "3", "4"]:
                    console.print("[bold red]❌ Opção inválida![/bold red]")
                    continue  # Volta ao menu

                # Exibir diálogo do NPC para a ação escolhida
                limpar_terminal(console)

                if escolha == "1":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_reparar}[/italic]", expand=False))
                    mensagem_id = "Digite o ID da armadura que deseja reparar:"
                elif escolha == "2":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_upgrade}[/italic]", expand=False))
                    mensagem_id = "Digite o ID da armadura que deseja melhorar:"
                elif escolha == "3":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]{dialogo_desmanchar}[/italic]", expand=False))
                    mensagem_id = "Digite o ID da armadura que deseja desmanchar:"
                elif escolha == "4":
                    console.print(Panel(f"[bold cyan]{nome_npc}[/bold cyan]: [italic]Vamos fabricar uma nova armadura![/italic]", expand=False))
                    fabricar_armadura(console, jogador_id)
                    continue  # Volta ao menu após fabricar

                # Solicitar o ID da armadura apenas para as opções 1, 2 e 3
                if escolha in ["1", "2", "3"]:
                    console.print(f"\n[bold cyan]{mensagem_id}[/bold cyan]")
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
                        console.print(Panel.fit(f"⛔ [bold red]Erro ao executar a ação: {e}[/bold red]", border_style="red"))

                    # Pausar para que o jogador veja o resultado
                    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                    input()

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao interagir com o ferreiro: {e}[/bold red]", border_style="red"))
