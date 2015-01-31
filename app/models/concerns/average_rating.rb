module AverageRating
  extend ActiveSupport::Concern

  def average_rating
    return 0.0 if ratings.empty?
    scores = ratings.map { |rating| rating.score }
    1.0 * scores.inject { |sum, n| sum + n } / ratings.count
  end

end