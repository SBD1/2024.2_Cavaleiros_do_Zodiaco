param (
    [string]$acao
)

# Função para verificar se os containers estão rodando
function Verificar-Containers {
    $containers = docker ps --format "{{.Names}}"
    if ($containers -match "game") {
        Write-Host "Containers ja estao rodando!"
    } else {
        Write-Host "Iniciando os containers..."
        docker-compose up -d
        Start-Sleep -Seconds 5  # Aguarda os containers subirem
    }
}


# Função para exibir a ajuda
function Mostrar-Ajuda {
Write-Host "|------------------------------------------------------------------------|"
Write-Host "|               Comandos disponiveis no jogo_cdz.ps1                     |"
Write-Host "|------------------------------------------------------------------------|"
Write-Host "| .\jogo_cdz.ps1 reset_setup       - Resetar e reconstruir os containers.|"
Write-Host "| .\jogo_cdz.ps1 comecar_jogo      - Inicia o jogo.                      |"
Write-Host "| .\jogo_cdz.ps1 subir_containers  - Sobe os containers                  |"
Write-Host "| .\jogo_cdz.ps1 parar_containers  - Para a execucao dos contaeiners.    |"
Write-Host "|------------------------------------------------------------------------|"
Write-Host "                                                                         "


 }

# Switch para gerenciar os comandos
switch ($acao) {
    "reset_setup" {
        Write-Host "Resetando e configurando os containers..."
        docker-compose down -v
        docker-compose up --build
    }
    "comecar_jogo" {
        Verificar-Containers
        Write-Host "Iniciando o jogo..."
        python -m src.main
    }
    "subir_containers" {
        Write-Host "Subindo os containers..."
        docker-compose up -d
    }
    "parar_containers" {
        Write-Host "Parando os containers..."
        docker-compose down
    }
    "--help" {
        Mostrar-Ajuda
    }
    default {
        Write-Host -ForegroundColor Red "Comando invalido! Use '--help' para ver os comandos disponiveis."
        Mostrar-Ajuda
    }
}
