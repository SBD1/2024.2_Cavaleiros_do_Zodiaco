# Documentação: Uso do `pg_cron` no Jogo *Cavaleiros do Zodíaco*

## 1. O que é o `pg_cron`?
O `pg_cron` é uma extensão do PostgreSQL que permite agendar tarefas (jobs) de forma semelhante ao *cron* de sistemas Unix. Ela é especialmente útil quando precisamos automatizar processos recorrentes diretamente no SGBD, sem depender de scripts externos.

No jogo *Cavaleiros do Zodíaco*, utilizamos o `pg_cron` para “reviver” inimigos e *bosses* periodicamente, mantendo a dinâmica do jogo sempre ativa.

---

## 2. Configuração

### 2.1 Ativando a extensão
Para usar o `pg_cron`, é preciso primeiro habilitá-lo no PostgreSQL. Isso inclui instalar a extensão e garantir que o arquivo de configuração (`postgresql.conf`) esteja com `shared_preload_libraries` configurado para carregar o `pg_cron`. Em seguida, é necessário reiniciar o serviço do PostgreSQL para aplicar as mudanças.

### 2.2 Permissões e parâmetros
- Verifique se o usuário que executará os jobs tem privilégios adequados para as tabelas e funções necessárias.
- A extensão `pg_cron` normalmente opera em um *database* específico, então assegure-se de ter a extensão criada no *database* onde as tarefas serão agendadas.

---

## 3. Funções de Reviver

Para garantir que os inimigos e os *bosses* sejam restaurados quando estiverem mortos (HP zero ou menor), criamos duas funções em *PL/pgSQL*:

1. **reviver_todos_boss()**: Responsável por atualizar o HP de todos os *bosses* para o valor máximo, caso o HP atual seja menor ou igual a zero.  
2. **reviver_todas_instancia_inimigo()**: Restaura o HP de todas as instâncias de inimigos, definindo-o novamente para o valor máximo.

Ambas emitem um aviso (via `RAISE NOTICE`) com o número de registros atualizados, facilitando o monitoramento das operações.

---

## 4. Agendamento das Tarefas (Jobs)

O *scheduler* do `pg_cron` é utilizado para executar as funções de reviver de forma automática em intervalos pré-definidos. Configura-se um *job* para cada função:

- **Job de reviver bosses**: executa a função que redefine o HP dos *bosses* a cada *n* minutos.
- **Job de reviver inimigos**: executa a função que redefine o HP das instâncias de inimigos, também em intervalos regulares.

Ambos podem ser configurados para rodar a cada 5 minutos, por exemplo, garantindo que os jogadores sempre encontrem desafios no jogo.

---

## 5. Histórico de Versões

| Data       | Versão | Descrição                                    | Autor        |
|------------|--------|----------------------------------------------|--------------|
| 14/02/2025 | 1.0    | Criação do documento e implementação inicial | Lucas Ramon  |

---

## 6. Referências Bibliográficas

- [Documentação Oficial do PostgreSQL](https://www.postgresql.org/docs/)
- [Repositório do `pg_cron` no GitHub](https://github.com/citusdata/pg_cron)
- SILBERSCHATZ, A.; KORTH, H.; SUDARSHAN, S. *Sistemas de Banco de Dados*. 6ª Edição, McGraw Hill, 2020.
- *Cavaleiros do Zodíaco – O Jogo de Terminal*: Documentação interna da disciplina de Banco de Dados, Universidade XX, 2025.

---
