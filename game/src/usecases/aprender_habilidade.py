from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

def aprender_habilidade(console, player_id):
    """
    Permite ao jogador aprender uma habilidade usando um livro de habilidade do inventário.
    Mostra quem pode aprender a habilidade (Player ou Cavaleiros da party).
    """
    with obter_cursor() as cursor:
        # 1️⃣ Obtém os livros de habilidade do inventário do jogador
        cursor.execute("""
            SELECT iv.id_item, iv.nome, c.nome, e.nome, custo, dano, nivel_necessario, h.id_habilidade, h.classe_habilidade, h.elemento_habilidade, iv.quantidade
            FROM inventario_view iv
            JOIN livro l ON l.id_item = iv.id_item
            JOIN habilidade h ON h.id_habilidade = l.id_habilidade
            JOIN elemento e ON e.id_elemento = h.elemento_habilidade
            JOIN classe c ON c.id_classe = h.classe_habilidade
            WHERE iv.id_player = %s AND iv.tipo_item = 'Livro';
        """, (player_id,))
        
        livros_habilidade = cursor.fetchall()
        
        if not livros_habilidade:
            console.print("[bold red]❌ Você não tem livros de habilidade no inventário![/bold red]")
            input()
            return
        
        # 2️⃣ Exibe os livros disponíveis para aprendizado
        console.print(Panel("[bold yellow]📖 Escolha um livro de habilidade para aprender:[/bold yellow]"))
        tabela = Table(show_header=True, header_style="bold cyan")
        tabela.add_column("#", justify="center")
        tabela.add_column("Nome", justify="left")
        tabela.add_column("Classe", justify="center")
        tabela.add_column("Elemento", justify="center")
        tabela.add_column("Custo\nde\nCosmo", justify="center")
        tabela.add_column("Efeito\nhabilidade", justify="center")
        tabela.add_column("Nível Necessário", justify="center")
        tabela.add_column("Quantidade", justify="center")
        
        
        for i, (id_item, nome, classe, elemento, custo, dano, nivel, id_habilidade, classe_habilidade, elemento_habilidade, quantidade) in enumerate(livros_habilidade, start=1):
            tabela.add_row(str(i), nome, str(classe), str(elemento), str(custo), str(dano), str(nivel), str(quantidade))
        
        console.print(tabela)
        console.print("\n[bold green]➡️ Digite o número do livro ou '0' para cancelar:[/bold green]")
        escolha = input().strip()
        
        if escolha == "0":
            return
        
        if not escolha.isdigit() or int(escolha) < 1 or int(escolha) > len(livros_habilidade):
            console.print("[bold red]❌ Escolha inválida![/bold red]")
            input()
            return
        
        # Obtém a habilidade escolhida
        id_item, nome_habilidade, classe_habilidade_nome, elemento_habilidade_nome, custo, dano, nivel_necessario, id_habilidade, classe_habilidade, elemento_habilidade, quantidade = livros_habilidade[int(escolha) - 1]

        # 3️⃣ Obtém Player e Cavaleiros compatíveis
        with obter_cursor() as cursor:
            # Verifica se o Player pode aprender (Player não tem classe, mas deve ter o mesmo elemento)
            cursor.execute("""
                SELECT id_player, player_nome, elemento_nome
                FROM player_info_view
                WHERE id_player = %s AND id_elemento = %s
                    AND NOT EXISTS(
                        SELECT 1 FROM habilidade_player WHERE habilidade_player.id_player = player_info_view.id_player AND habilidade_player.id_habilidade = %s 
                    );
            """, (player_id, elemento_habilidade, id_habilidade))
            
            player_compatível = cursor.fetchone()

            # Obtém Cavaleiros compatíveis (mesmo elemento e classe da habilidade escolhida)
            cursor.execute("""
                SELECT id_cavaleiro, nome_cavaleiro, classe_nome, elemento_nome
                FROM instancia_cavaleiro_view ic
                WHERE ic.id_player = %s 
                AND ic.classe_id = %s 
                AND ic.elemento_id = %s
                AND NOT EXISTS (
                    SELECT 1 FROM habilidade_cavaleiro WHERE habilidade_cavaleiro.id_cavaleiro = ic.id_cavaleiro AND habilidade_cavaleiro.id_habilidade = %s
                );
            """, (player_id, classe_habilidade, elemento_habilidade, id_habilidade))
            
            cavaleiros_compatíveis = cursor.fetchall()
        
        # 4️⃣ Exibir quem pode aprender a habilidade
        console.print(Panel("[bold cyan]📜 Quem pode aprender essa habilidade:[/bold cyan]"))

        tabela_personagens = Table(show_header=True, header_style="bold cyan", show_lines=True)
        tabela_personagens.add_column("#", justify="center")
        tabela_personagens.add_column("Nome", justify="left")
        tabela_personagens.add_column("Classe", justify="center")
        tabela_personagens.add_column("Elemento", justify="center")

        personagens_disponíveis = []

        if player_compatível:
            personagens_disponíveis.append(("player", player_compatível[0], player_compatível[1], "Sem Classe", player_compatível[2]))
        
        for cavaleiro in cavaleiros_compatíveis:
            personagens_disponíveis.append(("cavaleiro", cavaleiro[0], cavaleiro[1], cavaleiro[2], cavaleiro[3]))
        
        if not personagens_disponíveis:
            console.print("[bold red]❌ Nenhum personagem pode aprender essa habilidade![/bold red]")
            input()
            return
        
        for i, (_, id_personagem, nome, classe, elemento) in enumerate(personagens_disponíveis, start=1):
            tabela_personagens.add_row(str(i), nome, classe, elemento)

        console.print(tabela_personagens)

        # 5️⃣ Escolher quem aprenderá a habilidade
        console.print("\n[bold green]➡️ Digite o número do personagem ou '0' para cancelar:[/bold green]")
        escolha_personagem = input().strip()

        if escolha_personagem == "0":
            return

        if not escolha_personagem.isdigit() or int(escolha_personagem) < 1 or int(escolha_personagem) > len(personagens_disponíveis):
            console.print("[bold red]❌ Escolha inválida![/bold red]")
            input()
            return

        tipo_personagem, id_personagem, nome_personagem, _, _ = personagens_disponíveis[int(escolha_personagem) - 1]

        # 6️⃣ Aplicar aprendizado da habilidade
        with obter_cursor() as cursor:
            if tipo_personagem == "player":
                cursor.execute("SELECT aprender_habilidade(%s, NULL, %s)", (id_personagem, id_habilidade))
            else:
                cursor.execute("SELECT aprender_habilidade(%s, %s, %s)", (player_id, id_personagem, id_habilidade))
            
            mensagem = cursor.fetchone()[0]
            console.print(f"[bold magenta]{mensagem}[/bold magenta]")

        input("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
