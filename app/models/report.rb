class Report < ApplicationRecord
  belongs_to :user
  has_many :invoices
end
