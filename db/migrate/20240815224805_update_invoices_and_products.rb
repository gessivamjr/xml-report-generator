class UpdateInvoicesAndProducts < ActiveRecord::Migration[7.2]
  def change
    change_table :invoices, bulk: true do
      remove_column :invoices, :total_icms, :decimal
      remove_column :invoices, :total_ipi, :decimal
      remove_column :invoices, :total_pis, :decimal
      remove_column :invoices, :total_cofins, :decimal
    end

    change_table :products, bulk: true do
      add_column :products, :value, :decimal, precision: 10, scale: 2
      add_column :products, :taxed_unity, :string
      add_column :products, :taxed_unity_value, :decimal, precision: 10, scale: 2
      add_column :products, :quantity_taxed, :integer
    end
  end
end
