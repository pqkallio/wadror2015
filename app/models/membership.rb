class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :beer_club, presence: true
  validates :user, uniqueness: { scope: :beer_club,
                                 message: "only one membership per club per person" }
end
