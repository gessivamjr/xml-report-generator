class Issuer < ApplicationRecord
  belongs_to :invoice

  validates :cnpj, :name, presence: true

  def friendly_phone
    return nil if phone_number.blank?

    phone = phone_number.remove('-()')
    "(#{phone[0..1]}) #{phone[2]} #{phone[3..6]}-#{phone[7..]}"
  end

  def friendly_address
    "#{address_street}, #{address_number}, #{address_complement}, " \
    "#{neighborhood}, #{city}, #{state}, #{country}"
  end
end

