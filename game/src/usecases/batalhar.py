import random
import time
from rich.panel import Panel
from ..database import obter_cursor
from collections import deque
from dataclasses import dataclass

@dataclass
class Combatente:
    id_instancia: int
    tipo: str  # 'player', 'cavaleiro' ou 'inimigo'
    velocidade: int
    id_player: int  

def batalhar(console, id_player):
    """⚔️ Inicia uma batalha entre o jogador, seus cavaleiros e os inimigos da sala, organizando a fila de ataque."""

    if id_player is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🚫",
            title="⚠️ Ação Inválida",
            border_style="red"
        ))
        return

    partes_corpo = ['c', 't', 'b', 'p']  # Cabeça, Tronco, Braços, Pernas

    try:
        with obter_cursor() as cursor:
            # Buscar a fila de turnos diretamente da view
            cursor.execute("""
                SELECT id_instancia, tipo, velocidade, id_player 
                FROM view_fila_turnos_batalha
                WHERE id_player = %s
                ORDER BY velocidade DESC;
            """, (id_player,))

            # Criar a fila de turnos
            fila_turnos = deque([
                Combatente(*row) for row in cursor.fetchall()
            ])

            if not fila_turnos:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Nenhum combatente encontrado para a batalha![/bold yellow]",
                    title="⛔ Batalha Cancelada",
                    border_style="yellow"
                ))
                return

            rodada = 1
            while fila_turnos:
                console.print(Panel.fit(f"⚔️ [bold magenta]Rodada {rodada}[/bold magenta]", border_style="magenta"))
                
                if not fila_turnos:
                    break  # Se a fila estiver vazia, sai do loop

                combatente_atual = fila_turnos.popleft()  

                # Verificar HP antes de continuar
                cursor.execute("""
                    SELECT hp_atual FROM {} WHERE {} = %s
                """.format(
                    "player" if combatente_atual.tipo == "player" else
                    "instancia_cavaleiro" if combatente_atual.tipo == "cavaleiro" else
                    "instancia_inimigo",
                    "id_player" if combatente_atual.tipo == "player" else
                    "id_instancia_cavaleiro" if combatente_atual.tipo == "cavaleiro" else
                    "id_instancia"
                ), (combatente_atual.id_instancia,))
                
                hp_atual = cursor.fetchone()
                if hp_atual and hp_atual[0] <= 0:
                    console.print(f"💀 [bold red]{combatente_atual.tipo.capitalize()} (ID {combatente_atual.id_instancia}) foi derrotado![/bold red] 💀")
                    continue  # Remove da fila e não adiciona de volta

                if combatente_atual.tipo in ["player", "cavaleiro"]:
                    # Se for player ou cavaleiro, escolher o alvo manualmente
                    cursor.execute("SELECT id_instancia FROM instancia_inimigo WHERE hp_atual > 0")
                    inimigos_disponiveis = [row[0] for row in cursor.fetchall()]

                    if not inimigos_disponiveis:
                        console.print("[bold green]🎉 Vitória! Todos os inimigos foram derrotados! 🎉[/bold green]")
                        return  # Fim da batalha

                    console.print(f"🎯 {combatente_atual.tipo.capitalize()} (ID {combatente_atual.id_instancia}) está atacando!")
                    
                    # Exibir inimigos disponíveis
                    console.print("[bold cyan]Escolha o ID do inimigo para atacar:[/bold cyan]")
                    for inimigo in inimigos_disponiveis:
                        console.print(f"➡ Inimigo ID: {inimigo}")

                    # Input do usuário para selecionar um inimigo
                    while True:
                        try:
                            id_inimigo_alvo = int(input("> "))
                            if id_inimigo_alvo in inimigos_disponiveis:
                                break
                            console.print("[bold red]❌ ID inválido! Escolha um inimigo listado acima.[/bold red]")
                        except ValueError:
                            console.print("[bold red]❌ Entrada inválida! Digite um número válido.[/bold red]")

                    # Exibir opções de parte do corpo
                    console.print("[bold cyan]Escolha a parte do corpo para atacar:[/bold cyan]")
                    console.print("➡ c - Cabeça")
                    console.print("➡ t - Tronco")
                    console.print("➡ b - Braços")
                    console.print("➡ p - Pernas")

                    # Input do usuário para selecionar uma parte do corpo
                    while True:
                        parte_alvo = input("> ").lower()
                        if parte_alvo in partes_corpo:
                            break
                        console.print("[bold red]❌ Escolha inválida! Selecione uma das opções abaixo:[/bold red]")
                        console.print("➡ c - Cabeça")
                        console.print("➡ t - Tronco")
                        console.print("➡ b - Braços")
                        console.print("➡ p - Pernas")

                    # Chamar a procedure correta e capturar a mensagem do banco
                    if combatente_atual.tipo == "player":
                        cursor.execute("CALL player_ataca_inimigo(%s, %s, %s)", (combatente_atual.id_instancia, id_inimigo_alvo, parte_alvo))
                    else:
                        cursor.execute("CALL cavaleiro_ataca_inimigo(%s, %s, %s)", (combatente_atual.id_instancia, id_inimigo_alvo, parte_alvo))

                    mensagem = cursor.fetchone()
                    if mensagem:
                        console.print(f"📢 {mensagem[0]}")

                elif combatente_atual.tipo == "inimigo":
                    # Escolher aleatoriamente um alvo (player ou cavaleiro)
                    cursor.execute("SELECT id_instancia_cavaleiro FROM instancia_cavaleiro WHERE hp_atual > 0 AND id_player = %s", (id_player,))
                    cavaleiros_disponiveis = [row[0] for row in cursor.fetchall()]

                    cursor.execute("SELECT id_player FROM player WHERE hp_atual > 0 AND id_player = %s", (id_player,))
                    players_disponiveis = [row[0] for row in cursor.fetchall()]

                    alvos = cavaleiros_disponiveis + players_disponiveis
                    if not alvos:
                        console.print("[bold red]💀 Todos os aliados foram derrotados! Você perdeu a batalha. 💀[/bold red]")
                        return  # Fim da batalha

                    alvo_escolhido = random.choice(alvos)
                    parte_alvo = random.choice(partes_corpo)

                    console.print(f"💀 Inimigo (ID {combatente_atual.id_instancia}) atacou {alvo_escolhido} na parte {parte_alvo.upper()}!")

                    cursor.execute("CALL inimigo_ataca_player(%s, %s, %s)", (combatente_atual.id_instancia, alvo_escolhido, parte_alvo))
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
