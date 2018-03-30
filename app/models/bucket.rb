class Bucket < ApplicationRecord
  belongs_to :micropost
  mount_uploader :picture, PostPicUploader
  #validate :picture_size, on: :save

  private

  # def picture_size
  #     return if self.picture.size > 3.megabytes
  #     errors.add(:picture, "should be less than 5MB")
  # end
end
