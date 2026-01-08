# 📘 GUIA DE CRIAÇÃO DO PROJETO

Este guia mostra como criar o projeto Rails a partir dos arquivos fornecidos.

## Pré-requisitos

- Ruby 2.5.1 instalado (use `rbenv` ou `rvm`)
- MySQL 5.7+ instalado e rodando
- Bundler instalado
- Git instalado

## Passo a Passo

### 1. Instale o Ruby 2.5.1

```bash
# Com rbenv
rbenv install 2.5.1
rbenv local 2.5.1
```
- _Nota: Caso não tenha o rbenv, instale com os seguintes passos:_

```bash
# Instale dependências necessárias
sudo apt update
sudo apt install -y git build-essential libssl-dev libreadline-dev zlib1g-dev

# Clone o repositório do rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Configure o rbenv no bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc

# Recarregue o shell
source ~/.bashrc

# Instale o ruby-build (plugin do rbenv)
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Verifique a instalação
rbenv --version
rbenv install -l
```

### 2. clone o repositório

```bash
git clone <url-do-repositorio>
cd rails_performance_challenge
```

### 3. Instale as dependências

```bash
gem install bundler -v '~> 1.17'
bundle _1.17.3_ install
```

**Nota:** Se encontrar erros com o `mysql2`, tente:
```bash
# No macOS
brew install mysql
bundle config build.mysql2 --with-mysql-config=/usr/local/opt/mysql/bin/mysql_config

# No Ubuntu/Debian
sudo apt-get install libmysqlclient-dev
```

_Configure o user root (se necessário)_
```bash
sudo service mysql stop

# Entre no bash do Mysql
sudo mysql

# No bash do Mysql
ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY 'sua_senha'; 
FLUSH PRIVILEGES;
\q

sudo service mysql stop
```

### 4. Configure o banco de dados

```bash
# Copie o arquivo de exemplo
cp config/database.yml.example config/database.yml

# Edite com suas credenciais (se necessário)
nano config/database.yml
```

Crie o banco:
```bash
bundle exec rake db:create
bundle exec rake db:migrate
```

### 5. Popule o banco de dados (para testar)

```bash
# Para testes completos (100.000 pedidos)
bundle exec rake db:seed_challenge

# OU para testes rápidos (10.000 pedidos)
bundle exec rake db:seed_minimal
```

### 6. Execute os testes de performance

```bash
bundle exec rspec spec/models/order_performance_spec.rb
```

Você verá output como:
```
--- Teste: generate_report ---
Tempo de execução: 2.3456 segundos
Número de queries: 1001
```

### 7. Inicie o servidor (opcional)

```bash
bundle exec rails server
```

Acesse: http://localhost:3000

Você verá os alertas do Bullet sobre N+1 queries.

---

## Enviando para o GitHub

### 1. Inicialize o repositório

```bash
cd rails_performance_challenge
git init
```

### 2. Configure o .gitignore

O `.gitignore` já está configurado para ignorar:
- Arquivos de banco de dados SQLite
- Logs
- Arquivos temporários
- **CHEAT_SHEET.md** (confidencial!)

### 3. Faça o commit inicial

```bash
git add .
git commit -m "Initial commit - Performance Challenge"
```

### 4. Crie o repositório no GitHub

1. Vá em https://github.com/new
2. Crie um repositório **privado**
3. NÃO inicialize com README

### 5. Conecte e envie

```bash
git remote add origin git@github.com:seu-usuario/rails-performance-challenge.git
git branch -M main
git push -u origin main
```

---

## Preparando para o Candidato

### O que o candidato receberá:
1. Acesso ao repositório (ou um fork)
2. README.md com instruções

### O que o candidato NÃO deve ver:
1. ❌ CHEAT_SHEET.md (está no .gitignore)
2. ❌ Este arquivo SETUP_GUIDE.md

### Verificação final:
```bash
# Confirme que CHEAT_SHEET.md não está no repo
git ls-files | grep CHEAT_SHEET
# Não deve retornar nada
```

---

## Estrutura do Projeto

```
rails_performance_challenge/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   └── orders_controller.rb      # Problemas aqui
│   ├── models/
│   │   ├── order.rb                  # Problemas aqui
│   │   └── product.rb
│   └── views/
│       └── orders/
│           └── index.html.erb        # N+1 na view
├── config/
│   └── ...
├── db/
│   └── migrate/
│       ├── 20240101000001_create_products.rb  # Sem índices
│       └── 20240101000002_create_orders.rb    # Sem índices
├── lib/
│   └── tasks/
│       └── seed_challenge.rake        # Task para popular
├── spec/
│   └── models/
│       └── order_performance_spec.rb  # Testes de performance
├── CHEAT_SHEET.md                     # CONFIDENCIAL!
├── README.md                          # Para o candidato
└── SETUP_GUIDE.md                     # Este arquivo
```

---

## Troubleshooting

### Erro: "Could not find gem"
```bash
bundle install --path vendor/bundle
```

### Erro: "Could not find mysql2"
```bash
# macOS
brew install mysql
bundle config build.mysql2 --with-mysql-config=/usr/local/opt/mysql/bin/mysql_config

# Linux
sudo apt-get install libmysqlclient-dev
```

### Erro: "Access denied for user 'root'@'localhost'"
Edite `config/database.yml` com seu usuário e senha do MySQL.

### Erro: "Can't connect to local MySQL server"
```bash
# macOS
brew services start mysql

# Linux
sudo systemctl start mysql
```

### Erro: "Ruby version mismatch"
```bash
# Verifique a versão atual
ruby -v

# Se não for 2.5.1, instale
rbenv install 2.5.1
rbenv local 2.5.1
```

### Erro no RSpec
```bash
bundle exec rails generate rspec:install
```

---

Qualquer dúvida, entre em contato!
