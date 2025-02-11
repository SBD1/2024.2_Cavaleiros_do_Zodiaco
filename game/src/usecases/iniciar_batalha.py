import time
from src.util import limpar_terminal
from ..database import obter_cursor 
from rich.columns import Columns
from rich.panel import Panel
from rich.table import Table
from rich.console import Console
from .tocar_musica import tocar_musica, tocar_efeito_sonoro, parar_musica

def iniciar_batalha(console: Console, player_id: int, boss_id: int):
    # Inicia a música de batalha
    tocar_musica("batalha_boss.mp3")
    dados_batalha = obter_dados_batalha(player_id, boss_id)
    if not dados_batalha:
        console.print("[bold red]Erro ao carregar os dados da batalha.[/bold red]")
        return

    # Exibe a tabela inicial da batalha
    exibir_tabela_batalha(console, dados_batalha["player"], dados_batalha["cavaleiros"], dados_batalha["boss"])
    console.print("[bold green]✅ Pressione ENTER para começar os turnos...[/bold green]")
    input()
    
    executar_turnos(console, dados_batalha["player"], dados_batalha["cavaleiros"], dados_batalha["boss"])
    parar_musica()


def obter_dados_batalha(player_id: int, boss_id: int):
    """
    Obtém os dados necessários para a batalha:
    - Informações do Player e suas partes do corpo (com armaduras);
    - Dados dos Cavaleiros da party e suas partes do corpo;
    - Dados do Boss e suas partes do corpo.
    """
    try:
        with obter_cursor() as cursor:
            dados_batalha = {}

            # Player
            cursor.execute("SELECT * FROM player_info_view WHERE id_player = %s;", (player_id,))
            dados_batalha["player"] = cursor.fetchone()

            cursor.execute("SELECT * FROM player_parte_corpo_info_view WHERE id_player = %s;", (player_id,))
            dados_batalha["player_partes_corpo"] = cursor.fetchall()

            # Cavaleiros
            cursor.execute("SELECT * FROM party_cavaleiros_view WHERE id_player = %s;", (player_id,))
            cavaleiros = cursor.fetchall()
            dados_batalha["cavaleiros"] = cavaleiros

            cavaleiros_partes_corpo = {}
            for cavaleiro in cavaleiros:
                cavaleiro_id = cavaleiro[0]
                cursor.execute("SELECT * FROM cavaleiro_parte_corpo_info_view WHERE id_cavaleiro = %s;", (cavaleiro_id,))
                cavaleiros_partes_corpo[cavaleiro_id] = cursor.fetchall()
            dados_batalha["cavaleiros_partes_corpo"] = cavaleiros_partes_corpo

            # Boss
            cursor.execute("SELECT * FROM boss_info_view WHERE id_boss = %s;", (boss_id,))
            dados_batalha["boss"] = cursor.fetchone()

            cursor.execute("SELECT * FROM boss_parte_corpo_info_view WHERE id_boss = %s;", (boss_id,))
            dados_batalha["boss_partes_corpo"] = cursor.fetchall()

            return dados_batalha

    except Exception as e:
        print(f"Erro ao obter dados da batalha: {str(e)}")
        return None


