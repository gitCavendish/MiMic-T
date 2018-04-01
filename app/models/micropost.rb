class Micropost < ApplicationRecord
  belongs_to :user
  has_many :buckets, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: 5..300
  accepts_nested_attributes_for :buckets
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  #validate :picture_size
  # validate :check_max_files

  private

  # def check_max_files
  #     return if self.buckets.count > 6
  #     errors.add(:file_amount, "Upload 6 photos at most.")
  # end

end
