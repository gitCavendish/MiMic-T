require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do

    context "valid user" do
      it "is valid with name, email, and password" do
        user = User.new(
          name: "Test name",
          email: "Test@gmail.com",
          password: "password"
        )
        user.valid?
        expect(user).to be_valid
      end
    end

    context "absence of specific column" do
      it "is invalid without name" do
        user = User.new(
          name: "",
          email: "Test@gmail.com",
          password: "password"
        )
        user.valid?
        expect(user.errors[:name]).to include("can't be blank")
      end

      it "is invalid without email" do
        user = User.new(
          name: "Test name",
          email: "",
          password: "password"
        )
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "is invalid without password" do
        user = User.new(
          name: "Test name",
          email: "Test@gmail.com",
          password: ""
        )
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end
    end

    context "email format checking" do
      it "is invalid with a wrong formatted email" do
        user = User.new(
          name: "Test name",
          email: "wrong_email.com",
          password: "password"
        )
        user.valid?
        expect(user.errors[:email]).to_not be_empty
      end
    end

    context "length checking" do
      it "is invalid with a name that > 50 chars" do
        user = User.new(
          name: "n" * 51,
          email: "wrong_email.com",
          password: "password"
        )
        user.valid?
        expect(user.errors[:name]).to_not be_empty
      end

      it "is invalid with a email that > 255 chars" do
        user = User.new(
          name: "Test name",
          email: ("a1234@" + "a"*246 + ".com"),
          password: "password"
        )
        user.valid?
        expect(user.errors[:email]).to_not be_empty
      end

      it "is invalid with a password that < 6 chars" do
        user = User.new(
          name: "Test name",
          email: "example@gmail.com",
          password: "12345"
        )
        user.valid?
        expect(user.errors[:password]).to_not be_empty
      end

    end
  end # end validations

end
