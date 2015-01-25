module AverageRating
  extend ActiveSupport::Concern

  def average_rating
    scores = ratings.map { |rating| rating.score }
    1.0 * scores.inject { |sum, n| sum + n } / ratings.count
  end

end