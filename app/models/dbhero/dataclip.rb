module Dbhero
  class Dataclip < ActiveRecord::Base
    before_validation :set_token

    scope :ordered, -> { order(updated_at: :desc) }

    validates :description, :raw_query, :token, presence: true
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

    def check_query
      query_result
      @q_result.present?
    end

    def query_result
      Dataclip.transaction do
        begin
          @q_result ||= ActiveRecord::Base.connection.select_all("select sub.* from (#{self.raw_query}) sub")
        rescue => e
          self.errors.add(:base, e.message)
        end
        raise ActiveRecord::Rollback
      end
    end

    def csv_string
      csv = ''
      csv << "#{@q_result.columns.join(',')}\n"
      @q_result.rows.each { |row| csv << "#{row.join(',')}\n" }
      csv
    end
  end
end
