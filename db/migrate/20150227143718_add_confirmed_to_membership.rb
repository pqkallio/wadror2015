class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean

    Membership.all.each do |ms|
      ms.confirmed = true
      ms.save
    end
  end
end
