module OldWorld
  class SchemaMigration < Base
    self.table_name = 'schema_migrations'
    self.primary_key = 'version'
  end
end
