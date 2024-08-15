class Invoice < ApplicationRecord
  belongs_to :report
  has_one :issuer
  has_one :recipient
  has_many :products
end

