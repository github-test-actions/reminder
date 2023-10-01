class Reminder < ApplicationRecord
  belongs_to :user, inverse_of: :reminders
  validates :title, :time, :time_zone, presence: true
  validates_with ReminderTimeValidator
  scope :passed_reminers, ->() { where("time < ?", Time.now.utc) }

  after_create :add_sidekiq_job
  before_destroy :remove_sidekiq_job

  def add_sidekiq_job
    job_id  = RemindersWorker.perform_at(scheduled_at, id)
    update_attributes(jobid: job_id)
  end

  def remove_sidekiq_job
    Sidekiq::Status.cancel jobid if jobid.present?
  end

  def update_sidekiq_job
    Sidekiq::Status.cancel jobid if jobid.present?
    job_id  = RemindersWorker.perform_at(scheduled_at, id)
    update_attributes(jobid: job_id )
  end

  private

  def scheduled_at
    time.to_i
  end
end
