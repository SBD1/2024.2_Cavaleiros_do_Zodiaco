from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from ..database import obter_cursor

def listar_equipamentos(console, jogador_id):
    """
    Lista as armaduras equipadas e armazenadas no inventário de um jogador utilizando a view armaduras_jogador_view.
    Sempre exibe 4 linhas na tabela de equipamentos equipados (Cabeça, Tronco, Braços, Pernas).
    """

    try:
        with obter_cursor() as cursor:
            # Buscar todas as armaduras do jogador através da VIEW, usando parte_corpo
            cursor.execute("""
                SELECT 
                    id_instancia,
                    id_armadura,
                    parte_corpo,
                    nome,
                    descricao,
                    raridade_armadura,
                    durabilidade_atual,
                    ataque_fisico,
                    ataque_magico,
                    defesa_fisica,
                    defesa_magica,
                    status_armadura
                FROM armaduras_jogador_view
                WHERE id_player = %s
                ORDER BY status_armadura DESC, parte_corpo;
            """, (jogador_id,))
            
            armaduras = cursor.fetchall()


            # Criar tabela de armaduras equipadas
            tabela_equipadas = Table(title="⚔️ Armaduras Equipadas", show_lines=True)

            tabela_equipadas.add_column("#\n", style="cyan", justify="left", max_width=5)
            tabela_equipadas.add_column("Nome", style="cyan", justify="left", max_width=20)
            tabela_equipadas.add_column("Parte do\nCorpo", style="magenta", justify="center", max_width=10)
            tabela_equipadas.add_column("Raridade", style="cyan", justify="center", max_width=10)
            tabela_equipadas.add_column("Descrição", style="cyan", justify="left", max_width=50)
            tabela_equipadas.add_column("Durabilidade", style="yellow", justify="center", max_width=12)
            tabela_equipadas.add_column("Ataque\nFísico", style="green", justify="center", max_width=10)
            tabela_equipadas.add_column("Ataque\nMágico", style="blue", justify="center", max_width=10)
            tabela_equipadas.add_column("Defesa\nFísica", style="red", justify="center", max_width=10)
            tabela_equipadas.add_column("Defesa\nMágica", style="purple", justify="center", max_width=10)

            # Criar estrutura fixa para equipamentos equipados (dicionário para alteração de linha)
            partes_fixas = ["Cabeça", "Tronco", "Braços", "Pernas"]
            linhas_equipadas = {parte: ["--", "--", parte, "--", "--", "--", "--", "--", "--", "--"] for parte in partes_fixas}

            # Criar tabela de inventário
            tabela_inventario = Table(title="🎒 Armaduras no Inventário", show_lines=True)
            tabela_inventario.add_column("#\n", style="cyan", justify="left", max_width=5)
            tabela_inventario.add_column("Nome", style="cyan", justify="left", max_width=20)
            tabela_inventario.add_column("Parte do\nCorpo", style="magenta", justify="left", max_width=10)
            tabela_inventario.add_column("Raridade", justify="center", max_width=10)
            tabela_inventario.add_column("Descrição", style="cyan", justify="left", max_width=50)
            tabela_inventario.add_column("Durabilidade", style="yellow", justify="center", max_width=12)
            tabela_inventario.add_column("Ataque\nFísico", style="green", justify="center", max_width=10)
            tabela_inventario.add_column("Ataque\nMágico", style="blue", justify="center", max_width=10)
            tabela_inventario.add_column("Defesa\nFísica", style="red", justify="center", max_width=10)
            tabela_inventario.add_column("Defesa\nMágica", style="purple", justify="center", max_width=10)

            # Preenchimento das tabelas
            for armadura in armaduras:
                id_instancia, id_armadura, parte_corpo, nome, descricao, raridade, durabilidade, ataque_fisico, ataque_magico, defesa_fisica, defesa_magica, status = armadura

                if status == "equipada" and parte_corpo in linhas_equipadas:
                    # Alterar a linha correspondente na estrutura
                    linhas_equipadas[parte_corpo] = [
                        str(id_instancia), str(nome), parte_corpo, str(raridade),
                        str(descricao), str(durabilidade), str(ataque_fisico), str(ataque_magico),
                        str(defesa_fisica), str(defesa_magica)
                    ]
                elif status == "inventario":
                    tabela_inventario.add_row(
                        str(id_instancia), str(nome), str(parte_corpo), str(raridade),
                        str(descricao), str(durabilidade), str(ataque_fisico), str(ataque_magico),
                        str(defesa_fisica), str(defesa_magica)
                    )

            # Adicionar as 4 linhas fixas à tabela equipadas
            for parte in partes_fixas:
                tabela_equipadas.add_row(*linhas_equipadas[parte])

            # Exibir tabelas
            console.print(tabela_equipadas)

            if tabela_inventario.row_count > 0:
                console.print(tabela_inventario)
            else:
                console.print(Panel.fit("🎒 [bold yellow]Nenhuma armadura no inventário![/bold yellow]", border_style="yellow"))

            return True
        
    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao listar ou equipar armaduras: {e}[/bold red]", border_style="red"))
