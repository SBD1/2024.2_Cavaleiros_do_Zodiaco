import pygame
import time
import os

def tocar_musica():
    try:
        # Inicializa o mixer do pygame
        pygame.mixer.init()

        # Obtém o caminho absoluto do diretório atual
        diretorio_atual = os.path.dirname(os.path.abspath(__file__))

        # Constrói o caminho absoluto para o arquivo de música na pasta 'assets'
        caminho_musica = os.path.join(diretorio_atual, '..', 'assets', 'tema.mp3')

        # Verifica se o arquivo de música existe
        if not os.path.exists(caminho_musica):
            raise FileNotFoundError("Arquivo de música não encontrado! Verifique a pasta 'assets'.")

        # Carrega o arquivo de música
        pygame.mixer.music.load(caminho_musica)

        # Reproduz a música
        pygame.mixer.music.play()

        
    except Exception as e:
        print(f"Ocorreu um erro durante a reprodução da música: {str(e)}")

