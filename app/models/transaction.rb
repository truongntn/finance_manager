class Transaction < ApplicationRecord
  belongs_to :bank_account
  
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true
  validates :category, presence: true
  validates :date, presence: true
  
  TRANSACTION_TYPES = %w[income expense].freeze
  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES }
  
  before_save :update_bank_account_balance
  
  private
  
  def update_bank_account_balance
    if transaction_type == 'income'
      bank_account.balance += amount
    else
      bank_account.balance -= amount
    end
    bank_account.save
  end
end
