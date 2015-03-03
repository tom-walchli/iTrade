class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string 	:f_currency
      t.string 	:t_currency
      t.string	:type
      t.float	:amount
      t.float	:price
      t.float	:fee
      t.string	:status
      t.string	:foreign_id

      t.integer :user_id
      t.timestamps null: false
    end
  end
end
