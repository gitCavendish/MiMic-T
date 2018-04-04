class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" # 省略了 foreign_key: :follower_id
  # 从relationships 表出发，可以拿着 follower_id 去找对应的 user_id
  belongs_to :followed, class_name: "User" # 省略了 foreign_key: :followed_id
  # 从relationships 表出发，可以拿着 followed_id 去找对应的 user_id
  validates :followed_id, :follower_id, presence: true
  validate :self_referential_not_allowed

  private

  def self_referential_not_allowed
    if self.followed_id == self.follower_id
      errors.add(:self_refer, "can't follow yourself.")
    end
  end

end
