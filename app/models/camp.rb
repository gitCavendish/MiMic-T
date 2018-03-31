class Camp < ApplicationRecord
  belongs_to :user, optional: true
  has_many :participator_relationships
  has_many :participators, through: :participator_relationships, source: :user

  validates :title, :intro, :venue, :time, presence: true
  mount_uploader :picture, CampPicUploader
end
