class AddNewStyleIdsToBeers < ActiveRecord::Migration
  def change
    Beer.all.each do |b|
      b.update(style_id: 1)
    end
  end
end
