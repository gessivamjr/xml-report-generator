class Product < ApplicationRecord
  belongs_to :invoice

  validates :name, :ncm, :cfop, :value,
            :unity_commercialized, :quantity_commercialized,
            :taxed_unity, :taxed_unity_value, presence: true
end
