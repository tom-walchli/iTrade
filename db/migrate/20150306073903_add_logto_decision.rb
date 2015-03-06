class AddLogtoDecision < ActiveRecord::Migration
  def change
  	add_column(:decisions, :log, :text)
  end
end
