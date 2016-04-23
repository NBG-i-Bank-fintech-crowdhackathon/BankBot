class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :fb_id
      t.string :email
      t.string :bank_id
      t.string :account_id
      t.integer :pin
      t.string :state
      t.boolean :clear_state
      t.integer :rating
      t.float :location_lat
      t.float :location_long

      t.timestamps null: false
    end
  end
end
