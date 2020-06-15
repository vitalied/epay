class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :type, limit: 20, null: false, index: true
      t.belongs_to :merchant, null: false, foreign_key: true
      t.string :reference_uuid, limit: 50
      t.string :uuid, limit: 50, null: false, index: { unique: true }
      t.decimal :amount, precision: 12, scale: 2
      t.string :status, limit: 20, null: false, index: true
      t.string :customer_email, limit: 255, null: false
      t.string :customer_phone

      t.timestamps
    end

    add_foreign_key :transactions, :transactions, column: :reference_uuid, primary_key: :uuid, name: :index_transactions_on_reference_uuid
  end
end
