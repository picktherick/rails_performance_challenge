class Product < ActiveRecord::Base
  has_many :orders

  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
  scope :by_category, ->(category) { where(category: category) }

  # Método propositalmente ineficiente para cálculo
  def self.total_revenue
    total = 0
    Order.all.each do |order|
      total += order.total_amount.to_f
    end
    total
  end

  # Método propositalmente ineficiente
  def self.products_with_orders_count
    result = []
    Product.all.each do |product|
      result << {
        product: product,
        orders_count: Order.where(product_id: product.id).count
      }
    end
    result
  end
end