def exibir_tabela_batalha(console, player_info, cavaleiros, boss_info):
    """
    Exibe uma tabela lado a lado com os dados da equipe (player e cavaleiros)
    e do Boss.
    """
    limpar_terminal(console)
    
    # Desempacotando os dados do Boss (ordem conforme sua view no banco)
    (
        id_boss, nome_boss, nivel_boss, xp_acumulado_boss, 
        hp_max_boss, hp_atual_boss, magia_max_boss, magia_atual_boss, 
        velocidade_boss, ataque_fisico_boss, ataque_magico_boss, dinheiro_boss, 
        fala_inicio_boss, fala_derrotar_player_boss, fala_derrotado_boss, 
        fala_condicao_boss, elemento_boss, id_fraqueza_boss, id_vantagem_boss
    ) = boss_info

    console.print(Panel(f"[bold red]{nome_boss}[/bold red]: [italic]{fala_inicio_boss}[/italic]", expand=False))

    # Tabela da equipe (Player e Cavaleiros)
    tabela_party = Table(title="👥 Equipe", show_header=True, header_style="bold cyan", show_lines=True)
    tabela_party.add_column("#", style="bold yellow", justify="center")
    tabela_party.add_column("Nome", style="cyan", justify="center", max_width=10)
    tabela_party.add_column("Classe", style="blue", justify="center")
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

    tabela_party.add_row(
        "—", player_nome, "-", elemento_player, str(player_nivel),
        f"{player_hp_max}/{player_hp_atual}",
        f"{player_magia_max}/{player_magia_atual}",
        str(player_velocidade),
        f"{ataque_fisico_total}",
        f"{ataque_magico_total}"
    )

    for i, cavaleiro in enumerate(cavaleiros, start=1):
        (
            id_cavaleiro, id_player, id_party, cavaleiro_nome, cavaleiro_nivel, 
            tipo_armadura, cavaleiro_xp_atual, cavaleiro_hp_max, cavaleiro_hp_atual, 
            cavaleiro_magia_max, cavaleiro_magia_atual, cavaleiro_velocidade, 
            cavaleiro_ataque_fisico, cavaleiro_ataque_magico, elemento_cavaleiro, 
            id_fraqueza_cavaleiro, id_vantagem_cavaleiro, cavaleiro_classe, cavaleiro_classe_id, cavaleiro_elemento_id
        ) = cavaleiro

        tabela_party.add_row(
            str(i), cavaleiro_nome, cavaleiro_classe, elemento_cavaleiro, str(cavaleiro_nivel),
            f"{cavaleiro_hp_max}/{cavaleiro_hp_atual}",
            f"{cavaleiro_magia_max}/{cavaleiro_magia_atual}",
            str(cavaleiro_velocidade),
            str(cavaleiro_ataque_fisico),
            str(cavaleiro_ataque_magico)
        )

    # Tabela do Boss
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
        nome_boss, elemento_boss, str(nivel_boss),
        f"{hp_max_boss}/{hp_atual_boss}",
        f"{magia_max_boss}/{magia_atual_boss}",
        str(velocidade_boss),
        str(ataque_fisico_boss),
        str(ataque_magico_boss)
    )

    painel = Panel(
        Columns([tabela_party, tabela_boss], expand=True),
        title="⚔️ [bold yellow]Batalha Iniciada![/bold yellow] ⚔️",
        title_align="center"
    )
    console.print(painel)


def criar_fila_turnos(player, cavaleiros, boss):
    """
    Cria a fila de turnos com base na velocidade dos participantes.
    """
    fila = []

    (
        id_player, player_nome, player_nivel, player_xp_atual,
        player_hp_max, player_magia_max, player_hp_atual, player_magia_atual,
        player_velocidade, ataque_fisico_base, ataque_magico_base,
        ataque_fisico_armaduras, ataque_magico_armaduras,
        ataque_fisico_total, ataque_magico_total,
        id_elemento, elemento_player, dinheiro, alma_armadura, id_fraqueza_player, id_vantagem_player
    ) = player

    fila.append({
        "id": id_player,
        "nome": player_nome,
        "tipo": "player",
        "velocidade": player_velocidade,
        "hp": player_hp_atual
    })

    if cavaleiros:
        for i, cavaleiro in enumerate(cavaleiros, start=1):
            (
                id_cavaleiro, id_player, id_party, cavaleiro_nome, cavaleiro_nivel, 
                tipo_armadura, cavaleiro_xp_atual, cavaleiro_hp_max, cavaleiro_hp_atual, 
                cavaleiro_magia_max, cavaleiro_magia_atual, cavaleiro_velocidade, 
                cavaleiro_ataque_fisico, cavaleiro_ataque_magico, elemento_cavaleiro, 
                id_fraqueza_cavaleiro, id_vantagem_cavaleiro, cavaleiro_nome_classe, cavaleiro_classe_id, cavaleiro_elemento_id
            ) = cavaleiro

            fila.append({
                "id": id_cavaleiro,
                "nome": cavaleiro_nome,
                "tipo": "cavaleiro",
                "velocidade": cavaleiro_velocidade,
                "hp": cavaleiro_hp_atual
            })

    (
        id_boss, nome_boss, nivel_boss, xp_acumulado_boss, 
        hp_max_boss, hp_atual_boss, magia_max_boss, magia_atual_boss, 
        velocidade_boss, ataque_fisico_boss, ataque_magico_boss, dinheiro_boss, 
        fala_inicio_boss, fala_derrotar_player_boss, fala_derrotado_boss, 
        fala_condicao_boss, elemento_boss, id_fraqueza_boss, id_vantagem_boss
    ) = boss

    fila.append({
        "id": id_boss,
        "nome": nome_boss,
        "tipo": "boss",
        "velocidade": velocidade_boss,
        "hp": hp_atual_boss
    })

    # Ordena a fila pela velocidade (maior primeiro)
    fila.sort(key=lambda x: x["velocidade"], reverse=True)
    return fila


