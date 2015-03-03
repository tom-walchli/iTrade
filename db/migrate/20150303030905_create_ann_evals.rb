class CreateAnnEvals < ActiveRecord::Migration
  def change
    create_table :ann_evals do |t|
      t.text	:results
      t.timestamps null: false
    end
  end
end
