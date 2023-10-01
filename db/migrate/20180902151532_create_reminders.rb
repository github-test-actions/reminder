class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.string :title, null: false
      t.string :description
      t.datetime :time, null: false
      t.string :time_zone, null: false

      t.timestamps
    end
  end
end
