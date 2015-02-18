class Brewery < ActiveRecord::Base
  include AverageRating

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validate :year_must_be_between_1042_and_present_year
  validates :year, numericality: { only_integer: true }
  validates :name, presence: true

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil, false] }

  def year_must_be_between_1042_and_present_year
    if year < 1042 || year > Time.now.year
      errors.add(:year, "must be between 1042 and the present year")
    end
  end

  def print_report
    puts name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

end
