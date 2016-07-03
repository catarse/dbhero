module Dbhero
  module Configuration
    VALID_CONFIG_KEYS    = [:authenticate, :current_user_method, :custom_user_auth_condition, :csv_delimiter,
                            :user_representation, :google_api_id, :google_api_secret, :max_rows_limit, :cached_query_exp].freeze

    DEFAULT_AUTHENTICATE = true
    DEFAULT_CURRENT_USER_METHOD = :current_user
    DEFAULT_GOOGLE_API_ID = ''
    DEFAULT_GOOGLE_API_SECRET = ''
    DEFAULT_USER_PRESENTATION = :email
    DEFAULT_CUSTOM_USER_AUTH_CONDITION = nil
    DEFAULT_MAX_ROWS_LIMIT = 10_000
    DEFAULT_CSV_DELIMITER = ','
    DEFAULT_CACHED_QUERY_EXP = 10.minutes

    attr_accessor *VALID_CONFIG_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self if block_given?
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end

    def reset
      self.authenticate = DEFAULT_AUTHENTICATE
      self.current_user_method = DEFAULT_CURRENT_USER_METHOD
      self.user_representation = DEFAULT_USER_PRESENTATION
      self.google_api_id = DEFAULT_GOOGLE_API_ID
      self.google_api_secret = DEFAULT_GOOGLE_API_SECRET
      self.custom_user_auth_condition = DEFAULT_CUSTOM_USER_AUTH_CONDITION
      self.max_rows_limit = DEFAULT_MAX_ROWS_LIMIT
      self.csv_delimiter = DEFAULT_CSV_DELIMITER
      self.cached_query_exp = DEFAULT_CACHED_QUERY_EXP
    end

  end
end


