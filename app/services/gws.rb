class GWS
  API_KEY = ENV["GWS_API_KEY"]
  AUTH_HEADERS = "Token #{GWS::API_KEY}"
  BASE_URL = "https://api.globalwinescore.com/globalwinescores/latest/?"
  class << self

    def auth_then
      HTTP.auth(GWS::AUTH_HEADERS)
        .headers(:accept => "application/json")
    end

    # Requests Params
    #
    #  wine_id  - The wine is as an Integer
    #  vintage  - A year as an Integer
    #  region   - The region as a String
    #  appellation   - The region as a String
    #  limit    - The limit as an Integer, default: 5000
    #  offset   - A potentiel offset as an Integer
    #  ordering - [date, -date, score, -score] as a String
    #  is_primeurs - A boolean, default: true
    #
    def fetch_latest(params)
      wines = []
      offset = 0
      limit = 5000
      params_with_defaults = { limit: limit }.merge(params)
      response = auth_then.get(BASE_URL, params: params_with_defaults)
      count = response.parse["count"]

      while offset < count
        if response.code == 200
          response.parse["results"].each do |result|
            wines << result
          end
        else
          []
        end
        response = auth_then.get(response.parse["next"]) if response.parse["next"] != nil
        offset += 5000
      end
      wines
    end

    def update_all()
      # TODO, same as the seed
    end

  end
end

