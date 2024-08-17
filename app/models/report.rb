class Report < ApplicationRecord
  belongs_to :user
  has_many :invoices, dependent: :destroy

  validates :title, presence: true
  validates :status, inclusion: { in: %w(processing avaiable failed) }

  enum :status, { processing: "processing",
                  avaiable: "avaiable",
                  failed: "failed" }, prefix: true
end
