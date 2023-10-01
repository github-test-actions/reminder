class AddUserToReminders < ActiveRecord::Migration[5.2]
  def change
    add_reference :reminders, :user, foreign_key: true
  end
end
