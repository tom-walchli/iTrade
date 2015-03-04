class AddResultsToAnnEval < ActiveRecord::Migration
  def change
  	add_column(:ann_evals,:buy,:boolean)
  	add_column(:ann_evals,:buy_confidence,:float)
  	add_column(:ann_evals,:sell,:boolean)
  	add_column(:ann_evals,:sell_confidence,:float)
  end
end
