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
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, 24, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let!(:user) { FactoryGirl.create(:user) }

    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated beer's style if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with the highest average rating" do
      lager = FactoryGirl.create(:style, name: "Lager")
      ale = FactoryGirl.create(:style, name: "Ale")
      ipa = FactoryGirl.create(:style, name: "IPA")

      create_beers_with_style_and_ratings(5, 9, 10, 12, lager, user)
      create_beers_with_style_and_ratings(9, 10, 12, 18, ale, user)
      create_beers_with_style_and_ratings(10, 12, 18, 30, ipa, user)

      expect(user.favorite_style).to eq(ipa)
    end
  end

  describe "favorite brewery" do
    let!(:user) { FactoryGirl.create(:user) }

    it "has method for determining the favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated beer's brewery if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the brewery with the highest average rating" do
      koff = FactoryGirl.create(:brewery, name: "Koff")
      hartwall = FactoryGirl.create(:brewery, name: "Hartwall")
      brewdog = FactoryGirl.create(:brewery, name: "BrewDog")

      create_beers_with_brewery_and_ratings(5, 9, 10, 12, koff, user)
      create_beers_with_brewery_and_ratings(9, 10, 12, 18, hartwall, user)
      create_beers_with_brewery_and_ratings(10, 12, 18, 30, brewdog, user)

      expect(user.favorite_brewery).to eq(brewdog)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
end
  end
end

def create_beer_with_style_and_rating(score, style, user)
  beer = FactoryGirl.create(:beer, style: style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_style_and_ratings(*scores, style, user)
  scores.each do |score|
    create_beer_with_style_and_rating(score, style, user)
  end
end

def create_beer_with_brewery_and_rating(score, brewery, user)
  beer = FactoryGirl.create(:beer, brewery: brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_brewery_and_ratings(*scores, brewery, user)
  scores.each do |score|
    create_beer_with_brewery_and_rating(score, brewery, user)
  end
end
