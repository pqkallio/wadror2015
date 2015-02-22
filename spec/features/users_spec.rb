require 'rails_helper'

describe "User" do
  before :each do
    @user = FactoryGirl.create(:user)
    @lager = FactoryGirl.create(:style)
    @ipa = FactoryGirl.create(:style, name: "IPA")
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "page contains only the user's ratings" do
      freddy = create_user_with_ratings("Freddy", "iso 3")
      bob = create_user_with_ratings("Bob", "karhu")
      visit user_path(freddy)

      expect(page).to have_content "has made #{freddy.ratings.count} ratings"

      freddy.ratings.each do |rating|
        expect(page).to have_content "#{rating.beer.name} #{rating.score}"
      end

      bob.ratings.each do |rating|
        expect(page).not_to have_content "#{rating.beer.name} #{rating.score}"
      end
    end

    it "can delete selfmade rating" do
      @user.ratings << FactoryGirl.create(:rating3)
      sign_in(username:"Pekka", password:"Foobar1")

      expect(@user.ratings.count).to eq(1)
      visit user_path(@user)

      click_link('delete')

      expect(@user.ratings.count).to eq(0)
    end

    it "has its favorite style on the page" do
      create_breweries_styles_beers_and_ratings_for_user

      visit user_path(@user)
      expect(@user.favorite_style).to eq(@ipa)
      expect(page).to have_content "favorite style: IPA"
    end

    it "has its favorite brewery on the page" do
      create_breweries_styles_beers_and_ratings_for_user

      visit user_path(@user)
      expect(@user.favorite_brewery).to eq(@brewdog)
      expect(page).to have_content "favorite brewery: BrewDog"
    end
  end
end

def create_breweries_styles_beers_and_ratings_for_user
  @brewdog = FactoryGirl.create(:brewery, name:"BrewDog", year:"2011")
  @koff = FactoryGirl.create(:brewery, name:"Koff", year:"1897")

  @punk_ipa = FactoryGirl.create(:beer, name:"Punk IPA", style:@ipa, brewery:@brewdog)
  @iso3 = FactoryGirl.create(:beer, name:"Iso 3", style:@lager, brewery:@koff)

  @user.ratings << FactoryGirl.create(:rating, score:30, beer:@iso3)
  @user.ratings << FactoryGirl.create(:rating, score:40, beer:@punk_ipa)
  @user.ratings << FactoryGirl.create(:rating, score:10, beer:@iso3)
end
