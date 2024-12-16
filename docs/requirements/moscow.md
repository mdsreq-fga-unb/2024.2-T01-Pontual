# 2. Priorização e MVP

**2.1 MoSCoW**

A equipe definiu que o método principal de priorização do Product Backlog seria o MoSCoW. A partir disso, foi realizada a priorização dos itens do Product Backlog, conforme a tabela a seguir.

<div align="center">
    <img style="border-radius: 5px;" src="https://raw.githubusercontent.com/mdsreq-fga-unb/2024.2-T01-Pontual/refs/heads/main/docs/assets/moscow.png" alt="Tabela de Priorização no Método MoSCoW" />
</div>
<div align="right">
    <a target="_blank" href="https://www.figma.com/board/v3kWX9MwLe90r7YMZYg2bv/PBB---Pontual?node-id=0-1&t=V2qqCBaPOzMJcBHK-1">
        Link
    </a>
</div>

**Must Have**

- Realizar cadastro de usuário
- Dividir usuários entre funcionário e gestor
- Realizar a marcação de ponto
- Realizar cálculo de horas totais
- Gerar relatório do cálculo de horas em PDF

**Should Have**

- Realizar cálculo de horas extra e de atraso
- Acessar histórico de cada funcionário
- Permitir assinatura digital

**Could Have**

- Gerar notificação, para o gestor, na marcação de aula VIP
- Permitir gestores criar lembretes de atraso para os funcionários

**Won't Have**

- Gerar notificações automáticas aos funcionários

**2.2 Tabela de Priorização Tradicional**

A partir da priorização do MoSCoW, que é mais abrangente, a equipe decidiu realizar uma priorização mais detalhada, utilizando a Escala Tradicional de Priorização. Assim, a tabela a seguir apresenta a priorização final dos itens do Backlog.

| Item | Valor de Negócio | Complexidade Técnica | Total |
|-----------|-------------|------------|------------|
| Realizar cálculo de horas totais                                 | 4 | 5 | 9 |
| Realizar a marcação de ponto                                     | 5 | 3 | 8 |
| Dividir usuários entre funcionário e gestor                      | 4 | 4 | 8 |
| Realizar cálculo de horas extra e de atraso                      | 4 | 4 | 8 |
| Realizar cadastro de usuário                                     | 4 | 3 | 7 |
| Gerar relatório do cálculo de horas em PDF                       | 4 | 3 | 7 |
| Acessar histórico de cada funcionário                            | 3 | 3 | 6 |
| Permitir assinatura digital                                      | 2 | 2 | 4 |
| Permitir gestores criar lembretes de atraso para os funcionários | 2 | 1 | 3 |
| Gerar notificação, para o gestor, na marcação de aula VIP        | 1 | 1 | 2 |

**Lógica das Escalas**

- Valor de Negócio:
    - 1: Não dificulta em nada o funcionamento do negócio, e traz poucos benefícios
    - 2: Não dificulta o funcionamento do negócio, mas pode trazer alguns benefícios
    - 3: Não dificulta o funcionamento do negócio, mas traz benefícios significativos
    - 4: Dificulta o funcionamento do negócio, e traz benefícios muito significativos
    - 5: Indispensável para o funcionamento do negócio

- Complexidade Técnica:
    - 1: Complexo (Queues e Jobs), muitas dependências (Sistema de Notificação)
    - 2: Complexo (Queues e Jobs), poucas dependências (Assinatura Digital)
    - 3: Simples (HTTP, WebSocket e Cache), poucas dependências (Login e Bibliotecas)
    - 4: Trivial (HTTP), possíveis dependências (CRUD, Cálculos e Lógica de Negócio)
    - 5: Trivial (HTTP), sem dependências (Cálculos Básicos e Listagens)

**2.3 MVP (*Minimum Viable Product*)**

Seguindo a lógica do MoSCoW e da Escala Tradicional de Priorização, o MVP do projeto será composto pelos items que obtiveram pontuação maior ou igual a 7. Desta forma, o MVP do projeto será composto pelos seguintes itens:

- Realizar cálculo de horas totais
- Realizar a marcação de ponto
- Dividir usuários entre funcionário e gestor
- Realizar cálculo de horas extra e de atraso
- Realizar cadastro de usuário
- Gerar relatório do cálculo de horas em PDF

Além disso, o item **"Acessar histórico de cada funcionário"**, por ter obtido uma pontuação significativa, será considerado caso haja tempo suficiente para sua implementação.

---

## Histórico de Versão

| Data       | Versão | Descrição                                                | Autor                      | Revisores |
| ---------- | ------ | -------------------------------------------------------- | -------------------------- | ---------------------------------------- |
| 07/12/2024 | 0.1    | Priorização do Backlog utilizando o MoSCoW | Mateus Vieira e Caio Lamego | Daniela Alarcão, João Lucas e Pedro Gondim |
| 08/12/2024 | 0.2    | Realização da Escala Tradicional de Priorização | Caio Lamego, Daniela Alarcão, João Lucas, Mateus Vieira e Pedro Gondim | |
