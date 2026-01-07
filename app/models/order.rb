class Order < ActiveRecord::Base
  belongs_to :product

  validates :customer_email, presence: true
  validates :customer_name, presence: true
  validates :status, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true

  STATUSES = %w[pending processing shipped delivered cancelled].freeze

  scope :pending, -> { where(status: 'pending') }
  scope :processing, -> { where(status: 'processing') }
  scope :shipped, -> { where(status: 'shipped') }
  scope :delivered, -> { where(status: 'delivered') }
  scope :cancelled, -> { where(status: 'cancelled') }

  # PROBLEMA: Este método causa N+1 queries
  # Para cada order, faz uma query para buscar o product
  def self.generate_report
    orders = Order.all
    report = []

    orders.each do |order|
      report << {
        order_id: order.id,
        customer_name: order.customer_name,
        customer_email: order.customer_email,
        product_name: order.product.name,        # N+1 aqui!
        product_sku: order.product.sku,          # N+1 aqui!
        product_category: order.product.category, # N+1 aqui!
        quantity: order.quantity,
        total_amount: order.total_amount,
        status: order.status,
        order_date: order.order_date
      }
    end

    report
  end

  # PROBLEMA: Múltiplas queries desnecessárias
  def self.orders_summary_by_status
    summary = {}

    STATUSES.each do |status|
      orders = Order.where(status: status)
      summary[status] = {
        count: orders.count,                    # Query para cada status
        total_revenue: orders.sum(:total_amount), # Outra query para cada status
        avg_order_value: orders.average(:total_amount) # Mais uma query
      }
    end

    summary
  end

  # PROBLEMA: Query sem limit/pagination em dataset grande
  def self.search_by_customer(email)
    Order.where("customer_email LIKE ?", "%#{email}%")
  end

  # PROBLEMA: Busca ineficiente - deveria usar índice
  def self.find_by_date_range(start_date, end_date)
    Order.where("order_date >= ? AND order_date <= ?", start_date, end_date)
  end

  # PROBLEMA: Cálculo ineficiente que poderia ser feito no banco
  def self.calculate_daily_revenue(date)
    orders = Order.where(order_date: date)
    total = 0
    orders.each do |order|
      total += order.total_amount.to_f
    end
    total
  end

  # PROBLEMA: Carrega todos os registros para contar
  def self.count_orders_by_city
    result = {}
    Order.all.each do |order|
      city = order.city
      result[city] ||= 0
      result[city] += 1
    end
    result
  end
end
