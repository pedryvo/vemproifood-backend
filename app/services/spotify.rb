module Spotify
  class API
    attr_reader :query

    # initialize the class with token and user to be used in class
    def initialize(query)
      @query = query

      # move to credentials
      @client_id = '70166a8803b64e91b28581c88583ec25'
      @client_secret = '3e785abde5174e91ac592e08baaa7af5'
    end

    # call OpenWeather api
    def call
      login if RSpotify.client_token.nil?
      playlists = RSpotify::Playlist.search(@query)
      id = (0..playlists.size-1).to_a.sample
      result = []

      playlists[id].tracks.each do |track|
        result.push("#{track.artists.first.name} - #{track.name}")
      end

      result
    end

    def login
      RSpotify.authenticate(@client_id, @client_secret)
    end
  end
end
