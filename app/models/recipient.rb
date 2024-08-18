class Recipient < ApplicationRecord
  belongs_to :invoice

  validates :cnpj, :name, presence: true

  def friendly_address
    "#{address_street}, #{address_number}, #{address_complement}, " \
    "#{neighborhood}, #{city}, #{state}, #{country}"
  end
end

