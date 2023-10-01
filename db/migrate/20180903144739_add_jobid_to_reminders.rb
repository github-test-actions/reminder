class AddJobidToReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :reminders, :jobid, :string
  end
end
