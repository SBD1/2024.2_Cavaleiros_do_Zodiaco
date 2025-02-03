from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def listar_equipamentos(console, jogador_id):
    """
    Lista as armaduras equipadas e armazenadas no inventário de um jogador.
    Permite equipar um equipamento do inventário.
    """

    try:
        with obter_cursor() as cursor:
            # Buscar armaduras equipadas
            cursor.execute("""
                SELECT 
                    ai.id_armadura,
                    ai.id_parte_corpo_armadura,
                    ai.id_instancia,
                    ai.raridade_armadura,
                    ai.durabilidade_atual,
                    ai.ataque_fisico,
                    ai.ataque_magico,
                    ai.defesa_fisica,
                    ai.defesa_magica,
                    pcp.parte_corpo
                FROM Armadura_Instancia ai
                INNER JOIN Parte_Corpo_Player pcp
                    ON ai.id_armadura = pcp.armadura_equipada
                    AND ai.id_instancia = pcp.instancia_armadura_equipada
                    AND ai.id_parte_corpo_armadura = pcp.parte_corpo
                WHERE pcp.id_player = %s
                ORDER BY pcp.parte_corpo;
            """, (jogador_id,))
            armaduras_equipadas = cursor.fetchall()

            # Buscar armaduras no inventário
            cursor.execute("""
                SELECT 
                    ai.id_armadura,
                    ai.id_parte_corpo_armadura,
                    ai.id_instancia,
                    ai.raridade_armadura,
                    ai.durabilidade_atual,
                    ai.ataque_fisico,
                    ai.ataque_magico,
                    ai.defesa_fisica,
                    ai.defesa_magica
                FROM Armadura_Instancia ai
                INNER JOIN Inventario i
                    ON ai.id_inventario = i.id_player
                WHERE i.id_player = %s
                ORDER BY ai.id_instancia, ai.id_parte_corpo_armadura;
            """, (jogador_id,))
            armaduras_inventario = cursor.fetchall()

            # Exibir armaduras equipadas
            if armaduras_equipadas:
                tabela_equipadas = Table(title="⚔️ Armaduras Equipadas", show_lines=True)
                tabela_equipadas.add_column("Parte do Corpo", style="magenta", justify="left")
                tabela_equipadas.add_column("Raridade", style="cyan", justify="center")
                tabela_equipadas.add_column("Durabilidade", style="yellow", justify="center")
                tabela_equipadas.add_column("Ataque Físico", style="green", justify="center")
                tabela_equipadas.add_column("Ataque Mágico", style="blue", justify="center")
                tabela_equipadas.add_column("Defesa Física", style="red", justify="center")
                tabela_equipadas.add_column("Defesa Mágica", style="purple", justify="center")

                for armadura in armaduras_equipadas:
                    _, parte_corpo, _, raridade, durabilidade, ataque_fisico, ataque_magico, defesa_fisica, defesa_magica, _ = armadura
                    tabela_equipadas.add_row(
                        parte_corpo, str(raridade), str(durabilidade),
                        str(ataque_fisico), str(ataque_magico),
                        str(defesa_fisica), str(defesa_magica)
                    )
                console.print(tabela_equipadas)
            else:
                console.print(Panel.fit("🔍 [bold yellow]Nenhuma armadura equipada![/bold yellow]", border_style="yellow"))

            # Exibir armaduras no inventário
            if armaduras_inventario:
                tabela_inventario = Table(title="🎒 Armaduras no Inventário", show_lines=True)
                tabela_inventario.add_column("ID Instância", style="cyan", justify="left")
                tabela_inventario.add_column("Parte do Corpo", style="magenta", justify="left")
                tabela_inventario.add_column("Raridade", style="cyan", justify="center")
                tabela_inventario.add_column("Durabilidade", style="yellow", justify="center")
                tabela_inventario.add_column("Ataque Físico", style="green", justify="center")
                tabela_inventario.add_column("Ataque Mágico", style="blue", justify="center")
                tabela_inventario.add_column("Defesa Física", style="red", justify="center")
                tabela_inventario.add_column("Defesa Mágica", style="purple", justify="center")

                for armadura in armaduras_inventario:
                    _, parte_corpo, id_instancia, raridade, durabilidade, ataque_fisico, ataque_magico, defesa_fisica, defesa_magica = armadura
                    tabela_inventario.add_row(
                        str(id_instancia), parte_corpo, str(raridade),
                        str(durabilidade), str(ataque_fisico), str(ataque_magico),
                        str(defesa_fisica), str(defesa_magica
                        )
                    )
                console.print(tabela_inventario)

                # Perguntar se deseja equipar uma armadura
                console.print("[bold yellow]\nDeseja equipar uma armadura do inventário? (s/n)[/bold yellow]")
                escolha = input("> ").strip().lower()

                if escolha == "s":
                    console.print("[bold green]Digite o ID da instância da armadura que deseja equipar:[/bold green]")
                    id_instancia_equipar = input("> ").strip()

                    if not id_instancia_equipar.isdigit():
                        console.print(Panel.fit(
                            "⛔ [bold red]Entrada inválida! Por favor, insira um número válido.[/bold red]",
                            border_style="red"
                        ))
                        return

                    id_instancia_equipar = int(id_instancia_equipar)

                    cursor.execute("CALL equipar_armadura(%s, %s)", (jogador_id, id_instancia_equipar))
                    cursor.connection.commit()

                    console.print(Panel.fit(
                        "✅ [bold green]A armadura foi equipada com sucesso![/bold green]",
                        border_style="green"
                    ))
                else:
                    console.print("[bold cyan]Você decidiu não equipar nenhuma armadura.[/bold cyan]")
            else:
                console.print(Panel.fit("🎒 [bold yellow]Nenhuma armadura no inventário![/bold yellow]", border_style="yellow"))

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao listar ou equipar armaduras: {e}[/bold red]", border_style="red"))
