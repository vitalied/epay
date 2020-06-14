class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, limit: 255, null: false, index: { unique: true }
      t.text :description
      t.string :email, limit: 255, null: false, index: { unique: true }
      t.string :status, limit: 10, null: false, index: true
      t.decimal :total_transaction_sum, precision: 12, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end
