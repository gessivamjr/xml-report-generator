class Invoice < ApplicationRecord
  belongs_to :report
  has_one :issuer
  has_one :recipient
  has_many :products

  def describe_values
    total_values.transform_values(&:to_f).transform_keys do |key|
      key.delete_prefix('v').prepend('Valor - ')
    end
  end
end
