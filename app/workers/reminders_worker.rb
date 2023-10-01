class RemindersWorker < AddSidekiq
  sidekiq_options queue: 'high_priority'

  def perform(id)
    reminder = Reminder.find(id)
    ReminderMailer.with(reminder: reminder).reminder_email.deliver_later
  end
end
