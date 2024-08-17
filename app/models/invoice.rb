class Invoice < ApplicationRecord
  belongs_to :report
  has_one :issuer, dependent: :nullify
  has_one :recipient, dependent: :nullify
  has_many :products, dependent: :destroy

  validates :serie, :number, :emitted_at, presence: true
  validates :number, uniqueness: true

  def describe_values
    total_values.transform_values(&:to_f).transform_keys do |key|
      key.delete_prefix('v').prepend('Valor - ')
    end
  end
end
