class Beer < ActiveRecord::Base
  include AverageRating

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average
    return 0 if ratings.empty?
    ratings.map{ |r| r.score }.sum / ratings.count.to_f
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
