class SetAccountEnabledTrueForUser < ActiveRecord::Migration
  def change
    User.all.each do |u|
      u.update_attribute(:account_enabled, true)
      u.save
    end
  end
end
