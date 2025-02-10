from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

# Configuração de elementos visuais para exibição
elementos_config = {
    "Fogo": {"emoji": "🔥", "cor": "bold red"},
    "Água": {"emoji": "💧", "cor": "bold blue"},
    "Terra": {"emoji": "🌿", "cor": "bold green"},
    "Vento": {"emoji": "🌀", "cor": "bold white"},
    "Trovão": {"emoji": "⚡", "cor": "bold yellow"},
    "Luz": {"emoji": "✨", "cor": "bold white"},
    "Trevas": {"emoji": "🌑", "cor": "bold magenta"},
}

def formatar_elemento(elemento):
    """Formata o elemento com cor e emoji."""
    config = elementos_config.get(elemento, {"emoji": "❓", "cor": "bold white"})
    return f"[{config['cor']}]{config['emoji']} {elemento}[/]"

def obter_xp_maximo(cursor, nivel):
    """Retorna a XP necessária para o próximo nível."""
    cursor.execute("SELECT xp_necessaria FROM xp_necessaria WHERE nivel = %s;", (nivel + 1,))
    resultado = cursor.fetchone()
    return resultado[0] if resultado else "N/A"

def listar_cavaleiros_party(console, player_id):
    """Lista os cavaleiros na party e fora da party, mantendo o player como o primeiro na party."""
    try:
        party_options = []
        fora_party_options = []

        with obter_cursor() as cursor:
            # Obtém informações do jogador
            cursor.execute("""
                SELECT player_nome, player_nivel, player_xp_atual, player_hp_max, player_hp_atual, player_magia_max, player_magia_atual,
                       player_velocidade,  elemento_nome, ataque_fisico_base, ataque_magico_base, ataque_fisico_armaduras, ataque_fisico_armaduras, ataque_magico_armaduras,
                      COALESCE(
                           STRING_AGG(h.nome, ', ' ORDER BY h.nome), 'Nenhuma Habilidade'
                       ) AS habilidades     
                                FROM player_info_view p
                LEFT JOIN habilidade_player hp ON hp.id_player = p.id_player
                LEFT JOIN habilidade h ON h.id_habilidade = hp.id_habilidade
                WHERE p.id_player = %s
                GROUP BY p.player_nome, p.player_nivel, p.player_xp_atual, p.player_hp_max, p.player_hp_atual, 
                         p.player_magia_max, p.player_magia_atual, p.player_velocidade, p.elemento_nome, 
                         p.ataque_fisico_base, p.ataque_magico_base, p.ataque_fisico_armaduras, p.ataque_magico_armaduras;
            """, (player_id,))
            player = cursor.fetchone()

            if not player:
                console.print(Panel.fit("⛔ [bold red]Jogador não encontrado![/bold red]", border_style="red"))
                return [], []

            # Processa informações do jogador
            player_nome, player_nivel, player_xp_atual, player_hp_max, player_hp_atual, player_magia_max, \
            player_magia_atual, player_velocidade, player_elemento, player_ataque_fisico_base,\
            player_ataque_magico_base, ataque_fisico_armaduras, ataque_fisico_armaduras, ataque_magico_armaduras, player_habilidades = player

            player_xp_max = obter_xp_maximo(cursor, player_nivel)
            formatted_player_elemento = formatar_elemento(player_elemento)

            # Obtém todas as instâncias de cavaleiros (party e fora party)
            cursor.execute("""
                SELECT ic.id_cavaleiro, ic.nome_cavaleiro, ic.elemento_nome, ic.nivel, ic.xp_atual, ic.hp_max, ic.magia_max,
                       ic.hp_atual, ic.magia_atual, ic.velocidade, ic.ataque_fisico, ic.ataque_magico, ic.id_party, ic.classe_nome,
                       COALESCE(
                           STRING_AGG(h.nome, ', ' ORDER BY h.nome), 'Nenhuma Habilidade'
                       ) AS habilidades
                FROM instancia_cavaleiro_view ic
                LEFT JOIN habilidade_cavaleiro hc ON hc.id_cavaleiro = ic.id_cavaleiro
                LEFT JOIN habilidade h ON h.id_habilidade = hc.id_habilidade
                WHERE ic.id_player = %s
                GROUP BY ic.id_cavaleiro, ic.nome_cavaleiro, ic.elemento_nome, ic.nivel, ic.xp_atual, ic.hp_max, ic.magia_max,
                         ic.hp_atual, ic.magia_atual, ic.velocidade, ic.ataque_fisico, ic.ataque_magico, ic.id_party, ic.classe_nome;
            """, (player_id,))
            cavaleiros = cursor.fetchall()

            # Inicializa as tabelas para exibição
            tabela_party = Table(title=f"⚔️ Grupo de {player_nome}", show_lines=True)
            tabela_fora_party = Table(title="🛡️ Cavaleiros Fora da Party", show_lines=True)

            for tabela in [tabela_party, tabela_fora_party]:
                tabela.add_column("#", style="bold yellow", justify="center")
                tabela.add_column("Nome", style="cyan", justify="center")
                tabela.add_column("Classe", style="cyan", justify="center")
                tabela.add_column("Elemento", style="blue", justify="center")
                tabela.add_column("Nível", style="green", justify="center")
                tabela.add_column("XP", style="yellow", justify="center")
                tabela.add_column("HP", style="red", justify="center")
                tabela.add_column("Cosmo", style="magenta", justify="center")
                tabela.add_column("Velocidade", style="white", justify="center")
                tabela.add_column("Ataque Físico", style="orange1", justify="center")
                tabela.add_column("Ataque Mágico", style="purple", justify="center")
                tabela.add_column("Habilidades", style="purple", justify="center")

            # Adiciona o jogador como o primeiro na tabela da party
            tabela_party.add_row(
                "—", player_nome, "-", formatted_player_elemento, str(player_nivel),
                f"{player_xp_max} / {player_xp_atual}", f"{player_hp_max} / {player_hp_atual}",
                f"{player_magia_max} / {player_magia_atual}", str(player_velocidade),
                f"{player_ataque_fisico_base + ataque_fisico_armaduras} \n(Base:{player_ataque_fisico_base} Armaduras:{ataque_fisico_armaduras})",
                f"{player_ataque_magico_base + ataque_magico_armaduras} \n(Base:{player_ataque_magico_base} Armaduras: {ataque_magico_armaduras})",
                player_habilidades
            )

            # Processa os cavaleiros da party
            party_index = 1
            fora_party_index = 1
            for cav in cavaleiros:
                id_cavaleiro, nome, elemento, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, \
                velocidade, ataque_fisico, ataque_magico, id_party, classe, habilidades = cav
                xp_max = obter_xp_maximo(cursor, nivel)
                formatted_elemento = formatar_elemento(elemento)
                if id_party:  # Está na party (mas não o jogador)

                    tabela_party.add_row(
                        str(party_index), nome, classe,  formatted_elemento, str(nivel), f"{xp_max} / {xp_atual}",
                        f"{hp_max} / {hp_atual}", f"{magia_max} / {magia_atual}",
                        str(velocidade), str(ataque_fisico), str(ataque_magico), habilidades
                    )
                    party_options.append((party_index, id_cavaleiro, nome))
                    party_index += 1

            # Processa os cavaleiros fora da party
                if not id_party:  # Fora da party
                    tabela_fora_party.add_row(
                        str(fora_party_index), nome, classe, formatted_elemento, str(nivel), f"{xp_max} / {xp_atual}",
                        f"{hp_max} / {hp_atual}", f"{magia_max} / {magia_atual}",
                        str(velocidade), str(ataque_fisico), str(ataque_magico), habilidades
                    )
                    fora_party_options.append((fora_party_index, id_cavaleiro, nome))
                    fora_party_index += 1

        # Exibe as tabelas (fora do bloco "with")
        console.print(tabela_party)
        if fora_party_options:
            console.print(tabela_fora_party)
        else:
            console.print(Panel.fit(
                "🌌 Nenhum guerreiro está aguardando! Todos os cavaleiros estão na batalha, protegendo Atena!",
                border_style="red"
            ))

        # Retorna as listas de opções
        return party_options, fora_party_options

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao listar cavaleiros: {e}[/bold red]", border_style="red"))
        return [], []
