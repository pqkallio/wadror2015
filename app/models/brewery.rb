class Brewery < ActiveRecord::Base
  include AverageRating

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers


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
