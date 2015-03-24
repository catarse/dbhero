module Dbhero
  class Dataclip < ActiveRecord::Base
    before_create :set_token

    scope :ordered, -> { order(updated_at: :desc) }
    scope :search, ->(term) { where(arel_table[:description].matches("%#{term}%")) }

    validates :description, :raw_query, presence: true
    attr_reader :q_result

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

    def query_result
      Dataclip.transaction do
        begin
          @q_result ||= ActiveRecord::Base.connection.select_all(self.raw_query)
        rescue => e
          self.errors.add(:base, e.message)
        end
        raise ActiveRecord::Rollback
      end
    end

    def csv_string
      query_result
      csv = ''
      csv << "#{@q_result.columns.join(',')}\n"
      @q_result.rows.each { |row| csv << "#{row.join(',')}\n" }
      csv
    end
  end
end
