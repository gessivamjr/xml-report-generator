class Issuer < ApplicationRecord
  belongs_to :invoice

  validates :cnpj, :name, presence: true
end

