class Relationship < ApplicationRecord
    belongs_to :follower, class_name: "User" #follower_idが外部キーとなって、user.idに紐づくUserを保持できる
    belongs_to :followed, class_name: "User"
    validates :follower_id, presence: true
    validates :followed_id, presence: true
end
