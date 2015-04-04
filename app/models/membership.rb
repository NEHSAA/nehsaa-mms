class Membership < ActiveRecord::Base
  belongs_to :member

  validates :year, numericality: { only_integer: true, greater_than: 0 }

end
