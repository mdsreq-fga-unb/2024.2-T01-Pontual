# 2024.2-T01-Pontual
Repositório de projeto da disciplina de REQ-T1.<br>

<a href="https://mdsreq-fga-unb.github.io/2024.2-T01-Pontual/">Acesse a documentação do projeto.</a>


## Como rodar o projeto

```bash
# Configurações iniciais
make config

# Criei um ambiente virtual
python3 -m venv env

# Ative o ambiente virtual
source env/bin/activate

# Instale as dependências
make install

# Inicie o banco de dados
docker compose up -d

# Execute o projeto
make start
```
