require 'spec_helper'

def login_via_form(email, password)
  expect(page).to have_current_path "/users/sign_in"
  fill_in "user_email", with: email
  fill_in "user_password", with: password
  click_on "Log in"
end

RSpec.describe "Signing Up", :type => :feature do
  let(:valid_attributes) { attributes_for(:user)}

  it "allows a user to sign up" do
     visit "users/sign_up"
     expect(page).to have_content "Sign up"
     within("form#new_user") do
       fill_in "user_email", with: valid_attributes[:email]
       fill_in "user_password", with: valid_attributes[:password]
       fill_in "user_password_confirmation", with: valid_attributes[:password_confirmation]
     end

     expect { click_button "Sign up" }.to change { ActionMailer::Base.deliveries.size }.by(1)
     expect(page).to have_content "Log in"
     expect(page).to have_current_path "/users/sign_in"
     open_email(valid_attributes[:email])
     expect(current_email.subject).to eq "Confirmation instructions"
     current_email.click_link "Confirm my account"

     expect(page).to have_content "Your email address has been successfully " \
                                 "confirmed."

     login_via_form(valid_attributes[:email],
                   valid_attributes[:password])
     expect(page).to have_content "Signed in successfully."
     expect(page).to  have_content valid_attributes[:email]
   end

   it "unique email" do
     create(:user, email: 'test@test.de')
     visit "users/sign_up"
     within("form#new_user") do
       fill_in "user_email", with: 'test@test.de'
       fill_in "user_password", with: "password"
       fill_in "user_password_confirmation", with: "password"
     end
     click_on 'Sign up'
     expect(page).to have_content "Email has already been taken"
   end
end
