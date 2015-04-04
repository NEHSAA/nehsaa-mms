module OldWorld
  class Base < ActiveRecord::Base
    self.abstract_class = true
    # def readonly?; true; end
    establish_connection Rails.configuration.database_configuration['old_world']
  end
end
