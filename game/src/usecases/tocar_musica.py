import os
import pygame


pygame.mixer.init()

posicao_pausada = 0

def tocar_musica(nome_musica, volume=0.5):
    global posicao_pausada
    diretorio_atual = os.path.dirname(os.path.abspath(__file__))
    caminho_musica = os.path.join(diretorio_atual, "..", "assets", nome_musica)

    if not os.path.exists(caminho_musica):
        raise FileNotFoundError(f"Arquivo de música não encontrado: {caminho_musica}")
    
    pygame.mixer.music.load(caminho_musica)
    pygame.mixer.music.set_volume(volume)
    pygame.mixer.music.play(-1)  

def pausar_musica():
    global posicao_pausada
    posicao_pausada = pygame.mixer.music.get_pos() / 1000  
    pygame.mixer.music.pause()

def resumir_musica():
    global posicao_pausada
    pygame.mixer.music.unpause()

def tocar_efeito_sonoro(nome_efeito, volume=1.0):
    global posicao_pausada
    diretorio_atual = os.path.dirname(os.path.abspath(__file__))
    caminho_efeito = os.path.join(diretorio_atual, "..", "assets", "habilidades", nome_efeito)

    if not os.path.exists(caminho_efeito):
        raise FileNotFoundError(f"Arquivo de efeito sonoro não encontrado: {caminho_efeito}")

    pausar_musica()

    efeito = pygame.mixer.Sound(caminho_efeito)
    efeito.set_volume(volume)
    efeito.play()

    pygame.time.wait(int(efeito.get_length() * 1000))


    resumir_musica()

def parar_musica():

    pygame.mixer.music.stop()