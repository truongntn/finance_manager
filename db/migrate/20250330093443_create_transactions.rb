class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.decimal :amount
      t.string :transaction_type
      t.string :category
      t.text :description
      t.datetime :date

      t.timestamps
    end
  end
end
