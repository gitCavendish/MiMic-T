require 'rails_helper'

RSpec.describe Comment, type: :model do

  before do
    @user = User.create(name: "Test name",
                        email: "test@gmail.com",
                        password: "password")
    @micropsot = @user.microposts.create(content: "Fake sentence")
  end


  describe "Validations" do
    it "is valid with a message has an appropriate length" do
      @comment = @micropsot.comments.new(
        message: "Fake message",
        user: @user
      )
      @comment.valid?
      expect(@comment).to be_valid
    end

    it "is invalid without a message " do
      @comment = @micropsot.comments.new(
        message: "",
        user: @user
      )
      @comment.valid?
      expect(@comment.errors[:message]).to_not be_empty
    end

    it "is invalid with a message has a length < 5 char" do
      @comment = @micropsot.comments.new(
        message: "Fake",
        user: @user
      )
      @comment.valid?
      expect(@comment).to_not be_valid
    end

    it "is invalid with a message has a length > 100 char" do
      @comment = @micropsot.comments.new(
        message: "n" * 101,
        user: @user
      )
      @comment.valid?
      expect(@comment).to_not be_valid
    end
  end


end
