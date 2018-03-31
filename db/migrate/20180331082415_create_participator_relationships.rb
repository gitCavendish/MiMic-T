class CreateParticipatorRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :participator_relationships do |t|
      t.integer :user_id, index: true
      t.integer :camp_id, index: true

      t.timestamps
    end
  end
end
