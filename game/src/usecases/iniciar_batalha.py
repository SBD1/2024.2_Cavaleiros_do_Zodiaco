import time
from src.util import limpar_terminal
from ..database import obter_cursor 
from rich.columns import Columns
from rich.panel import Panel
from rich.table import Table
from rich.console import Console
from .tocar_musica import tocar_musica, tocar_efeito_sonoro


def iniciar_batalha(console: Console, player_id: int, boss_id: int):
    print(tocar_musica("batalha_boss.mp3"))
    dados_batalha = obter_dados_batalha(player_id, boss_id)

    if not dados_batalha:
        console.print("[bold red]Erro ao carregar os dados da batalha.[/bold red]")
        return

    exibir_tabela_batalha(console, dados_batalha["player"], dados_batalha["cavaleiros"], dados_batalha["boss"])
    console.print("[bold green]✅ Pressione ENTER para começar os turnos...[/bold green]")
    input()

    
    executar_turnos(console, dados_batalha["player"], dados_batalha["cavaleiros"], dados_batalha["boss"])

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

    # Adicionar o player à tabela_party
    tabela_party.add_row(
        "—", player_nome,"-", elemento_player, str(player_nivel),  # Nome, Elemento, Nível
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
            cavaleiro_ataque_fisico, cavaleiro_ataque_magico, elemento_cavaleiro, id_fraqueza_cavaleiro, id_vantagem_cavaleiro, cavaleiro_classe, cavaleiro_classe_id, cavaleiro_elemento_id
        ) = cavaleiro

        # Adicionar o cavaleiro à tabela_party
        tabela_party.add_row(
            str(i), cavaleiro_nome, cavaleiro_classe,  elemento_cavaleiro, str(cavaleiro_nivel),  # Nome, Tipo, Nível
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



def criar_fila_turnos(player, cavaleiros, boss):
    """Cria a fila de turnos baseada na velocidade dos participantes."""
    fila = []

    (
        id_player, player_nome, player_nivel, player_xp_atual,
        player_hp_max, player_magia_max, player_hp_atual, player_magia_atual,
        player_velocidade, ataque_fisico_base, ataque_magico_base,
        ataque_fisico_armaduras, ataque_magico_armaduras,
        ataque_fisico_total, ataque_magico_total,
        id_elemento, elemento_player, dinheiro, alma_armadura, id_fraqueza_player, id_vantagem_player
    ) = player

    # Adiciona o Player à fila
    fila.append({
        "id": id_player,
        "nome": player_nome,
        "tipo": "player",
        "velocidade": player_velocidade,
        "hp": player_hp_atual
    })

    if cavaleiros:
        # Adiciona os Cavaleiros da Party
        for i, cavaleiro in enumerate(cavaleiros, start=1):
            (
            id_cavaleiro, id_player, id_party, cavaleiro_nome, cavaleiro_nivel, 
            tipo_armadura, cavaleiro_xp_atual, cavaleiro_hp_max, cavaleiro_hp_atual, 
            cavaleiro_magia_max, cavaleiro_magia_atual, cavaleiro_velocidade, 
            cavaleiro_ataque_fisico, cavaleiro_ataque_magico, elemento_cavaleiro, id_fraqueza_cavaleiro, id_vantagem_cavaleiro, cavaleiro_nome_classe, cavaleiro_classe_id, cavaleiro_elemento_id 
            ) = cavaleiro
            fila.append({
                "id": id_cavaleiro,
                "nome": cavaleiro_nome,
                "tipo": "cavaleiro",
                "velocidade": cavaleiro_velocidade,
                "hp": cavaleiro_hp_atual
            })

    # Adiciona o Boss

    (
        id_boss, nome_boss, nivel_boss, xp_acumulado_boss, 
        hp_max_boss, hp_atual_boss, magia_max_boss, magia_atual_boss, 
        velocidade_boss, ataque_fisico_boss, ataque_magico_boss, dinheiro_boss, 
        fala_inicio_boss, fala_derrotar_player_boss, fala_derrotado_boss, fala_condicao_boss, elemento_boss, id_fraqueza_boss, id_vantagem_boss
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

def executar_turnos(console, player, cavaleiros, boss):
    """Executa a batalha turn-based entre Player, Cavaleiros e Boss."""
    boss_dict = {
        "id": boss[0], "nome": boss[1], "xp_dropado": boss[3], "hp": boss[5], "dinheiro_dropado": boss[11],  "fala_derrotar_player": boss[13], "fala_derrotado": boss[14], "fala_condicao": boss[15]
    }
    fila = criar_fila_turnos(player, cavaleiros, boss)
    
    while True:

        # Verifica no SQL se o Boss foi derrotado
        with obter_cursor() as cursor:
            cursor.execute("SELECT hp_atual FROM boss WHERE id_boss = %s", (boss_dict["id"],))
            boss_hp = cursor.fetchone()
            if boss_hp and boss_hp[0] <= 0:
                break

        # Verifica no SQL se todos os jogadores e cavaleiros foram derrotados
        with obter_cursor() as cursor:
            cursor.execute("""
                SELECT COUNT(*) FROM (
                    SELECT id_player, hp_atual FROM player WHERE id_player = %s AND hp_atual > 0
                    UNION ALL
                    SELECT id_cavaleiro, cavaleiro_hp_atual FROM party_cavaleiros_view WHERE id_player = %s AND cavaleiro_hp_atual > 0
                ) vivos
            """, (player[0], player[0]))
            
            vivos = cursor.fetchone()
        
            if vivos and vivos[0] == 0:
                console.print(Panel("[bold red]💀 Derrota! Todos os jogadores foram derrotados![/bold red]", title="⚔️ Batalha Encerrada"))
                break
        
        for personagem in fila:
            if personagem["hp"] <= 0:
                continue  # Ignora personagens mortos

            

            with obter_cursor() as cursor:
                if personagem["tipo"] in ["player", "cavaleiro"]:
                    escolha = None
                    while True:  # 🔄 Loop principal do menu de ações
                        limpar_terminal(console)
                        exibir_tabela_batalha(console, player, cavaleiros, boss)
                        console.print(f"[bold cyan]🔄 Turno de {personagem['nome']} ({personagem['tipo']})![/bold cyan]")
                        console.print("\n[bold yellow]🛡️ Escolha uma ação:[/bold yellow]")
                        console.print("[bold green]1. Ataque Físico[/bold green]")
                        console.print("[bold blue]2. Usar Habilidade (⚠️ Em breve)[/bold blue]")
                        console.print("[bold blue]3. Dica de como derrotar[/bold blue]")
                        console.print("[bold magenta]4. Fugir (⚠️ Em breve)[/bold magenta]")  # Ajustado para 4

                        console.print("\n[bold white]Digite a opção desejada: [/bold white]")
                        escolha = input().strip()

                        if escolha == "1":  # 🔹 Se escolher atacar, pode voltar
                            while True:
                                limpar_terminal(console)
                                partes_disponiveis = exibir_partes_corpo_boss(console, boss_dict["id"])
                                console.print("[bold yellow]🛡️ Escolha uma parte do corpo do Boss para atacar:[/bold yellow]")
                                console.print("[bold cyan]1. 🧠 Cabeça [/bold cyan]")
                                console.print("[bold cyan]2. 🏋️ Tronco [/bold cyan]")
                                console.print("[bold cyan]3. 💪 Braços [/bold cyan]")
                                console.print("[bold cyan]4. 🦵 Pernas [/bold cyan]")
                                console.print("[bold red]5. 🔙 Voltar[/bold red]")  # 🔙 Opção de voltar

                                console.print("[bold green]➡️ Digite o número correspondente: [/bold green]")
                                escolha_ataque = input().strip()

                                opcoes = {
                                    "1": "c",  # Cabeça
                                    "2": "t",  # Tronco
                                    "3": "b",  # Braços
                                    "4": "p"   # Pernas
                                }
                                
                                if escolha_ataque == "5":  # 🔙 Voltar ao menu principal
                                    break  # Sai do loop e retorna ao menu principal

                                if escolha_ataque in opcoes:
                                    parte_alvo = opcoes[escolha_ataque]

                                    if personagem["tipo"] == "player":
                                        cursor.execute("SELECT player_ataque_fisico(%s, %s, %s)", (personagem["id"], boss_dict["id"], parte_alvo))
                                    elif personagem["tipo"] == "cavaleiro":
                                        cursor.execute("SELECT cavaleiro_ataque_fisico(%s, %s, %s)", (personagem["id"], boss_dict["id"], parte_alvo))

                                    notices = cursor.connection.notices
                                    mensagens_formatadas = [notice.replace("NOTICE:", "").strip() for notice in notices]

                                    for mensagem in mensagens_formatadas:
                                        if "derrotado" in mensagem.lower():
                                            limpar_terminal(console)
                                            console.print(Panel(f"[bold cyan]{boss_dict['nome']}[/bold cyan]: [italic]{boss_dict['fala_derrotado']}[/italic]", expand=False))

                                            # mostrar quais itens ganhou, dinheiro, xp e quest concluida

                                            with obter_cursor() as cursor:
                                                    # 🔹 Busca os itens que o Boss pode dropar
                                                    cursor.execute("""
                                                        SELECT 
                                                            COALESCE(co.nome, m.nome, a.nome, l.nome, co.nome) AS nome_item,
                                                            ibd.quantidade
                                                        FROM item_boss_dropa ibd
                                                        JOIN tipo_item ti ON ibd.id_item = ti.id_item
                                                        LEFT JOIN craftavel c ON ti.tipo_item = 'c' AND ti.id_item = c.id_craftavel
                                                        LEFT JOIN material m ON c.tipo_craftavel = 'm' AND ti.id_item = m.id_material
                                                        LEFT JOIN armadura a ON c.tipo_craftavel = 'a' AND ti.id_item = a.id_armadura
                                                        LEFT JOIN nao_craftavel nc ON ti.tipo_item = 'nc' AND ti.id_item = nc.id_nao_craftavel
                                                        LEFT JOIN livro l ON nc.tipo_nao_craftavel = 'l' AND ti.id_item = l.id_item
                                                        LEFT JOIN consumivel co ON nc.tipo_nao_craftavel = 'c' AND ti.id_item = co.id_item
                                                        WHERE ibd.id_boss = %s;

                                                    """, (boss_dict["id"],))

                                                    itens_dropados = cursor.fetchall()

                                                    # 🔹 Atualiza o inventário do jogador com dinheiro e XP
                                                    cursor.execute("""
                                                        UPDATE inventario
                                                        SET dinheiro = dinheiro + %s
                                                        WHERE id_player = %s;
                                                    """, (boss_dict['dinheiro_dropado'], player[0]))

                                                    cursor.execute("""
                                                        UPDATE player
                                                        SET xp_atual = xp_atual + %s
                                                        WHERE id_player = %s;
                                                    """, (boss_dict['xp_dropado'], player[0]))
                                                    
                                                    cursor.execute("CALL adicionar_drop_boss(%s, %s);", (boss_dict["id"], player[0]))
                                                    # 🔹 Construindo a mensagem de recompensas
                                                    itens_texto = ""
                                                    for item_nome, quantidade in itens_dropados:
                                                        itens_texto += f"📦 {item_nome} x{quantidade}\n"

                                                    console.print(Panel(
                                                        f"\n[bold green]🎉 Vitória! O Boss foi derrotado![/bold green]\n\n"
                                                        f"[bold cyan]🏆 Recompensas:[/bold cyan]\n"
                                                        f"💰 Dinheiro ganho: [bold yellow]{boss_dict['dinheiro_dropado']}[/bold yellow]\n"
                                                        f"✨ XP ganho: [bold blue]{boss_dict['xp_dropado']}[/bold blue]\n"
                                                        f"{itens_texto if itens_texto else '🎁 Nenhum item foi dropado.'}",
                                                        title="⚔️ Batalha Encerrada"
                                                    ))

                                                    
                                                    return  # 🔹 Sai da batalha imediatamente

                                        else: 
                                            console.print(f"[bold green]⚔️ {mensagem} [/bold green]")
                                            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]") 
                                            input()
                                        
                                    break
                                

                                else:
                                    console.print("[bold red]❌ Parte inválida! Tente novamente.[/bold red]")

                                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]") 
                                input()
                                break


                        elif escolha == "2":  # 🔹 Se escolher habilidade, pode voltar
                            # Obtém as habilidades disponíveis
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
                                input()
                                continue

                            console.print(Panel("[bold blue]📜 Escolha uma habilidade:[/bold blue]"))
                            for i, (_, nome, _) in enumerate(habilidades, start=1):
                                console.print(f"[bold cyan]{i}. {nome}[/bold cyan]")

                            escolha_habilidade = input("\n🎯 Digite o número da habilidade ou '0' para cancelar: ").strip()
                            
                            if escolha_habilidade == "0":
                                continue

                            if not escolha_habilidade.isdigit() or int(escolha_habilidade) < 1 or int(escolha_habilidade) > len(habilidades):
                                console.print("[bold red]❌ Escolha inválida![/bold red]")
                                input()
                                continue

                            id_habilidade, nome_habilidade, audio_habilidade = habilidades[int(escolha_habilidade) - 1]
                            print(f"debug {habilidades[int(escolha_habilidade) - 1]}")
                            input()
                            # 🔊 Toca o som da habilidade antes de executá-la
                            if audio_habilidade:
                                tocar_efeito_sonoro(audio_habilidade)
                                input()
                            # 🔹 Executa a habilidade no banco de dados
                            with obter_cursor() as cursor:
                                if personagem["tipo"] == "player":
                                    cursor.execute("SELECT usar_habilidade_player(%s, %s, %s);", (personagem["id"], boss_dict["id"], id_habilidade))
                                    print(f"debug {habilidades[int(escolha_habilidade) - 1]}")
                                    input()
                                else:
                                    print(f"debug {habilidades[int(escolha_habilidade) - 1]}")
                                    input()
                                    cursor.execute("SELECT usar_habilidade_cavaleiro(%s, %s, %s);", (personagem["id"], boss_dict["id"], id_habilidade))

                            console.print(f"[bold magenta]🔥 {personagem['nome']} usou {nome_habilidade}![/bold magenta]")

                            input("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")

                            if escolha_habilidade == "5":
                                continue  # 🔄 Volta ao menu principal sem passar o turno

                        elif escolha == "3":  # 🔹 Mostra a dica e volta ao menu principal
                            limpar_terminal(console)
                            console.print(Panel(f"[bold cyan]{boss_dict['nome']}[/bold cyan]: [italic]{boss_dict['fala_condicao']}[/italic]", expand=False))
                            input("\n[bold green]✅ Pressione ENTER para voltar...[/bold green]")
                            continue  # 🔄 Volta ao menu principal sem passar o turno

                        elif escolha == "4":  # 🔹 Fugir (futuro)
                            console.print("\n[bold green]✅ Fugiu com sucesso. Pressione ENTER para continuar...[/bold green]")
                            return  

                        else:
                            console.print("[bold red]❌ Escolha inválida! Tente novamente.[/bold red]")
                            input()

                                
                        break

                # Se for o Boss, ataca um alvo aleatório (Player ou Cavaleiro)
                elif personagem["tipo"] == "boss":
                    limpar_terminal(console)
                    exibir_tabela_batalha(console, player, cavaleiros, boss)

                    console.print(f"\n[bold cyan]🔄 Turno de {personagem['nome']} ({personagem['tipo']})![/bold cyan]")
                    try:
                       
                        cursor.execute("SELECT boss_ataque_fisico(%s, %s)", (int(personagem["id"]), player[0]))

                        notices = cursor.connection.notices
                        mensagens_formatadas = [notice.replace("NOTICE:", "").strip() for notice in notices]
                        
                            # Exibir todas as mensagens de aviso (se houver)
                        for mensagem in mensagens_formatadas:
                            if "saori kido" in mensagem.lower():
                                limpar_terminal(console)
                                console.print(Panel(f"[bold cyan]{boss_dict['nome']}[/bold cyan]: [italic]{boss_dict['fala_derrotar_player']}[/italic]", expand=False))
                                console.print(f"[bold magenta]💖 {mensagem} [/bold magenta]")
                                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                                input()
                                return
                            else:
                                # Mensagem padrão de ataque
                                console.print(f"[bold red]💥 {mensagem} [/bold red]")
                                console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                                input()
                            
                        
                    


                    except Exception as e:
                        console.print(Panel.fit(
                            f"[bold red]⛔ {e} [/bold red]",
                            border_style="red"
                        ))
                        input()
                        return None
                

            # Atualiza os HPs após o ataque
            atualizar_hp(fila, console)

        

def exibir_partes_corpo_boss(console, boss_id):
    limpar_terminal(console)
    """Exibe as partes do corpo do Boss e seus atributos."""
    with obter_cursor() as cursor:
        cursor.execute("SELECT id_boss, parte_corpo, boss_parte_corpo, boss_defesa_fisica, boss_defesa_magica, boss_chance_acerto, boss_chance_acerto_critico FROM boss_parte_corpo_info_view  WHERE id_boss = %s;", (boss_id,))
        partes_corpo = cursor.fetchall()

        # boss_parte_corpo nome da parte do corpo  parte_corpo id da parte do corpo
    
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
        id_boss, id_parte_corpo, nome_parte,  def_fisica, def_magica, chance_acerto, chance_acerto_critico = parte
        tabela_partes.add_row(nome_parte, str(def_fisica), str(def_magica), str(chance_acerto), str(chance_acerto_critico))
        partes_dict[id_parte_corpo.lower()] = nome_parte

    console.print(tabela_partes)
    return partes_dict

def atualizar_hp(fila, console):
    """Atualiza os HPs dos personagens após cada turno consultando o banco."""
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
