json.array!(@breweries) do |brewery|
  json.extract! brewery, :name, :year
  json.beercount brewery.beers.count
end
