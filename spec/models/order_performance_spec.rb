require 'rails_helper'
require 'benchmark'

RSpec.describe Order, type: :model do
  describe 'Performance Tests' do
    before(:all) do
      # Criar dados de teste uma vez para todos os testes de performance
      DatabaseCleaner.clean_with(:truncation)

      @products = create_list(:product, 50)
      @orders = []

      1000.times do
        @orders << create(:order, product: @products.sample)
      end

      puts "\n" + "=" * 60
      puts "DADOS DE TESTE CRIADOS:"
      puts "  - #{Product.count} produtos"
      puts "  - #{Order.count} pedidos"
      puts "=" * 60 + "\n"
    end

    after(:all) do
      DatabaseCleaner.clean_with(:truncation)
    end

    describe '.generate_report' do
      it 'mede o tempo de execução do relatório' do
        # Este teste deve mostrar o problema N+1
        # ANTES da otimização: muitas queries (1 + N)
        # DEPOIS da otimização: poucas queries (eager loading)

        puts "\n--- Teste: generate_report ---"

        query_count = 0
        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          query_count += 1
        end

        time = Benchmark.measure do
          Order.generate_report
        end

        ActiveSupport::Notifications.unsubscribe('sql.active_record')

        puts "Tempo de execução: #{time.real.round(4)} segundos"
        puts "Número de queries: #{query_count}"
        puts "-" * 40

        # META: Após otimização, deve executar em menos de 0.5 segundos
        # e usar menos de 10 queries (idealmente 2-3 com eager loading)
        expect(Order.generate_report).to be_an(Array)
      end
    end

    describe '.orders_summary_by_status' do
      it 'mede o tempo de execução do sumário por status' do
        puts "\n--- Teste: orders_summary_by_status ---"

        query_count = 0
        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          query_count += 1
        end

        time = Benchmark.measure do
          Order.orders_summary_by_status
        end

        ActiveSupport::Notifications.unsubscribe('sql.active_record')

        puts "Tempo de execução: #{time.real.round(4)} segundos"
        puts "Número de queries: #{query_count}"
        puts "-" * 40

        # META: Após otimização, deve usar apenas 1 query com GROUP BY
        expect(Order.orders_summary_by_status).to be_a(Hash)
      end
    end

    describe '.search_by_customer' do
      it 'mede o tempo de busca por email do cliente' do
        puts "\n--- Teste: search_by_customer ---"

        time = Benchmark.measure do
          100.times do
            Order.search_by_customer('customer')
          end
        end

        puts "Tempo para 100 buscas: #{time.real.round(4)} segundos"
        puts "Média por busca: #{(time.real / 100 * 1000).round(4)} ms"
        puts "-" * 40

        # META: Após adicionar índice, deve ser significativamente mais rápido
        expect(Order.search_by_customer('customer')).to respond_to(:each)
      end
    end

    describe '.find_by_date_range' do
      it 'mede o tempo de busca por intervalo de datas' do
        puts "\n--- Teste: find_by_date_range ---"

        start_date = 6.months.ago.to_date
        end_date = Date.today

        time = Benchmark.measure do
          100.times do
            Order.find_by_date_range(start_date, end_date)
          end
        end

        puts "Tempo para 100 buscas: #{time.real.round(4)} segundos"
        puts "Média por busca: #{(time.real / 100 * 1000).round(4)} ms"
        puts "-" * 40

        # META: Após adicionar índice em order_date, deve ser mais rápido
        expect(Order.find_by_date_range(start_date, end_date)).to respond_to(:each)
      end
    end

    describe '.count_orders_by_city' do
      it 'mede o tempo de contagem por cidade' do
        puts "\n--- Teste: count_orders_by_city ---"

        query_count = 0
        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          query_count += 1
        end

        time = Benchmark.measure do
          Order.count_orders_by_city
        end

        ActiveSupport::Notifications.unsubscribe('sql.active_record')

        puts "Tempo de execução: #{time.real.round(4)} segundos"
        puts "Número de queries: #{query_count}"
        puts "-" * 40

        # META: Após otimização com GROUP BY, deve usar apenas 1 query
        expect(Order.count_orders_by_city).to be_a(Hash)
      end
    end

    describe '.calculate_daily_revenue' do
      it 'mede o tempo de cálculo de receita diária' do
        puts "\n--- Teste: calculate_daily_revenue ---"

        date = Date.today - 30.days

        time = Benchmark.measure do
          50.times do
            Order.calculate_daily_revenue(date)
          end
        end

        puts "Tempo para 50 cálculos: #{time.real.round(4)} segundos"
        puts "Média por cálculo: #{(time.real / 50 * 1000).round(4)} ms"
        puts "-" * 40

        # META: Após usar SUM no banco, deve ser muito mais rápido
        expect(Order.calculate_daily_revenue(date)).to be_a(Numeric)
      end
    end
  end

  describe 'Query Count Tests (N+1 Detection)' do
    before do
      @products = create_list(:product, 10)
      100.times { create(:order, product: @products.sample) }
    end

    it 'detecta problema N+1 no generate_report' do
      query_count = 0

      ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
        query_count += 1
      end

      Order.generate_report

      ActiveSupport::Notifications.unsubscribe('sql.active_record')

      puts "\n[N+1 Test] generate_report executou #{query_count} queries"

      # ANTES da otimização: > 100 queries (1 + N para cada order)
      # DEPOIS da otimização: deve ser < 5 queries
      # Este expect vai FALHAR antes da otimização - é intencional!
      # expect(query_count).to be < 5
    end
  end
end
