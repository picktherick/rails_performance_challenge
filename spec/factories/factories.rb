FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:sku) { |n| "SKU-#{n.to_s.rjust(8, '0')}" }
    price { rand(10.0..500.0).round(2) }
    category { ['Eletrônicos', 'Roupas', 'Livros', 'Casa & Jardim', 'Esportes'].sample }
    description { "Description for product" }
    active { true }
  end

  factory :order do
    association :product
    sequence(:customer_email) { |n| "customer#{n}@example.com" }
    sequence(:customer_name) { |n| "Customer #{n}" }
    status { Order::STATUSES.sample }
    quantity { rand(1..10) }
    total_amount { product.price * quantity }
    order_date { Date.today - rand(0..365).days }
    shipping_address { "Rua Example, 123" }
    city { "São Paulo" }
    state { "SP" }
    zip_code { "01234-567" }
    country { "Brasil" }
    notes { nil }
  end
end
