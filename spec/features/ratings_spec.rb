require 'rails_helper'

BeerClub
BeerClubsController

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

describe "Ratings page" do
  it "shows no ratings if no ratings are made" do
    visit ratings_path

    expect(Rating.count).to eq(0)
    expect(page).to have_content 'Ratings'
    expect(page).to have_content 'Total number of ratings made: 0'
  end

  it "shows ratings if ratings are made" do
    user = create_user_with_ratings('Freddy', "iso 3")

    visit ratings_path

    expect(Rating.count).to eq(4)
    expect(page).to have_content 'Ratings'
    expect(page).to have_content 'Total number of ratings made: 4'

    user.ratings.each do |rating|
      expect(page).to have_content "#{rating.beer.name} #{rating.beer.brewery.name} #{rating.score} #{user.username}"
    end

  end
end
