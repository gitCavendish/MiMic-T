class AddSendToIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :been_read, :boolean, default: false
    add_column :comments, :send_to, :integer, index: true
  end
end
