class MoreFeaturesToWallets < ActiveRecord::Migration
  def change
  	add_column(:wallets, :on_hold, :float)
  end
end
