class MainController < ApplicationController
  def search
    if params[:city].nil? # is a coordinate
      lat = params[:latitude]
      long = params[:longitude]
      query = "#{lat},#{long}"

      if coordinates_correct?(query)
        temperature = OpenWeather::API.new(query).call
        playlists = Spotify::API.new(playlist_kind(temperature)).call
        render json: playlists, status: :ok
      else
        render json: "{'message': 'coordinates are in bad format'}", status: :forbidden
      end
    else # is a city
      query = I18n.transliterate params[:city]

      temperature = OpenWeather::API.new(query).call
      playlists = Spotify::API.new(playlist_kind(temperature)).call
      render json: playlists, status: :ok
    end
  end

  private

  def coordinates_correct?(coordinates)
    regex = /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/
    coordinates.match? regex
  end

  def playlist_kind(temperature)
    if temperature > 30.to_f
      "party"
    elsif temperature.between?(15, 30)
      "pop"
    elsif temperature.between?(10, 14)
      "rock"
    else
      "classical"
    end
  end

end
