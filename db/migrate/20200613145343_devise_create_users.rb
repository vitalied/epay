# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email, null: false, default: '', index: { unique: true }
      t.string :encrypted_password, null: false, default: ''

      ## Token authenticatable
      t.string :authentication_token, null: false, default: '', index: { unique: true }

      t.boolean :admin, null: false, default: false

      t.timestamps null: false
    end
  end
end
