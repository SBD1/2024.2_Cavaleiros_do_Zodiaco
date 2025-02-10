from src.util import limpar_terminal
from ..database import obter_cursor 
from rich.columns import Columns
from rich.panel import Panel
from rich.table import Table
from rich.console import Console



def iniciar_batalha(console: Console, player_id: int, boss_id: int):
    while True:
        dados_batalha = obter_dados_batalha(player_id, boss_id)

        if not dados_batalha:
            console.print("[bold red]Erro ao carregar os dados da batalha.[/bold red]")
            return

        exibir_tabela_batalha(console, dados_batalha["player"], dados_batalha["cavaleiros"], dados_batalha["boss"])

        console.print("[bold green]✅ Pressione ENTER para começar os turnos...[/bold green]")
        input()


        executar_turnos(console, **dados_batalha)

def obter_dados_batalha(player_id: int, boss_id: int):
    """
    Obtém os dados necessários para a batalha, incluindo:
    - Player e suas partes do corpo (com armaduras equipadas)
    - Cavaleiros da party e suas partes do corpo
    - Boss e suas partes do corpo
    """
    try:
        with obter_cursor() as cursor:
            dados_batalha = {}

            # Obter informações do Player
            cursor.execute("SELECT * FROM player_info_view WHERE id_player = %s;", (player_id,))
            dados_batalha["player"] = cursor.fetchone()

            # Obter partes do corpo do Player com armaduras
            cursor.execute("SELECT * FROM player_parte_corpo_info_view WHERE id_player = %s;", (player_id,))
            dados_batalha["player_partes_corpo"] = cursor.fetchall()

            # Obter Cavaleiros na Party do Player
            cursor.execute("SELECT * FROM party_cavaleiros_view WHERE id_player = %s;", (player_id,))
            cavaleiros = cursor.fetchall()
            dados_batalha["cavaleiros"] = cavaleiros

            # Obter partes do corpo de cada Cavaleiro
            cavaleiros_partes_corpo = {}
            for cavaleiro in cavaleiros:
                cavaleiro_id = cavaleiro[0]
                cursor.execute("SELECT * FROM cavaleiro_parte_corpo_info_view WHERE id_cavaleiro = %s;", (cavaleiro_id,))
                cavaleiros_partes_corpo[cavaleiro_id] = cursor.fetchall()
            dados_batalha["cavaleiros_partes_corpo"] = cavaleiros_partes_corpo

            # Obter informações do Boss
            cursor.execute("SELECT * FROM boss_info_view WHERE id_boss = %s;", (boss_id,))
            dados_batalha["boss"] = cursor.fetchone()

            # Obter partes do corpo do Boss
            cursor.execute("SELECT * FROM boss_parte_corpo_info_view WHERE id_boss = %s;", (boss_id,))
            dados_batalha["boss_partes_corpo"] = cursor.fetchall()

            return dados_batalha

    except Exception as e:
        print(f"Erro ao obter dados da batalha: {str(e)}")
        return None



