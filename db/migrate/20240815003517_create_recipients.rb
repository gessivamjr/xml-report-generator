class CreateRecipients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipients do |t|
      t.string :cnpj
      t.string :name
      t.string :fantasy_name
      t.string :neighborhood
      t.string :address_street
      t.integer :address_number
      t.string :address_complement
      t.string :city_code
      t.string :city
      t.string :country_code
      t.string :country
      t.string :postal_code
      t.string :state
      t.string :phone_number
      t.references :invoice
      t.timestamps
    end
  end
end
