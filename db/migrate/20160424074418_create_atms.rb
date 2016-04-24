class CreateAtms < ActiveRecord::Migration
  def change
    create_table :atms do |t|
      t.string :name
      t.string :address
      t.float :lat
      t.float :long

      t.timestamps null: false
    end
  end
end
