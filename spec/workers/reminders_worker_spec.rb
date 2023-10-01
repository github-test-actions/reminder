require 'rails_helper'

RSpec.describe RemindersWorker do
  let!(:user) { create :user }
  it { is_expected.to be_processed_in :high_priority }
  it { is_expected.to be_retryable false }

  it 'enqueues schduled job' do
    reminder = FactoryBot.create(:reminder, :future_time, user: user )
    RemindersWorker.perform_at(5.minutes.from_now, reminder.id)
    expect(RemindersWorker).to have_enqueued_sidekiq_job(reminder.id)
  end

  context "enqueue job" do
    let!(:reminder) { create :reminder, :future_time, user: user }
    it "should enqueue a job" do
      RemindersWorker.perform_async(reminder.id)
      expect(RemindersWorker).to have_enqueued_sidekiq_job(reminder.id)
    end
  end
end
