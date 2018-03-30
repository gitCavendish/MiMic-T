class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user

  validates :message, presence: true, length: 5..100
end
