require 'rails_helper'

RSpec.describe "Sessions" do

  it "signs user in and out" do
    user = User.create!(email: "user@example.org", password: "very-secret")
    user.confirm

    sign_in user
    get root_path
    expect(controller.current_user).to eq(user)

    sign_out user
    get root_path
    expect(response).to redirect_to "/users/sign_in"
  end

end
