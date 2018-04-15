require 'rails_helper'

RSpec.describe Relationship, type: :model do

  before do
    @user1 = User.create(name: "user1",
                         email: "user1@example.com",
                         password: "password")
    @user2 = User.create(name: "user2",
                         email: "user2@example.com",
                         password: "passwor")
  end

  describe "Validations" do
    it "is valid with :follower_id and :followed_id" do
      relationship = Relationship.create(follower_id: @user1.id, followed_id: @user2.id)
      relationship.valid?
      expect(relationship).to be_valid
    end

    it "is invalid that :follower_id and :followed_id are the same" do
      relationship = Relationship.create(follower_id: @user1.id, followed_id: @user1.id)
      relationship.valid?
      expect(relationship.errors[:self_refer]).to_not be_empty
    end

    it "is invalid without :follower_id in this join table" do
      relationship = Relationship.create(follower_id: @user1.id)
      relationship.valid?
      expect(relationship).to_not be_valid
    end

    it "is invalid without :follower_id in this join table" do
      relationship = Relationship.create(followed_id: @user1.id)
      relationship.valid?
      expect(relationship).to_not be_valid
    end
  end

end
