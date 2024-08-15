class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :ncm
      t.string :cfop
      t.string :unity_commercialized
      t.integer :quantity_commercialized
      t.decimal :unity_value, precision: 10, scale: 2
      t.references :invoice
      t.timestamps
    end
  end
end
