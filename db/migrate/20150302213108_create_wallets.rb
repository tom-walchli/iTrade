class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :currency
      t.float  :balance
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
