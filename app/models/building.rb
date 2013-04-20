class Building < ActiveRecord::Base
  belongs_to :city
  attr_accessible :businessService, :name, :speeds

  scope :ungeocoded, where(latlon: nil)

  def address
    "#{name}, #{city.name}, CA"
  end
end
