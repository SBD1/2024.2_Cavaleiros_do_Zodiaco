import pygame
import os
import sys
import keyboard  # Biblioteca para capturar teclas pressionadas
import time  
from ..database import obter_cursor  # Importa a conexão com o banco de dados

def tocar_tema_encerramento():
    try:
        # Obtém o nome do arquivo de áudio no banco de dados
        with obter_cursor() as cursor:
            cursor.execute("SELECT nome_arquivo FROM audios WHERE nome = %s;", ("Tema de Encerramento",))
            resultado = cursor.fetchone()

        # Se não encontrar o áudio no banco, exibe um erro
        if not resultado:
            raise FileNotFoundError("🎵 Tema de Encerramento não encontrado no banco de dados!")

        nome_arquivo = resultado[0]  # Obtém o nome do arquivo da consulta SQL

        # Inicializa o mixer do pygame
        pygame.mixer.init()

        # Obtém o caminho absoluto do diretório atual
        diretorio_atual = os.path.dirname(os.path.abspath(__file__))

        # Constrói o caminho absoluto para o arquivo de música na pasta 'assets'
        caminho_musica = os.path.join(diretorio_atual, '..', 'assets', nome_arquivo)

        # Verifica se o arquivo de música existe
        if not os.path.exists(caminho_musica):
            raise FileNotFoundError(f"Arquivo de música '{nome_arquivo}' não encontrado! Verifique a pasta 'assets'.")

        # Carrega o arquivo de música
        pygame.mixer.music.load(caminho_musica)

        # Reproduz a música
        pygame.mixer.music.play()
        time.sleep(0)  # Aguarda 3 segundos antes de aceitar entrada do usuário

        print(f"🎵 Tema de encerramento tocando... Pressione qualquer tecla para sair.")

        # Aguarda qualquer tecla ser pressionada para interromper a música
        keyboard.read_event()  

        print("⏹️ Encerrando a música e saindo...")
        pygame.mixer.music.stop()
        pygame.quit()
        sys.exit()

    except Exception as e:
        print(f"❌ Ocorreu um erro durante a reprodução da música: {str(e)}")
