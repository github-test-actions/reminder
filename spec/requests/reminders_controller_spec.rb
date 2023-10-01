require 'rails_helper'

RSpec.describe RemindersController, type: :request do

  let!(:user) { create :user }
  let!(:reminder) { create :reminder, :future_time, title: "test_title", user: user }

  context "reminder schema_path" do
    before(:each) do
      sign_in user
    end

    it "should valid schema" do
      get "/reminders"
      expect(response).to match_response_reminder_schema 'reminder'
    end
  end

  context "Authorization with valid user" do
    before(:each) do
      sign_in user
    end

    it "should create a reminder" do
      post reminders_path(reminder: { title: 'reminder1', description: 'discription', time: 10.minutes.from_now, time_zone: 'UTC' }, format: :json)
      response.should be_success
      expect(json[:title]).to eq("reminder1")
    end

    it "should read own remider list" do
      get reminders_path(format: :json)
      response.should be_success
      expect(json[0]["title"]).to eq("test_title")
    end

    it "should update own reminder" do
      put reminder_path(reminder.id, reminder: { title: 'reminder1' }, format: :json)
      response.should be_success
      expect(response).to have_http_status(204)
    end

    it "should delete own reminder" do
      expect{
          delete reminder_path(reminder.id, format: :json)
        }.to change(Reminder, :count).by(-1)
    end
  end

  context "Unauthorization access with another user" do
    let!(:another_user) { create :user, email: "test@test.de" }

    before(:each) do
      sign_in another_user
    end

    it "Should not able to read rimnder of user" do
      get reminder_path(reminder.id)
      expect(response).to have_http_status(302)
    end
  end
end
