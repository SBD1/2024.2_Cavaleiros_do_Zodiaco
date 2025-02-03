from rich.panel import Panel
from ..database import obter_cursor
from collections import deque
from dataclasses import dataclass
import time

@dataclass
class Combatente:
    id_instancia: int
    tipo: str  
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
            while len(fila_turnos) > 1:
                console.print(Panel.fit(f"⚔️ [bold magenta]Rodada {rodada}[/bold magenta]", border_style="magenta"))
                combatente_atual = fila_turnos.popleft()  

                console.print(f"🎯 [bold cyan]{combatente_atual.tipo.capitalize()} (ID {combatente_atual.id_instancia}) está atacando![/bold cyan]")

                time.sleep(1)  
                console.print(f"🔥 [bold red]{combatente_atual.tipo.capitalize()} atacou alguém![/bold red]")

                fila_turnos.append(combatente_atual)

                rodada += 1
                time.sleep(2)  

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao processar a batalha:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
