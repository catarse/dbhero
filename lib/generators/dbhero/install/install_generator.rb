module Dbhero
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Installs DBHero and generate migrations"
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_initializer
        template 'dbhero.rb', 'config/initializers/dbhero.rb'
      end

      def create_migrations
        migration_template "migrations/create_dbhero_dataclips.rb", "db/migrate/create_dbhero_dataclips.rb"
      end
    end
  end
end