def processar_vitoria(console, player, boss_dict):
    """
    Processa a vitória (quando o Boss morre):
      - Atualiza o inventário com os itens dropados;
      - Atualiza o XP e o dinheiro do player.
    """
    console.print(Panel(f"[bold green]🎉 Vitória! O Boss foi derrotado![/bold green]"))
    xp_ganho = boss_dict["xp_dropado"]
    dinheiro_ganho = boss_dict["dinheiro_dropado"]

    with obter_cursor() as cursor:
        cursor.execute("""
            SELECT id_item, quantidade
            FROM item_boss_dropa
            WHERE id_boss = %s;
        """, (boss_dict["id"],))
        itens_dropados = cursor.fetchall()

        for item in itens_dropados:
            id_item, quantidade = item
            cursor.execute("""
                SELECT quantidade 
                FROM item_armazenado 
                WHERE id_inventario = %s AND id_item = %s;
            """, (player[0], id_item))
            item_existente = cursor.fetchone()
            if item_existente:
                nova_quantidade = item_existente[0] + quantidade
                cursor.execute("""
                    UPDATE item_armazenado
                    SET quantidade = %s
                    WHERE id_inventario = %s AND id_item = %s;
                """, (nova_quantidade, player[0], id_item))
            else:
                cursor.execute("""
                    INSERT INTO item_armazenado (id_inventario, id_item, quantidade)
                    VALUES (%s, %s, %s);
                """, (player[0], id_item, quantidade))

    with obter_cursor() as cursor:
        cursor.execute("""
            UPDATE player
            SET xp_atual = xp_atual + %s
            WHERE id_player = %s;
        """, (xp_ganho, player[0]))

        cursor.execute("""
            UPDATE inventario
            SET dinheiro = dinheiro + %s
            WHERE id_player = %s;
        """, (xp_ganho, dinheiro_ganho, player[0]))
    console.print(Panel(
        f"\n[bold cyan]🏆 Recompensas:[/bold cyan]\n"
        f"💰 Dinheiro ganho: [bold yellow]{dinheiro_ganho}[/bold yellow]\n"
        f"✨ XP ganho: [bold blue]{xp_ganho}[/bold blue]\n"
        f"{''.join(f'📦 {item[0]} x{item[1]}\n' for item in itens_dropados) if itens_dropados else '🎁 Nenhum item foi dropado.'}",
        title="⚔️ Batalha Encerrada"
    ))


