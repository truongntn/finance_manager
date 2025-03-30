class CreateBankAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :account_type
      t.decimal :balance
      t.string :currency

      t.timestamps
    end
  end
end
