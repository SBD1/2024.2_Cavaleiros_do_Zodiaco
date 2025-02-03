from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from ..database import obter_cursor

def listar_equipamentos(console, jogador_id):
    """
    Lista as armaduras equipadas e armazenadas no inventário de um jogador utilizando a view armaduras_jogador_view.
    Permite equipar um equipamento do inventário.
    """

    try:
        with obter_cursor() as cursor:
            # Buscar todas as armaduras do jogador através da VIEW, usando id_parte_corpo_armadura
            cursor.execute("""
                SELECT 
                    id_instancia,
                    id_armadura,
                    id_parte_corpo_armadura,
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
                ORDER BY status_armadura DESC, id_parte_corpo_armadura;
            """, (jogador_id,))
            
            armaduras = cursor.fetchall()

            if not armaduras:
                console.print(Panel.fit("🔍 [bold yellow]Você não possui armaduras disponíveis![/bold yellow]", border_style="yellow"))
                return

            # Criar tabelas para exibição
            tabela_equipadas = Table(title="⚔️ Armaduras Equipadas", show_lines=True)
            tabela_equipadas.add_column("ID Instância", style="cyan", justify="left")
            tabela_equipadas.add_column("Nome", style="cyan", justify="left")
            tabela_equipadas.add_column("Parte do Corpo (ID)", style="magenta", justify="left")
            tabela_equipadas.add_column("Raridade", style="cyan", justify="center")
            tabela_equipadas.add_column("Descrição", style="cyan", justify="left")
            tabela_equipadas.add_column("Durabilidade", style="yellow", justify="center")
            tabela_equipadas.add_column("Ataque Físico", style="green", justify="center")
            tabela_equipadas.add_column("Ataque Mágico", style="blue", justify="center")
            tabela_equipadas.add_column("Defesa Física", style="red", justify="center")
            tabela_equipadas.add_column("Defesa Mágica", style="purple", justify="center")

            tabela_inventario = Table(title="🎒 Armaduras no Inventário", show_lines=True)
            tabela_inventario.add_column("ID Instância", style="cyan", justify="left")
            tabela_inventario.add_column("Nome", style="cyan", justify="left")
            tabela_inventario.add_column("Parte do Corpo (ID)", style="magenta", justify="left")
            tabela_inventario.add_column("Raridade", style="cyan", justify="center")
            tabela_inventario.add_column("Descrição", style="cyan", justify="left")
            tabela_inventario.add_column("Durabilidade", style="yellow", justify="center")
            tabela_inventario.add_column("Ataque Físico", style="green", justify="center")
            tabela_inventario.add_column("Ataque Mágico", style="blue", justify="center")
            tabela_inventario.add_column("Defesa Física", style="red", justify="center")
            tabela_inventario.add_column("Defesa Mágica", style="purple", justify="center")

            # Preenchimento das tabelas
            for armadura in armaduras:
                id_instancia, id_armadura, id_parte_corpo_armadura, nome, descricao, raridade, durabilidade, ataque_fisico, ataque_magico, defesa_fisica, defesa_magica, status = armadura

                if status == "equipada":
                    tabela_equipadas.add_row(
                        str(id_parte_corpo_armadura), str(raridade), str(durabilidade),
                        str(ataque_fisico), str(ataque_magico),
                        str(defesa_fisica), str(defesa_magica)
                    )
                elif status == "inventario":
                    tabela_inventario.add_row(
                        str(id_instancia), str(id_parte_corpo_armadura), str(raridade),
                        str(durabilidade), str(ataque_fisico), str(ataque_magico),
                        str(defesa_fisica), str(defesa_magica)
                    )

            # Exibir tabelas apenas se houver dados
            if tabela_equipadas.row_count > 0:
                console.print(tabela_equipadas)
            else:
                console.print(Panel.fit("🔍 [bold yellow]Nenhuma armadura equipada![/bold yellow]", border_style="yellow"))

            if tabela_inventario.row_count > 0:
                
                console.print(tabela_inventario)
                        

            else:
                console.print(Panel.fit("🎒 [bold yellow]Nenhuma armadura no inventário![/bold yellow]", border_style="yellow"))
            return True
        
    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao listar ou equipar armaduras: {e}[/bold red]", border_style="red"))