def executar_turnos(console, player, cavaleiros, boss):
    """
    Executa os turnos dos participantes.
    A cada rodada os dados são atualizados e a fila de turnos é recalculada,
    evitando que o Boss ataque se já estiver morto.
    """
    boss_dict = {
        "id": boss[0],
        "nome": boss[1],
        "xp_dropado": boss[3],
        "hp": boss[5],
        "dinheiro_dropado": boss[11],
        "fala_derrotar_player": boss[13],
        "fala_derrotado": boss[14],
        "fala_condicao": boss[15]
    }
    
    while True:
        # Atualiza os dados da batalha a cada rodada
        dados_batalha = obter_dados_batalha(player[0], boss[0])
        if not dados_batalha:
            console.print("[bold red]Erro ao atualizar dados da batalha![/bold red]")
            return

        player = dados_batalha["player"]
        cavaleiros = dados_batalha["cavaleiros"]
        boss = dados_batalha["boss"]

        exibir_tabela_batalha(console, player, cavaleiros, boss)

        # Se o Boss já estiver morto, processa a vitória
        if boss[5] <= 0:
            processar_vitoria(console, player, boss_dict)
            return

        # Verifica se o total de HP do player e cavaleiros é 0 (derrota)
        total_hp = player[6] + sum(c[8] for c in cavaleiros)
        if total_hp <= 0:
            console.print(Panel("[bold red]💀 Derrota! Todos os jogadores foram derrotados![/bold red]"))
            return

        # Recalcula a fila de turnos
        fila = criar_fila_turnos(player, cavaleiros, boss)

        for personagem in fila:
            if boss[5] <= 0:
                break  # Se o Boss morreu durante a rodada, interrompe os turnos

            if personagem["hp"] <= 0:
                continue  # Ignora personagens já mortos

            if personagem["tipo"] in ["player", "cavaleiro"]:
                acao_realizada = False
                while not acao_realizada:
                    limpar_terminal(console)
                    exibir_tabela_batalha(console, player, cavaleiros, boss)
                    console.print(f"[bold cyan]🔄 Turno de {personagem['nome']} ({personagem['tipo']})![/bold cyan]")
                    console.print("[bold yellow]🛡️ Escolha uma ação:")
                    console.print("1. Ataque Físico")
                    console.print("2. Usar Habilidade")
                    console.print("3. Ver Dica")
                    console.print("4. Fugir")
                    escolha = input("➡️ Escolha: ").strip()

                    if escolha == "1":
                        # Exibe um menu bonito com emojis para escolha da parte do corpo
                        partes_disponiveis = exibir_partes_corpo_boss(console, boss_dict["id"])
                        console.print("\n[bold magenta]Escolha a parte do corpo do Boss para atacar:[/bold magenta]")
                        console.print("1️⃣ - 🧠 Cabeça")
                        console.print("2️⃣ - 💪 Tronco")
                        console.print("3️⃣ - 🦵 Pernas")
                        console.print("4️⃣ - 👐 Braços")
                        escolha_ataque = input("➡️ Opção: ").strip()
                        partes_mapeadas = {"1": "c", "2": "t", "3": "b", "4": "p"}
                        if escolha_ataque in partes_mapeadas:
                            parte_alvo = partes_mapeadas[escolha_ataque]
                            with obter_cursor() as cursor:
                                if personagem["tipo"] == "player":
                                    cursor.execute("SELECT player_ataque_fisico(%s, %s, %s)", (personagem["id"], boss_dict["id"], parte_alvo))
                                else:
                                    cursor.execute("SELECT cavaleiro_ataque_fisico(%s, %s, %s)", (personagem["id"], boss_dict["id"], parte_alvo))
                            console.print("[bold green]⚔️ Ataque realizado![/bold green]")
                            input("Pressione ENTER para continuar...")
                            acao_realizada = True
                    elif escolha == "2":
                        usar_habilidade(console, personagem, boss_dict)
                        acao_realizada = True
                    elif escolha == "3":
                        console.print(Panel(f"[bold cyan]{boss_dict['nome']}[/bold cyan]: [italic]{boss_dict['fala_condicao']}[/italic]"))
                        input("Pressione ENTER para voltar...")
                    elif escolha == "4":
                        console.print("[bold yellow]🏃 Você fugiu da batalha![/bold yellow]")
                        return
                    else:
                        console.print("[bold red]❌ Escolha inválida! Tente novamente.[/bold red]")
                        input("Pressione ENTER para tentar novamente...")
            elif personagem["tipo"] == "boss":
                # Verifica novamente se o Boss está vivo antes de executar seu turno
                if boss[5] <= 0:
                    break
                limpar_terminal(console)
                exibir_tabela_batalha(console, player, cavaleiros, boss)
                console.print(f"\n[bold cyan]🔄 Turno de {personagem['nome']} ({personagem['tipo']})![/bold cyan]")
                with obter_cursor() as cursor:
                    cursor.execute("SELECT boss_ataque_fisico(%s, %s)", (boss_dict["id"], player[0]))
                    notices = cursor.connection.notices
                    mensagens_formatadas = [notice.replace("NOTICE:", "").strip() for notice in notices]
                for mensagem in mensagens_formatadas:
                    console.print(f"[bold red]💥 {mensagem} [/bold red]")
                    input("Pressione ENTER para continuar...")

            # Atualiza os dados após cada turno
            dados_batalha = obter_dados_batalha(player[0], boss[0])
            player = dados_batalha["player"]
            cavaleiros = dados_batalha["cavaleiros"]
            boss = dados_batalha["boss"]


