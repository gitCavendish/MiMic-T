class Camp < ApplicationRecord
  belongs_to :user, optional: true
  validates :title, :intro, :venue, :time, presence: true
  mount_uploader :picture, CampPicUploader
end
