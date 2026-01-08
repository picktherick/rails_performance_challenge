class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :product_id
      t.string :customer_email
      t.string :customer_name
      t.string :status
      t.decimal :total_amount, precision: 10, scale: 2
      t.integer :quantity
      t.date :order_date
      t.string :shipping_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.text :notes

      t.timestamps null: false
    end

    # NOTA: Propositalmente SEM índices para o desafio de performance
  end
end
