class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.text :speeds
      t.boolean :businessService
      t.references :city

      t.timestamps
    end
    add_index :buildings, :city_id
  end
end
