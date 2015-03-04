class MoreFeaturesToTrades < ActiveRecord::Migration
  def change
  	add_column(:trades, :amount_available, :float)
  	add_column(:trades, :ann_eval_id, :integer)
  end
end
