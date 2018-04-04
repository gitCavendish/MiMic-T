require 'rails_helper'

RSpec.describe Camp, type: :model do

  describe "validations" do
    columns = [:title, :intro, :venue, :time]
    params = {title: "camp title", intro: "camp intro", venue: "camp venue", time: Time.now}
    before do
      @user = User.create(
        name: "Test name",
        email: "test@gmail.com",
        password: "password"
      )
    end

    it "is invalid without one of :title, :intro, :venue, :time" do
      columns.each do |column|
        params[column] = nil
        camp = @user.camps.new(params)
        camp.valid?
        expect(camp.errors[column]).to_not be_empty
      end
    end
  end

end
