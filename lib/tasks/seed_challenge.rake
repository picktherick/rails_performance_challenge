namespace :db do
  desc 'Popula o banco de dados com dados de teste para o desafio de performance'
  task seed_challenge: :environment do
    require 'faker'

    puts "Limpando dados existentes..."
    Order.delete_all
    Product.delete_all

    puts "Criando produtos..."
    categories = ['Eletrônicos', 'Roupas', 'Livros', 'Casa & Jardim', 'Esportes', 'Brinquedos']

    products = []
    100.times do |i|
      products << Product.create!(
        name: Faker::Commerce.product_name,
        sku: "SKU-#{Faker::Alphanumeric.alphanumeric(8).upcase}",
        price: Faker::Commerce.price(10.0..500.0),
        category: categories.sample,
        description: Faker::Lorem.paragraph(3),
        active: [true, true, true, false].sample
      )
      print "." if (i + 1) % 10 == 0
    end
    puts "\n#{products.count} produtos criados!"

    puts "Criando pedidos (isso pode demorar um pouco)..."
    statuses = Order::STATUSES
    cities = ['São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Porto Alegre', 'Curitiba',
              'Salvador', 'Fortaleza', 'Brasília', 'Recife', 'Manaus']
    states = ['SP', 'RJ', 'MG', 'RS', 'PR', 'BA', 'CE', 'DF', 'PE', 'AM']

    order_count = 30_000
    batch_size = 1000

    order_count.times do |i|
      product = products.sample
      quantity = rand(1..10)

      Order.create!(
        product_id: product.id,
        customer_email: Faker::Internet.email,
        customer_name: Faker::Name.name,
        status: statuses.sample,
        quantity: quantity,
        total_amount: product.price * quantity,
        order_date: Faker::Date.between(1.year.ago, Date.today),
        shipping_address: Faker::Address.street_address,
        city: cities.sample,
        state: states.sample,
        zip_code: Faker::Address.zip_code,
        country: 'Brasil',
        notes: [nil, Faker::Lorem.sentence].sample
      )

      if (i + 1) % batch_size == 0
        puts "#{i + 1} pedidos criados..."
      end
    end

    puts "\n=========================================="
    puts "Seed concluído!"
    puts "Total de produtos: #{Product.count}"
    puts "Total de pedidos: #{Order.count}"
    puts "=========================================="
  end

  desc 'Popula com dados mínimos para testes rápidos'
  task seed_minimal: :environment do
    require 'faker'

    puts "Limpando dados existentes..."
    Order.delete_all
    Product.delete_all

    puts "Criando produtos..."
    categories = ['Eletrônicos', 'Roupas', 'Livros']

    products = []
    10.times do
      products << Product.create!(
        name: Faker::Commerce.product_name,
        sku: "SKU-#{Faker::Alphanumeric.alphanumeric(8).upcase}",
        price: Faker::Commerce.price(10.0..500.0),
        category: categories.sample,
        description: Faker::Lorem.paragraph(2),
        active: true
      )
    end
    puts "#{products.count} produtos criados!"

    puts "Criando pedidos..."
    statuses = Order::STATUSES

    500.times do |i|
      product = products.sample
      quantity = rand(1..5)

      Order.create!(
        product_id: product.id,
        customer_email: Faker::Internet.email,
        customer_name: Faker::Name.name,
        status: statuses.sample,
        quantity: quantity,
        total_amount: product.price * quantity,
        order_date: Faker::Date.between(3.months.ago, Date.today),
        shipping_address: Faker::Address.street_address,
        city: 'São Paulo',
        state: 'SP',
        zip_code: Faker::Address.zip_code,
        country: 'Brasil',
        notes: nil
      )
    end

    puts "\n=========================================="
    puts "Seed mínimo concluído!"
    puts "Total de produtos: #{Product.count}"
    puts "Total de pedidos: #{Order.count}"
    puts "=========================================="
  end
end
