require 'rails_helper'

RSpec.describe Micropost, type: :model do

before do
  @user = User.create(name: "Test name",
                      email: "test@gmail.com",
                      password: "password")
end

describe "Validations" do
  it "is valid with :user_id and an appropriate content length" do
    micropsot = @user.microposts.new(content: "valid content")
    micropsot.valid?
    expect(micropsot).to be_valid
  end

  it "is invalid without :user_id" do
    micropost = Micropost.new(content: "without user_id")
    micropost.valid?
    expect(micropost).to_not be_valid
  end

  it "is invalid with a content length < 5 chars" do
    micropsot = @user.microposts.new(content: "1234")
    micropsot.valid?
    expect(micropsot.errors[:content]).to_not be_empty
  end

  it "is invalid with a content length > 300 chars" do
    micropsot = @user.microposts.new(content: "1"*301)
    micropsot.valid?
    expect(micropsot.errors[:content]).to_not be_empty
  end


end

end
