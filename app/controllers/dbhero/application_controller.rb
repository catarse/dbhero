module Dbhero
  class ApplicationController < ActionController::Base
    def check_auth
      if Dbhero.authenticate
        unless _current_user && call_custom_auth
          raise ActionController::RoutingError.new('Forbidden')
        end
      end
    end

    def user_representation
      _current_user.send(Dbhero.user_representation) if _current_user
    end

    def _current_user
      if Dbhero.current_user_method.present?
        send(Dbhero.current_user_method)
      end
    end

    def call_custom_auth
      cond = Dbhero.custom_user_auth_condition
      if cond.present? && cond.is_a?(Proc)
        cond.call(_current_user)
      else
        true
      end
    end
  end
end
