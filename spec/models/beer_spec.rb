require 'rails_helper'

describe Beer do
  it "is created and saved to the database if it has a name and a style" do
    beer = Beer.create name:"Shaiba", style_id:1

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "isn't valid if it hasn't got a name" do
    beer = Beer.create style_id:1

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "isn't valid if it hasn't got a style" do
    beer = Beer.create name:"Shibaabaa"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
