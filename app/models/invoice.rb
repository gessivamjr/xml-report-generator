class Invoice < ApplicationRecord
  belongs_to :report
  has_one :issuer, dependent: :nullify
  has_one :recipient, dependent: :nullify
  has_many :products, dependent: :destroy

  validates :serie, :number, :emitted_at, presence: true

  def describe_values
    values_to_currency = total_values.transform_values do |value|
      ActiveSupport::NumberHelper.number_to_currency(value, unit: 'R$')
    end

    values_to_currency.transform_keys do |key|
      key.delete_prefix('v').prepend('Valor Total - ')
    end
  end
end