def usar_habilidade(console, personagem, boss_dict):
    """
    Permite que o personagem use uma habilidade.
    Mostra as habilidades disponíveis e executa a função correspondente no banco.
    """
    with obter_cursor() as cursor:
        if personagem["tipo"] == "player":
            cursor.execute("""
                SELECT h.id_habilidade, h.nome, h.audio 
                FROM habilidade_player hp
                JOIN habilidade h ON hp.id_habilidade = h.id_habilidade
                WHERE hp.id_player = %s;
            """, (personagem["id"],))
        else:
            cursor.execute("""
                SELECT h.id_habilidade, h.nome, h.audio 
                FROM habilidade_cavaleiro hc
                JOIN habilidade h ON hc.id_habilidade = h.id_habilidade
                WHERE hc.id_cavaleiro = %s;
            """, (personagem["id"],))
        habilidades = cursor.fetchall()

    if not habilidades:
        console.print("[bold red]❌ Nenhuma habilidade disponível![/bold red]")
        input("Pressione ENTER para continuar...")
        return

    console.print(Panel("[bold blue]📜 Escolha uma habilidade:[/bold blue]"))
    for i, (_, nome, _) in enumerate(habilidades, start=1):
        console.print(f"[bold cyan]{i}. {nome}[/bold cyan]")

    while True:
        escolha_habilidade = input("\n🎯 Digite o número da habilidade ou '0' para cancelar: ").strip()
        if escolha_habilidade == "0":
            return
        if not escolha_habilidade.isdigit():
            console.print("[bold red]❌ Escolha inválida! Digite um número válido.[/bold red]")
            continue
        escolha_habilidade = int(escolha_habilidade)
        if 1 <= escolha_habilidade <= len(habilidades):
            break
        console.print("[bold red]❌ Escolha inválida! Escolha um número dentro da lista.[/bold red]")

    id_habilidade, nome_habilidade, audio_habilidade = habilidades[escolha_habilidade - 1]

    if audio_habilidade:
        tocar_efeito_sonoro(audio_habilidade)

    try:
        with obter_cursor() as cursor:
            if personagem["tipo"] == "player":
                cursor.execute("SELECT usar_habilidade_player(%s, %s, %s);", (personagem["id"], boss_dict["id"], id_habilidade))
            else:
                cursor.execute("SELECT usar_habilidade_cavaleiro(%s, %s, %s);", (personagem["id"], boss_dict["id"], id_habilidade))
        console.print(f"[bold magenta]🔥 {personagem['nome']} usou {nome_habilidade}![/bold magenta]")
    except Exception as e:
        console.print(f"[bold red]⛔ Erro ao executar habilidade: {e}[/bold red]")

    input("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")


def exibir_partes_corpo_boss(console, boss_id):
    """
    Exibe as partes do corpo do Boss em uma tabela.
    """
    limpar_terminal(console)
    with obter_cursor() as cursor:
        cursor.execute("""
            SELECT id_boss, parte_corpo, boss_parte_corpo, boss_defesa_fisica, boss_defesa_magica, boss_chance_acerto, boss_chance_acerto_critico 
            FROM boss_parte_corpo_info_view  
            WHERE id_boss = %s;
        """, (boss_id,))
        partes_corpo = cursor.fetchall()

    if not partes_corpo:
        console.print("[bold red]Erro ao obter partes do corpo do Boss.[/bold red]")
        return {}

    tabela_partes = Table(title="🛡️ Partes do Corpo do Boss", show_header=True, header_style="bold yellow", show_lines=True)
    tabela_partes.add_column("Parte", style="cyan", justify="center")
    tabela_partes.add_column("Def. Física", style="green", justify="center")
    tabela_partes.add_column("Def. Mágica", style="blue", justify="center")
    tabela_partes.add_column("Chance Acerto", style="blue", justify="center")
    tabela_partes.add_column("Chance Acerto Crítico", style="blue", justify="center")

    partes_dict = {}
    for parte in partes_corpo:
        id_boss, id_parte_corpo, nome_parte, def_fisica, def_magica, chance_acerto, chance_acerto_critico = parte
        tabela_partes.add_row(nome_parte, str(def_fisica), str(def_magica), str(chance_acerto), str(chance_acerto_critico))
        partes_dict[id_parte_corpo.lower()] = nome_parte

    console.print(tabela_partes)
    return partes_dict


def atualizar_hp(fila, console):
    """
    Atualiza os HPs dos personagens após cada turno consultando o banco.
    """
    with obter_cursor() as cursor:
        for personagem in fila:
            if personagem["tipo"] == "player":
                cursor.execute("SELECT hp_atual FROM player WHERE id_player = %s", (personagem["id"],))
            elif personagem["tipo"] == "cavaleiro":
                cursor.execute("SELECT cavaleiro_hp_atual FROM party_cavaleiros_view WHERE id_cavaleiro = %s", (personagem["id"],))
            elif personagem["tipo"] == "boss":
                cursor.execute("SELECT boss_hp_atual FROM boss_info_view WHERE id_boss = %s", (personagem["id"],))
            novo_hp = cursor.fetchone()
            if novo_hp:
                personagem["hp"] = novo_hp[0]
