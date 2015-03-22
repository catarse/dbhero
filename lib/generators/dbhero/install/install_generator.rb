module Dbhero
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Installs DBHero and generate migrations"
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_initializer
        template 'dbhero.rb', 'config/initializers/dbhero.rb'
      end

      def create_migrations
        migration_template "migrations/create_dbhero_dataclips.rb", "db/migrate/create_dbhero_dataclips.rb"
      end

      # for migration generation
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end
    end
  end
end

