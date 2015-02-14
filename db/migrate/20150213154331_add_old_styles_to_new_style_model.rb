class AddOldStylesToNewStyleModel < ActiveRecord::Migration
  def change
    uniq_style_names = Array.new

    Beer.all.each do |b|
      uniq_style_names << b.style unless uniq_style_names.include? b.style
    end

    uniq_style_names.each do |s|
      Style.create name: s, description: "Tasty!"
    end
  end
end
