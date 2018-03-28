class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  #validate :picture_size

  private

    # sdef picture_size
    # s  if pictures.size > 5.megabytes
    # s    errors.add(:pictures, "should be less than 5MB")
    # s  end
    # send
end
