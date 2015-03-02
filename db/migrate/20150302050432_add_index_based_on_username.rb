class AddIndexBasedOnUsername < ActiveRecord::Migration
  def change
    add_index :users, :username
  end
end
