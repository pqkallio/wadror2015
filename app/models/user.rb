class User < ActiveRecord::Base
  include AverageRating

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..15 }
  validate :password_validation

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  def password_validation
    if not password.nil?
      unless password.match(/[A-Z]/) && password.match(/[[:digit:]]/) && password.length > 3
        errors.add(:password, "The password needs to contain at least one digit and one capital letter, and the minimum password length is four characters.")
      end
    end
  end

  def self.top_raters(n)
    sorted_by_number_of_ratings_made_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
    sorted_by_number_of_ratings_made_in_desc_order[0..n-1]
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    get_highest_rating_style.name
  end

  def favorite_brewery
    return nil if ratings.empty?
    get_highest_rating_brewery.name
  end

  def get_highest_rating_style
    style_based_ratings = get_style_based_ratings
    get_style_averages(style_based_ratings).max_by{ |k, v| v }[0]
  end

  def get_highest_rating_brewery
    brewery_based_ratings = get_brewery_based_ratings
    get_brewery_with_highest_average(brewery_based_ratings)
  end

  def get_style_based_ratings
    style_based_ratings = create_style_hash

    ratings.each do |rating|
      style_based_ratings[rating.beer.style] << rating.score
    end

    style_based_ratings
  end

  def get_brewery_based_ratings
    brewery_based_ratings = create_brewery_hash

    ratings.each do |rating|
      brewery_based_ratings[rating.beer.brewery] << rating.score
    end

    brewery_based_ratings
  end

  def create_style_hash
    style_hash = Hash.new

    ratings.each do |rating|
      style_hash[rating.beer.style] = Array.new
    end

    style_hash
  end

  def create_brewery_hash
    brewery_hash = Hash.new

    ratings.each do |rating|
      brewery_hash[rating.beer.brewery] = Array.new
    end

    brewery_hash
  end

  def get_style_averages(style_based_ratings)
    style_averages = Hash.new

    style_based_ratings.each do |key, value|
      style_averages[key] = 1.0 * value.inject { |sum, n| sum + n } / value.count
    end

    style_averages
  end

  def get_brewery_with_highest_average(brewery_based_ratings)
    brewery_averages = Hash.new

    brewery_based_ratings.each do |key, value|
      brewery_averages[key] = 1.0 * value.inject { |sum, n| sum + n } / value.count
    end

    highest_average = 0.0
    brewery_with_highest_average = nil

    brewery_averages.each do |key, value|
      if value > highest_average
        highest_average = value
        brewery_with_highest_average = key
      end
    end

    brewery_with_highest_average
  end
end
