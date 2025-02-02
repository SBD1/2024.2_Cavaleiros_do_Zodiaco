from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def ver_grupo(console, player_id):
    """
    Exibe o grupo do jogador e permite trocar cavaleiros dentro da party.
    """

    try:
        with obter_cursor() as cursor:

            cursor_name = "grupo_cursor"
            cursor.connection.autocommit = False  

            cursor.execute("CALL get_grupo_cursor(%s, %s);", (player_id, cursor_name))
            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            grupo = cursor.fetchall()
            cursor.execute(f"CLOSE {cursor_name};")
            cursor.connection.commit()

            if not grupo:
                console.print(Panel.fit(
                    "🔍 [bold yellow]Nenhum membro do grupo encontrado![/bold yellow]",
                    border_style="yellow"
                ))
                return
            
            ids_cavaleiros_party = {item[0] for item in grupo}

            tabela = Table(title="⚔️ Grupo do Jogador", show_lines=True)
            tabela.add_column("Cavaleiro", style="cyan", justify="center", no_wrap=True)
            tabela.add_column("Elemento", style="blue", justify="center", no_wrap=True)
            tabela.add_column("Nível", style="green", justify="center", no_wrap=True)
            tabela.add_column("XP Atual", style="yellow", justify="center", no_wrap=True)
            tabela.add_column("HP Máx", style="red", justify="center", no_wrap=True)
            tabela.add_column("Magia Máx", style="magenta", justify="center", no_wrap=True)
            tabela.add_column("HP Atual", style="red", justify="center", no_wrap=True)
            tabela.add_column("Magia Atual", style="magenta", justify="center", no_wrap=True)
            tabela.add_column("Velocidade", style="white", justify="center", no_wrap=True)
            tabela.add_column("Ataque Físico", style="orange1", justify="center", no_wrap=True)
            tabela.add_column("Ataque Mágico", style="purple", justify="center", no_wrap=True)

            for item in grupo:
                (
                    id_cavaleiro, nome, elemento, nivel, xp_atual, hp_max, magia_max, 
                    hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico, _
                ) = item  

                tabela.add_row(
                    nome, elemento, str(nivel), str(xp_atual), 
                    str(hp_max), str(magia_max), str(hp_atual), 
                    str(magia_atual), str(velocidade), str(ataque_fisico), str(ataque_magico)
                )

            console.print(tabela)

            console.print("[bold yellow]Deseja trocar cavaleiros na party? (s/n)[/bold yellow]")
            escolha = input("> ").strip().lower()

            if escolha != "s":
                console.print(Panel.fit("✅ [bold green]Nenhuma alteração feita![/bold green]", border_style="green"))
                return

            cursor.execute("SELECT id_cavaleiro, nome FROM get_cavaleiros_disponiveis(%s);", (player_id,))
            cavaleiros_disponiveis = cursor.fetchall()

            console.print("\n[bold red]Escolha um cavaleiro para remover:[/bold red]")
            tabela_party = Table(title="🏰 Cavaleiros na Party", show_lines=True)
            tabela_party.add_column("Opção", style="yellow", justify="center")
            tabela_party.add_column("Nome", style="cyan", justify="left")

            for cavaleiro in grupo:
                tabela_party.add_row(str(cavaleiro[0]), cavaleiro[1])

            console.print(tabela_party)

            escolha_remover = input("> ")

            if not escolha_remover.isdigit():
                console.print(Panel.fit(
                    "⛔ [bold red]Entrada inválida! Digite um número válido.[/bold red]",
                    border_style="red"
                ))
                return

            id_cavaleiro_removido = int(escolha_remover)

            ids_cavaleiros_party.remove(id_cavaleiro_removido)

            cavaleiros_disponiveis = [
                (id_cav, nome) for id_cav, nome in cavaleiros_disponiveis 
                if id_cav not in ids_cavaleiros_party and id_cav != id_cavaleiro_removido
            ]

            console.print("\n[bold green]Escolha um cavaleiro para adicionar à party:[/bold green]")
            tabela_disponiveis = Table(title="🛡️ Cavaleiros Disponíveis", show_lines=True)
            tabela_disponiveis.add_column("Opção", style="yellow", justify="center")
            tabela_disponiveis.add_column("Nome", style="cyan", justify="left")

            for cavaleiro in cavaleiros_disponiveis:
                tabela_disponiveis.add_row(str(cavaleiro[0]), cavaleiro[1])

            console.print(tabela_disponiveis)

            escolha_adicionar = input("> ")

            if not escolha_adicionar.isdigit():
                console.print(Panel.fit(
                    "⛔ [bold red]Entrada inválida! Digite um número válido.[/bold red]",
                    border_style="red"
                ))
                return

            id_cavaleiro_novo = int(escolha_adicionar)

            cursor.execute("CALL trocar_cavaleiro_party(%s, %s, %s);", (player_id, id_cavaleiro_novo, id_cavaleiro_removido))
            cursor.connection.commit()

            console.print(Panel.fit(
                f"✅ [bold green]Cavaleiro foi atualizado na party![/bold green]",
                border_style="green"
            ))

    except Exception as e:
        console.print(Panel.fit(
            f"⛔ [bold red]Erro ao trocar cavaleiro: {e}[/bold red]",
            border_style="red"
        ))
