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
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite(category)
    return nil if ratings.empty?

    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end

    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

end