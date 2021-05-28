module OpenWeather
  class API

    attr_reader :query
    
    # initialize the class with token and user to be used in class
    def initialize(query)
      # move to credentials
      @token = '0421598c2b006b59dd0263e87a685693'
      
      @query = query
    end

    # call OpenWeather API
    def call
      if is_query_a_coordinate?
        lat, lon = @query.split(',', 2)
        
        begin
          response = RestClient.get "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{@token}"
          format_response response
        rescue RestClient::ExceptionWithResponse
          render json: {"message": "not found"}
        end

      elsif !is_query_a_coordinate?
        begin
          response = RestClient.get "http://api.openweathermap.org/data/2.5/weather?q=#{@query}&appid=#{@token}"
          format_response response
        rescue RestClient::ExceptionWithResponse
          render json: {"message": "not found"}
        end
      else
        render json: {"message": "not a valid URL parameter"}, status: :bad_request
      end
    end

    def is_query_a_coordinate?
      there_are_numbers? && @query.include?(',')
    end

    def there_are_numbers?
      @query.chars.any? { |char| ('0'..'9').include? char }
    end

    def format_response(response)
      parsed_response = JSON.parse response.body
      temperature = parsed_response['main']['temp']
      Unit.new("#{temperature} tempK").convert_to('tempC').scalar
    end
  end
end
