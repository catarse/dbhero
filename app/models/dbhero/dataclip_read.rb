class Dbhero::DataclipRead < Dbhero::Dataclip
  if ENV['READ_REPLICA_DB_URL'].present?
    self.abstract_class = true
    establish_connection(ENV['READ_REPLICA_DB_URL'])
  end
end
