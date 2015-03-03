class AddExchangeToTrade < ActiveRecord::Migration
  def change
 	add_column(:trades,:exchange,:string)
  end
end
