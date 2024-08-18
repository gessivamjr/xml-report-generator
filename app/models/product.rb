class Product < ApplicationRecord
  belongs_to :invoice

  validates :name, :ncm, :cfop, :value,
            :unity_commercialized, :quantity_commercialized,
            :taxed_unity, :taxed_unity_value, presence: true

  def values_to_currency
    {
      unity_value: ActiveSupport::NumberHelper.number_to_currency(unity_value, unit: 'R$'),
      value: ActiveSupport::NumberHelper.number_to_currency(value, unit: 'R$'),
    }.freeze
  end
end
