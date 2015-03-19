module Dbhero
  class Dataclip < ActiveRecord::Base
    before_validation :set_token

    validates :description, :raw_query, :token, presence: true

    def set_token
      self.token = SecureRandom.uuid unless self.token
    end

    def to_param
      self.token
    end
  end
end
