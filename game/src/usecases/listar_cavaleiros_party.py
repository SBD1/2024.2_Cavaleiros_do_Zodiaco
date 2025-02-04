from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

# Configuração de elementos visuais para exibição
elementos_config = {
    "Fogo": {"emoji": "🔥", "cor": "bold red"},
    "Água": {"emoji": "💧", "cor": "bold blue"},
    "Terra": {"emoji": "🌿", "cor": "bold green"},
    "Vento": {"emoji": "🌪️", "cor": "bold cyan"},
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
    """Obtém e exibe as informações do grupo do jogador e permite alterações."""
    try:
        with obter_cursor() as cursor:
            cursor.connection.autocommit = False

            # Obtém informações do jogador
            cursor.execute("""
                SELECT nome, nivel, xp_atual, hp_max, hp_atual, magia_max, magia_atual,
                       velocidade, ataque_fisico_base, ataque_magico_base, elemento_nome
                FROM player_info_view WHERE id_player = %s;
            """, (player_id,))
            player = cursor.fetchone()
            
            if not player:
                console.print(Panel.fit("⛔ [bold red]Jogador não encontrado![/bold red]", border_style="red"))
                return
            
            # Processa informações do jogador
            player_nome, player_nivel, player_xp_atual, player_hp_max, player_hp_atual, player_magia_max, \
            player_magia_atual, player_velocidade, player_ataque_fisico, player_ataque_magico, player_elemento = player

            player_xp_max = obter_xp_maximo(cursor, player_nivel)
            formatted_player_elemento = formatar_elemento(player_elemento)
            
            # Obtém todas as instâncias de cavaleiros (party e não party)
            cursor.execute("""
                SELECT id_cavaleiro, nome_cavaleiro, elemento_nome, nivel, xp_atual, hp_max, magia_max, 
                    hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico, id_party
                FROM instancia_cavaleiro_view
                WHERE id_player = %s;
            """, (player_id,))
            cavaleiros = cursor.fetchall()

            tabela_party = Table(title=f"⚔️ Grupo de {player_nome}", show_lines=True)
            tabela_fora_party = Table(title="🛡️ Cavaleiros Fora da Party", show_lines=True)

            for tabela in [tabela_party, tabela_fora_party]:
                tabela.add_column("#", style="bold yellow", justify="center")
                tabela.add_column("Nome", style="cyan", justify="center", no_wrap=True)
                tabela.add_column("Elemento", style="blue", justify="center", no_wrap=True)
                tabela.add_column("Nível", style="green", justify="center", no_wrap=True)
                tabela.add_column("XP", style="yellow", justify="center", no_wrap=True)
                tabela.add_column("HP", style="red", justify="center", no_wrap=True)
                tabela.add_column("Magia", style="magenta", justify="center", no_wrap=True)
                tabela.add_column("Velocidade", style="white", justify="center", no_wrap=True)
                tabela.add_column("Ataque Físico", style="orange1", justify="center", no_wrap=True)
                tabela.add_column("Ataque Mágico", style="purple", justify="center", no_wrap=True)

            # Adiciona Player na primeira linha da party (sem numeração)
            tabela_party.add_row(
                "—", player_nome, formatted_player_elemento, str(player_nivel), 
                f"{player_xp_max} / {player_xp_atual}",
                f"{player_hp_max} / {player_hp_atual}", f"{player_magia_max} / {player_magia_atual}",
                str(player_velocidade), str(player_ataque_fisico), str(player_ataque_magico)
            )

            tem_cavaleiros_fora_party = False
            party_options = []
            fora_party_options = []

            # Adiciona cavaleiros às tabelas, verificando se estão na party
            index_party, index_fora_party = 1, 1
            for cav in cavaleiros:
                id_cavaleiro, nome, elemento, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico, id_party = cav
                
                xp_max = obter_xp_maximo(cursor, nivel)
                formatted_elemento = formatar_elemento(elemento)
                cavaleiro_data = [
                    str(len(party_options) + 1) if id_party else str(len(fora_party_options) + 1), 
                    nome, formatted_elemento, str(nivel), f"{xp_max} / {xp_atual}",
                    f"{hp_max} / {hp_atual}", f"{magia_max} / {magia_atual}",
                    str(velocidade), str(ataque_fisico), str(ataque_magico)
                ]

                if id_party:
                    tabela_party.add_row(*cavaleiro_data)
                    party_options.append((id_cavaleiro))

                else:
                    tabela_fora_party.add_row(*cavaleiro_data)
                    fora_party_options.append((id_cavaleiro))
                    tem_cavaleiros_fora_party = True

            console.print(tabela_party)
            if tem_cavaleiros_fora_party:
                console.print(tabela_fora_party)
            else:
                console.print(Panel.fit(
                    "🌌 Nenhum guerreiro está aguardando! Todos os cavaleiros estão na batalha, protegendo Atena! ",
                    border_style="red"
                ))

            return party_options, fora_party_options
    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]{e}[/bold red]", border_style="red"))