class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :beer_club, presence: true
  validates :user, uniqueness: { scope: :beer_club,
                                 message: "only one membership per club per person" }

  scope :confirmed, -> { where confirmed:true }
  scope :unconfirmed, -> { where confirmed:[nil, false] }

  def self.get_applications_of(beer_club)
    Membership.unconfirmed.find_by(beer_club: beer_club)
  end
end
