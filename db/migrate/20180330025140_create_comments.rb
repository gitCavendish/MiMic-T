class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :user_id, index: true
      t.integer :micropost_id, index: true
      t.text :message

      t.timestamps
    end
  end
end
