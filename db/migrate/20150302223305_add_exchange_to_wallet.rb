class AddExchangeToWallet < ActiveRecord::Migration
  def change
  	  	add_column(:wallets,:exchange,:string)
  end
end
