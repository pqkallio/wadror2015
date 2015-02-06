require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that's too short" do
    user = User.create username: "Pekka", password:"S3c", password_confirmation:"S3c"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that contains only letters" do
    user = User.create username: "Pekka", password:"AbCdEfG", password_confirmation:"AbCdEfG"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let!(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << [FactoryGirl.create(:rating), FactoryGirl.create(:rating2)]

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let!(:user) { FactoryGirl.create(:user) }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer)
      beer3 = FactoryGirl.create(:beer)
      rating1 = FactoryGirl.create(:rating, beer:beer1, user:user)
      rating2 = FactoryGirl.create(:rating, score:25,  beer:beer2, user:user)
      rating3 = FactoryGirl.create(:rating, score:9, beer:beer3, user:user)

      expect(user.favorite_beer).to eq(beer2)
    end
  end
end
