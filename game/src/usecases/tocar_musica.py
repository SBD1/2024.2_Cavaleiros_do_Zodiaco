import os
import pygame

# Inicializa o mixer do pygame para tocar áudio
pygame.mixer.init()

def tocar_musica(nome_musica, volume):
    """Inicia a reprodução de uma música localizada no diretório de assets"""
    diretorio_atual = os.path.dirname(os.path.abspath(__file__))
    caminho_musica = os.path.join(diretorio_atual, "..", "assets", nome_musica)

    if not os.path.exists(caminho_musica):
        raise FileNotFoundError(f"Arquivo de música não encontrado: {caminho_musica}")
    
    pygame.mixer.music.load(caminho_musica)
    pygame.mixer.music.set_volume(volume)
    pygame.mixer.music.play(-1)  # -1 faz a música tocar em loop

def parar_musica():
    """Para a música"""
    pygame.mixer.music.stop()
