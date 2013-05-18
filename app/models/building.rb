class Building < ActiveRecord::Base
  belongs_to :city

  scope :ungeocoded, ->{ where(latlon: nil) }

  def address
    "#{name}, #{city.name}, CA"
  end
end
