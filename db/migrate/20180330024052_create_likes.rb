class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.integer :user_id, default: 0, index: true
      t.integer :micropost_id, default: 0, index: true

      t.timestamps
    end
  end
end