def exibir_tabela_batalha(console, player_info, cavaleiros, boss_info):
    limpar_terminal(console)
    (
        id_boss, nome_boss, nivel_boss, xp_acumulado_boss, 
        hp_max_boss, hp_atual_boss, magia_max_boss, magia_atual_boss, 
        velocidade_boss, ataque_fisico_boss, ataque_magico_boss, dinheiro_boss, 
        fala_inicio_boss, fala_derrotar_player_boss, fala_derrotado_boss, fala_condicao_boss, elemento_boss, id_fraqueza_boss, id_vantagem_boss
    ) = boss_info
    console.print(Panel(f"[bold red]{nome_boss}[/bold red]: [italic]{fala_inicio_boss}[/italic]", expand=False))
    # Criando tabela para Player e Cavaleiros
    tabela_party = Table(title="👥 Equipe", show_header=True, header_style="bold cyan", show_lines=True)
    
    tabela_party.add_column("#", style="bold yellow", justify="center")
    tabela_party.add_column("Nome", style="cyan", justify="center", max_width=10)
    tabela_party.add_column("Elemento", style="blue", justify="center")
    tabela_party.add_column("Lvl", style="green", justify="center")
    tabela_party.add_column("HP", style="red", justify="center")
    tabela_party.add_column("Cosmo", style="magenta", justify="center")
    tabela_party.add_column("Vel.", style="white", justify="center")
    tabela_party.add_column("Atk\nFis.", style="orange1", justify="center")
    tabela_party.add_column("Atk\nMág.", style="purple", justify="center")

    (
        id_player, player_nome, player_nivel, player_xp_atual,
        player_hp_max, player_magia_max, player_hp_atual, player_magia_atual,
        player_velocidade, ataque_fisico_base, ataque_magico_base,
        ataque_fisico_armaduras, ataque_magico_armaduras,
        ataque_fisico_total, ataque_magico_total,
        id_elemento, elemento_player, dinheiro, alma_armadura, id_fraqueza_player, id_vantagem_player
    ) = player_info

    # Adicionar o player à tabela_party
    tabela_party.add_row(
        "—", player_nome, elemento_player, str(player_nivel),  # Nome, Elemento, Nível
        f"{player_hp_max}/{player_hp_atual}",  # HP Atual / Máximo
        f"{player_magia_max}/{player_magia_atual}",  # Magia Atual / Máximo
        str(player_velocidade),  # Velocidade
        f"{ataque_fisico_total}",  # Ataque Físico (Total e Base)
        f"{ataque_magico_total}"   # Ataque Mágico (Total e Base)
    )

    for i, cavaleiro in enumerate(cavaleiros, start=1):
        (
            id_cavaleiro, id_player, id_party, cavaleiro_nome, cavaleiro_nivel, 
            tipo_armadura, cavaleiro_xp_atual, cavaleiro_hp_max, cavaleiro_hp_atual, 
            cavaleiro_magia_max, cavaleiro_magia_atual, cavaleiro_velocidade, 
            cavaleiro_ataque_fisico, cavaleiro_ataque_magico, elemento_cavaleiro, id_fraqueza_cavaleiro, id_vantagem_cavaleiro
        ) = cavaleiro

        # Adicionar o cavaleiro à tabela_party
        tabela_party.add_row(
            str(i), cavaleiro_nome,  elemento_cavaleiro, str(cavaleiro_nivel),  # Nome, Tipo, Nível
            f"{cavaleiro_hp_max}/{cavaleiro_hp_atual}",  # HP Atual / Máximo
            f"{cavaleiro_magia_max}/{cavaleiro_magia_atual}",  # Magia Atual / Máximo
            str(cavaleiro_velocidade),  # Velocidade
            str(cavaleiro_ataque_fisico),  # Ataque Físico
            str(cavaleiro_ataque_magico)   # Ataque Mágico
        )

    # Criando tabela para o Boss
    tabela_boss = Table(title="👹 Boss", show_header=True, header_style="bold red", show_lines=True)

    tabela_boss.add_column("Nome", style="red", justify="center")
    tabela_boss.add_column("Elemento", style="blue", justify="center")
    tabela_boss.add_column("Lvl", style="green", justify="center")
    tabela_boss.add_column("HP", style="red", justify="center")
    tabela_boss.add_column("Cosmo", style="magenta", justify="center")
    tabela_boss.add_column("Vel.", style="white", justify="center")
    tabela_boss.add_column("Atk\nFis.", style="orange1", justify="center")
    tabela_boss.add_column("Atk\nMág.", style="purple", justify="center")



    tabela_boss.add_row(
        nome_boss, elemento_boss, str(nivel_boss),  # Nome, Elemento, Nível (Convertido para string)
        f"{hp_max_boss}/{hp_atual_boss}",  # HP Atual / Máximo
        f"{magia_max_boss}/{magia_atual_boss}",  # Cosmo Atual / Máximo
        str(velocidade_boss),  # Velocidade (Convertido para string)
        str(ataque_fisico_boss),  # Ataque Físico (Convertido para string)
        str(ataque_magico_boss)  # Ataque Mágico (Convertido para string)
    )


    # Exibir tabelas lado a lado
    painel = Panel(
        Columns(
            [
                tabela_party,
                tabela_boss
            ],
            expand=True
        ),  # ✅ Aqui está a correção
        title="⚔️ [bold yellow]Batalha Iniciada![/bold yellow] ⚔️",
        title_align="center"
    )

    console.print(painel)
