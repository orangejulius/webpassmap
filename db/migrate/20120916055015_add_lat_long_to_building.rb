class AddLatLongToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :latlon, :string
  end
end
