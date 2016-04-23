class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.string :text
      t.boolean :response

      t.timestamps null: false
    end
  end
end
