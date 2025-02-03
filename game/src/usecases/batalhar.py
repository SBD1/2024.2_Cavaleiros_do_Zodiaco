import random
import time
from rich.panel import Panel
from rich.console import Console
from rich.table import Table
from ..database import obter_cursor
from collections import deque
from dataclasses import dataclass
from ..util import limpar_terminal
@dataclass
class Combatente:
    id_instancia: int
    tipo: str  
    velocidade: int
    id_player: int  

def obter_nome_combatente(cursor, tipo, id_instancia):
    """ Obtém o nome do combatente baseado no tipo e ID """
    if tipo == "player":
        cursor.execute("SELECT nome FROM player WHERE id_player = %s", (id_instancia,))
    elif tipo == "cavaleiro":
        cursor.execute("""
            SELECT c.nome FROM instancia_cavaleiro ic 
            INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro
            WHERE ic.id_instancia_cavaleiro = %s
        """, (id_instancia,))
    elif tipo == "inimigo":
        cursor.execute("""
            SELECT i.nome FROM instancia_inimigo ii
            INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
            WHERE ii.id_instancia = %s
        """, (id_instancia,))
    
    result = cursor.fetchone()
    return result[0] if result else f"{tipo.capitalize()} {id_instancia}"

def batalhar(console, id_player):
    """⚔️ Inicia uma batalha entre o jogador, seus cavaleiros e os inimigos da sala, organizando a fila de ataque."""

    if id_player is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🚫",
            title="⚠️ Ação Inválida",
            border_style="red"
        ))
        return

    partes_corpo = {'c': 'Cabeça 🧠', 't': 'Tronco 🏋️', 'b': 'Braços 💪', 'p': 'Pernas 🦵'}

    try:
        with obter_cursor() as cursor:
            cursor.execute("""
                SELECT id_instancia, tipo, velocidade, id_player 
                FROM view_fila_turnos_batalha
                WHERE id_player = %s
                ORDER BY velocidade DESC;
            """, (id_player,))

            fila_turnos = deque([Combatente(*row) for row in cursor.fetchall()])

            if not fila_turnos:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Nenhum combatente encontrado para a batalha![/bold yellow]",
                    title="⛔ Batalha Cancelada",
                    border_style="yellow"
                ))
                return

            rodada = 1
            while fila_turnos:
                limpar_terminal(console)
                console.print(Panel.fit(f"⚔️ [bold magenta]Rodada {rodada}[/bold magenta]", border_style="magenta"))

                if not fila_turnos:
                    break  

                combatente_atual = fila_turnos.popleft()  

                nome_combatente = obter_nome_combatente(cursor, combatente_atual.tipo, combatente_atual.id_instancia)

                cursor.execute(f"""
                    SELECT hp_atual FROM { 
                        "player" if combatente_atual.tipo == "player" else 
                        "instancia_cavaleiro" if combatente_atual.tipo == "cavaleiro" else 
                        "instancia_inimigo"
                    } WHERE { 
                        "id_player" if combatente_atual.tipo == "player" else 
                        "id_instancia_cavaleiro" if combatente_atual.tipo == "cavaleiro" else 
                        "id_instancia"
                    } = %s
                """, (combatente_atual.id_instancia,))
                
                hp_atual = cursor.fetchone()
                if hp_atual and hp_atual[0] <= 0:
                    console.print(f"💀 [bold red]{nome_combatente} foi derrotado![/bold red] 💀")
                    continue  

                if combatente_atual.tipo in ["player", "cavaleiro"]:
                    cursor.execute("SELECT id_instancia FROM instancia_inimigo WHERE hp_atual > 0")
                    inimigos_disponiveis = [row[0] for row in cursor.fetchall()]

                    if not inimigos_disponiveis:
                        console.print("[bold green]🎉 Vitória! Todos os inimigos foram derrotados! 🎉[/bold green]")
                        return  

                    console.print(f"🎯 {nome_combatente} está atacando!")

                    # Mostrar inimigos disponíveis em tabela
                    table = Table(title="👹 Inimigos disponíveis", show_header=True, header_style="bold red")
                    table.add_column("Opção", justify="center")
                    table.add_column("Nome", justify="left")

                    inimigos_opcoes = {}
                    for inimigo_id in inimigos_disponiveis:
                        nome_inimigo = obter_nome_combatente(cursor, "inimigo", inimigo_id)
                        table.add_row(str(inimigo_id), nome_inimigo)
                        inimigos_opcoes[inimigo_id] = nome_inimigo

                    console.print(table)

                    while True:
                        try:
                            id_inimigo_alvo = int(input("> Escolha a Opção do inimigo para atacar: "))
                            if id_inimigo_alvo in inimigos_opcoes:
                                break
                            console.print("[bold red]❌ Opção inválido! Escolha um inimigo listado acima.[/bold red]")
                        except ValueError:
                            console.print("[bold red]❌ Entrada inválida! Digite um número válido.[/bold red]")

                    console.print("💀 [bold cyan]Escolha a parte do corpo para atacar:[/bold cyan]")
                    for k, v in partes_corpo.items():
                        console.print(f"➡ {k.upper()} - {v}")

                    while True:
                        parte_alvo = input("> ").lower()
                        if parte_alvo in partes_corpo:
                            break
                        console.print("[bold red]❌ Escolha inválida! Selecione uma das opções acima.[/bold red]")

                    if combatente_atual.tipo == "player":
                        cursor.execute("SELECT * FROM player_ataca_inimigo(%s, %s, %s)", 
                                       (combatente_atual.id_instancia, id_inimigo_alvo, parte_alvo))
                    else:
                        cursor.execute("SELECT * FROM cavaleiro_ataca_inimigo(%s, %s, %s)", 
                                       (combatente_atual.id_instancia, id_inimigo_alvo, parte_alvo))

                    mensagem = cursor.fetchone()
                    if mensagem:
                        console.print(f"📢 {mensagem[0]}")

                elif combatente_atual.tipo == "inimigo":
                    cursor.execute("SELECT id_instancia_cavaleiro FROM instancia_cavaleiro WHERE hp_atual > 0 AND id_player = %s", (id_player,))
                    cavaleiros_disponiveis = [row[0] for row in cursor.fetchall()]

                    cursor.execute("SELECT id_player FROM player WHERE hp_atual > 0 AND id_player = %s", (id_player,))
                    players_disponiveis = [row[0] for row in cursor.fetchall()]

                    alvos = cavaleiros_disponiveis + players_disponiveis
                    if not alvos:
                        console.print("[bold red]💀 Todos os aliados foram derrotados! Você perdeu a batalha. 💀[/bold red]")
                        return  

                    alvo_escolhido = random.choice(alvos)
                    parte_alvo = random.choice(list(partes_corpo.keys()))

                    nome_alvo = obter_nome_combatente(cursor, "cavaleiro" if alvo_escolhido in cavaleiros_disponiveis else "player", alvo_escolhido)
                    nome_inimigo = obter_nome_combatente(cursor, "inimigo", combatente_atual.id_instancia)

                    console.print(f"💀 {nome_inimigo} atacou {nome_alvo} na {partes_corpo[parte_alvo]}!")

                    cursor.execute("SELECT * FROM inimigo_ataca_player(%s, %s, %s)", 
                                   (combatente_atual.id_instancia, alvo_escolhido, parte_alvo))
                    mensagem = cursor.fetchone()
                    if mensagem:
                        console.print(f"📢 {mensagem[0]}")

                fila_turnos.append(combatente_atual)
                rodada += 1
                time.sleep(2)

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao processar a batalha:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
