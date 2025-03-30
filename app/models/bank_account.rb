class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  
  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, presence: true, numericality: true
  validates :currency, presence: true
  
  ACCOUNT_TYPES = %w[checking savings credit investment].freeze
  validates :account_type, inclusion: { in: ACCOUNT_TYPES }
end
