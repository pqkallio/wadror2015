class RatingsController < ApplicationController
  def index
    # Reittaussivun latautumista on nopeutettu cachella, joka vanhenee
    # 10 minuutissa. Tämä ei kuitenkaan ole suuren massan kanssa riittävä,
    # vaan sen sijaan cache tulisi suorittaa taustalla asynkronisesti.
    # Vaihtoehtona olisi tallettaa ainakin oluiden reittausten keskiarvot
    # sekä reittausten kokonaismäärä Beer-modeliin.

    check_cache

    @ratings_count = Rating.count
    @recent_ratings = Rails.cache.read("recent ratings")
    @top_raters = Rails.cache.read("raters top 3")
    @top_beers = Rails.cache.read("beer top 3")
    @top_breweries = Rails.cache.read("brewery top 3")
    @top_styles = Rails.cache.read("style top 3")
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice: "you should sign in to rate beers"
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  private

    def check_cache
      Rails.cache.write("beer top 3", Beer.top_rated(3), expires_in: 10.minutes) unless Rails.cache.exist?("beer top 3")
      Rails.cache.write("brewery top 3", Brewery.top_rated(3), expires_in: 10.minutes) unless Rails.cache.exist?("brewery top 3")
      Rails.cache.write("style top 3", Style.top_rated(3), expires_in: 10.minutes) unless Rails.cache.exist?("style top 3")
      Rails.cache.write("raters top 3", User.top_raters(3), expires_in: 10.minutes) unless Rails.cache.exist?("raters top 3")
      Rails.cache.write("recent ratings", Rating.recent, expires_in: 10.minutes) unless Rails.cache.exist?("recent ratings")
    end
end