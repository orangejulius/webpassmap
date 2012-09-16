class AddUrlToCity < ActiveRecord::Migration
  def change
    add_column :cities, :url, :string
  end
end
