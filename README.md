# 2024.2-T01-Pontual
Repositório de projeto da disciplina de REQ-T1.<br>

<a href="https://mdsreq-fga-unb.github.io/2024.2-T01-Pontual/">Acesse a documentação do projeto.</a>

## Como rodar a API

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

## Como rodar o Frontend

```bash
# Instale as dependências
flutter pub get

# Atualize a biblioteca http para aceitar credenciais
# OBS: Encontre o arquivo "browser_client.dart" no seu sistema e altere as linhas 4 e 7:
# (find ~/.pub-cache/hosted/pub.dev/http-1.3.0/lib/src -name "browser_client.dart")

bash scripts/flutter.sh

# Execute o projeto
flutter run -d web-server --web-hostname=localhost --web-port=3000
```
