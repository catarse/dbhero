module Dbhero
  class RouterConstraint
    @@routes = Dbhero::Engine.routes

    def self.matches? request, options = {}
      _ = new(request, options)
      _.match?
    end

    def initialize(request, options)
      @request = request
      @options = options
      @devise_mapping = options[:devise_mapping] || :user
      @devise_auth = options[:devise_auth] || false
      @enable_public_clip = options[:enable_public_clip] || false
    end

    def match?
      return ((@enable_public_clip && check_if_is_public_dataclip) ||
              (@devise_auth && authenticate_warden && check_custom_condition))
    end

    private

    def check_if_is_public_dataclip
      if @request.path.match(/\/dataclips\/([\w\-]{36}+)$/)
        return Dbhero::Dataclip.where(token: $1).exists?
      end
    end

    def authenticate_warden
      @request.env['warden'].send(:authenticate!, scope: @devise_mapping)
    end

    def check_custom_condition
      auth_condition.is_a?(Proc) && auth_condition.call( @request.env['warden'].user(@devise_mapping) )
    end

    def auth_condition
      @options[:custom_auth_condition]
    end
  end
end
