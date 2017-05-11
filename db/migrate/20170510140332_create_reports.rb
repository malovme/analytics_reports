class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.text :metrics
      t.text :dimensions

      t.timestamps
    end
  end
end
