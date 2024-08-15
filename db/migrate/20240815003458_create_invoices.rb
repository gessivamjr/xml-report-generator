class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :invoices do |t|
      t.integer :serie
      t.bigint :number
      t.datetime :emitted_at
      t.decimal :total_icms, precision: 10, scale: 2
      t.decimal :total_ipi, precision: 10, scale: 2
      t.decimal :total_pis, precision: 10, scale: 2
      t.decimal :total_cofins, precision: 10, scale: 2
      t.hstore :total_values
      t.references :report
      t.timestamps
    end
  end
end
