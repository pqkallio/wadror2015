require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [ Place.new( name:"Oljenkorsi", id: 1 ) ]
                             )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if two is returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("riihimäki").and_return(
                                 [ Place.new( name:"Irlanninsetteri", id: 1 ),
                                   Place.new( name:"Parnell's", id: 2 ) ])


    visit places_path
    fill_in('city', with: 'riihimäki')
    click_button "Search"

    expect(page).to have_content "Irlanninsetteri"
    expect(page).to have_content "Parnell's"
  end

  it "if none is returned by the API, a notice is displayed" do
    allow(BeermappingApi).to receive(:places_in).with("san francisco").and_return(
                                 [])


    visit places_path
    fill_in('city', with: 'san francisco')
    click_button "Search"

    expect(page).to have_content "No locations in san francisco"
  end
end