class CreateBuckets < ActiveRecord::Migration[5.1]
  def change
    create_table :buckets do |t|
      t.string :picture
      t.integer :micropost_id

      t.timestamps
    end
  end
end
