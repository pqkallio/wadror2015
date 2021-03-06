require 'rails_helper'

describe "Beer" do
  before :each do
    FactoryGirl.create(:brewery)
    FactoryGirl.create(:user)
    FactoryGirl.create(:style)
  end

  it "can be created if name field is not empty" do
    sign_in(username:"Pekka", password:"Foobar1")
    save_and_open_page
    create_new_beer('Orkku')

    expect(current_path).to eq(beers_path)
    save_and_open_page
    expect(page).to have_content 'Beer was successfully created.'
    expect(page).to have_content 'Orkku'
    expect(Beer.count).to eq(1)
  end

  it "can't be created if name field is not empty" do
    sign_in(username:"Pekka", password:"Foobar1")
    create_new_beer('')

    expect(page).to have_content 'New Beer'
    expect(page).to have_content 'error'
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end

def create_new_beer(name)
  visit new_beer_path
  fill_in('beer_name', with:name)
  click_button('Create Beer')
end