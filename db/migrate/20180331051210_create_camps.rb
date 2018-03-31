class CreateCamps < ActiveRecord::Migration[5.1]
  def change
    create_table :camps do |t|
      t.string :title
      t.string :venue
      t.text :intro
      t.datetime :time
      t.integer :user_id
      t.string :picture

      t.timestamps
    end
  end
end
