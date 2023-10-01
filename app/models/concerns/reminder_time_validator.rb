class ReminderTimeValidator < ActiveModel::Validator
  def validate(reminder)
    return if reminder.time.blank?
    if reminder.time < Time.now.utc
      reminder.errors.add(:time, "must be in future")
    end
  end
end
