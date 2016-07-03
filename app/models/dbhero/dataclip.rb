require 'csv'

module Dbhero
  class Dataclip < ActiveRecord::Base
    before_create :set_token
    after_save :refresh_cache

    scope :ordered, -> { order(updated_at: :desc) }
    scope :search, ->(term) { where(arel_table[:description].matches("%#{term}%")) }

    validates :description, :raw_query, presence: true
    attr_reader :q_result

    def refresh_cache
      Rails.cache.delete("dataclip_#{self.token}")
    end


    def set_token
      self.token = SecureRandom.uuid unless self.token
    end

    def to_param
      self.token
    end

    def title
      description.split("\n")[0]
    end

    def description_without_title
      description.split("\n")[1..-1].join("\n")
    end

    def total_rows
      @total_rows ||= @q_result.rows.length
    end

    def cached?
      @cached ||= Rails.cache.fetch("dataclip_#{self.token}").present?
    end

    def query_result
      DataclipRead.transaction do
        begin
          @q_result ||= Rails.cache.fetch("dataclip_#{self.token}", expires_in: (::Dbhero.cached_query_exp||10.minutes)) do
            DataclipRead.connection.select_all(self.raw_query)
          end
        rescue => e
          self.errors.add(:base, e.message)
        end
        raise ActiveRecord::Rollback
      end
    end

    def csv_string
      query_result
      csv_string = CSV.generate(force_quotes: true, col_sep: Dbhero.csv_delimiter) do |csv|
        csv << @q_result.columns
        @q_result.rows.each { |row| csv << row }
      end
      csv_string
    end
  end
end
