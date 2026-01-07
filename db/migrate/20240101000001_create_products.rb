class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.decimal :price, precision: 10, scale: 2
      t.string :category
      t.text :description
      t.boolean :active, default: true

      t.timestamps null: false
    end

    # NOTA: Propositalmente SEM índices para o desafio de performance
  end
end
