class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])

    session[:last_city_searched] = params[:city]

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
    places = Rails.cache.read(session[:last_city_searched])

    @place = nil
    places.each do | bar |
      if bar.id == params[:id]
        @place = bar
      end
    end

    @address = ERB::Util.url_encode(@place.street) + "," + ERB::Util.url_encode(@place.city) + ERB::Util.url_encode(@place.country)

    @gmap_api_key = get_gmap_api_key

    render :show
  end

  private

  def get_gmap_api_key
    raise "GMAP_APIKEY env not set" if ENV['GMAP_APIKEY'].nil?
    ENV['GMAP_APIKEY']
  end

end