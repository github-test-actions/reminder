require 'rails_helper'

RSpec.describe Reminder, type: :model do
  let!(:user) { create :user }
  subject { create :reminder, :future_time, user: user }

  context "validation" do
     it { should validate_presence_of(:title) }
     it { should validate_presence_of(:time) }
     it { should respond_to :time_zone }

     it "validate with attibutes" do
       expect(subject).to be_valid
     end

     it "title with nill" do
      subject.title = nil
      expect(subject).not_to be_valid
    end

    it "Invalid reminder time" do
      subject.time =  Time.now.yesterday
      expect(subject).not_to be_valid
    end
  end

  context "Test Association" do
    it {should  belong_to :user }
  end
end
