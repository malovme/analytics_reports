class CreateMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
