# 🚀 Desafio de Performance - Rails

## Sobre o Desafio

Você está recebendo um sistema de gerenciamento de pedidos que foi desenvolvido às pressas e está com sérios problemas de performance. Sua missão é identificar e corrigir esses problemas, tornando a aplicação mais eficiente e escalável.

## 📋 Requisitos

- Ruby 2.5.1
- Rails 4.2.11.3
- MySQL 5.7+
- Bundler

## 🔧 Instalação

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd rails_performance_challenge
```

### 2. Instale as dependências

```bash
gem install bundler -v '~> 1.17'
bundle _1.17.3_ install
```

### 3. Configure o banco de dados

Copie o arquivo de exemplo e edite com suas credenciais:
```bash
cp config/database.yml.example config/database.yml
```

Edite `config/database.yml` com seu usuário e senha do MySQL.

Crie o banco de dados:
```bash
rake db:create
rake db:migrate
```

### 4. Popule o banco de dados

Para testes completos (30.000 pedidos):
```bash
rake db:seed_challenge
```

## 🧪 Executando os Testes

Os testes de performance estão em `spec/models/order_performance_spec.rb`:

```bash
bundle exec rspec spec/models/order_performance_spec.rb --format documentation
```

## 📊 O que você precisa fazer

### 1. Identificar Problemas

Analise o código e identifique:
- Queries N+1
- Falta de índices no banco de dados
- Lógica que poderia ser otimizada com SQL
- Carregamento de dados desnecessários

### 2. Corrigir e Otimizar

Você deve melhorar a performance de:

1. **`Order.generate_report`** - Método que gera relatório de pedidos
2. **`Order.orders_summary_by_status`** - Sumário de pedidos por status
3. **`Order.search_by_customer`** - Busca por email do cliente
4. **`Order.find_by_date_range`** - Busca por intervalo de datas
5. **`Order.count_orders_by_city`** - Contagem de pedidos por cidade
6. **`Order.calculate_daily_revenue`** - Cálculo de receita diária
7. **`OrdersController#index`** - Listagem de pedidos na view

### 3. Criar Migrations

Caso precise, crie as migrations necessárias para fazer outras otimizações no banco de dados ou adicionar indices.

### 4. Documentar

Crie um arquivo `SOLUTION.md` explicando:
- Quais problemas você encontrou
- Como você resolveu cada um
- O impacto das suas otimizações (antes vs depois)

## 📈 Métricas de Sucesso

Ao executar os testes, você verá métricas como:
- Tempo de execução em segundos
- Número de queries executadas

**Objetivos de performance:**
- `generate_report`: < 10 queries, < 0.5s
- `orders_summary_by_status`: 1 query apenas
- `count_orders_by_city`: 1 query apenas
- Todas as buscas: significativamente mais rápidas com índices

## 🛠 Ferramentas Úteis

O projeto já vem configurado com:
- **Bullet** - Detecta queries N+1 automaticamente (veja os alertas no console/browser)
- **RSpec Benchmark** - Matchers para testes de performance

## ⏱ Tempo Estimado

1h ~ 1:30h

## 📝 Entregáveis

1. Código otimizado
2. Arquivo `SOLUTION.md` com suas explicações
3. Testes passando e mostrando melhoria de performance

## 💡 Dicas

- Use `rails console` para testar suas queries
- O Bullet vai te mostrar onde há N+1
- Pense em quais campos são mais buscados/filtrados
- SQL pode ser mais eficiente que Ruby para agregações

---

Boa sorte! 🍀
