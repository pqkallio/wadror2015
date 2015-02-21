class Style < ActiveRecord::Base
  include AverageRating

  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true

  def self.top_rated(n)
    sorted_by_rating_in_desc_ord = Style.all.sort_by { |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_ord[0..n-1]
  end

end
