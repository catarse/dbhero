module Dbhero
  module Configuration
    VALID_CONFIG_KEYS    = [:authenticate_method, :current_user_method, :user_representation, :google_api_id, :google_api_secret].freeze

    DEFAULT_AUTHENTICATE_METHOD = :authenticate_user!
    DEFAULT_CURRENT_USER_METHOD = :current_user
    DEFAULT_GOOGLE_API_ID = ''
    DEFAULT_GOOGLE_API_SECRET = ''
    DEFAULT_USER_PRESENTATION = :email

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
      self.authenticate_method = DEFAULT_AUTHENTICATE_METHOD
      self.current_user_method = DEFAULT_CURRENT_USER_METHOD
      self.user_representation = DEFAULT_USER_PRESENTATION
      self.google_api_id = DEFAULT_GOOGLE_API_ID
      self.google_api_secret = DEFAULT_GOOGLE_API_SECRET
    end

  end
end


