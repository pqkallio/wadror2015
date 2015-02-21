class Beer < ActiveRecord::Base
  include AverageRating

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user
  belongs_to :style

  validates :name, presence: true
  validates :style_id, presence: true

  def self.top_rated(n)
    sorted_by_rating_in_desc_ord = Beer.all.sort_by { |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_ord[0..n-1]
  end

  def average
    return 0 if ratings.empty?
    ratings.map{ |r| r.score }.sum / ratings.count.to_f
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
