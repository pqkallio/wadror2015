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
    unless password.match(/[A-Z]/) && password.match(/[[:digit:]]/) && password.length > 3
      errors.add(:password, "The password needs to contain at least one digit and one capital letter, and the minimum password length is four characters.")
    end
  end

end
