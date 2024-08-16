class Report < ApplicationRecord
  belongs_to :user
  has_many :invoices

  validates :title, presence: true

  enum :status, { processing: "processing", avaiable: "avaiable", failed: "failed" }, prefix: true
end
