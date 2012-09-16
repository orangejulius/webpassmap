class Building < ActiveRecord::Base
  belongs_to :city
  attr_accessible :businessService, :name, :speeds
end
