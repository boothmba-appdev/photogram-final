# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  comments_count                 :integer          default(0)
#  email                          :string
#  likes_count                    :integer          default(0)
#  own_photos_count               :integer          default(0)
#  password_digest                :string
#  private                        :boolean
#  received_follow_requests_count :integer          default(0)
#  sent_follow_requests_count     :integer          default(0)
#  username                       :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class User < ApplicationRecord
  validates(:username, { :presence => true })
  validates(:username, { :uniqueness => true })
  validates :email, :presence => true
  validates :email, :uniqueness => { :case_sensitive => false }
  has_secure_password

  # Add Direct Associations
  has_many(:likes, { :class_name => "Like", :foreign_key => "fan_id", :dependent => :destroy })
  has_many(:comments, { :class_name => "Comment", :foreign_key => "author_id", :dependent => :destroy })
  has_many(:sent_follow_requests, { :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy })
  has_many(:received_follow_requests, { :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy })
  has_many(:own_photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })

  # Add Indirect Associations (Guide)
  #has_many(:following, { :through => :sent_follow_requests, :source => :recipient })
  #has_many(:followers, { :through => :received_follow_requests, :source => :sender })
  has_many(:liked_photos, { :through => :likes, :source => :photo })
  #has_many(:feed, { :through => :following, :source => :own_photos })
  #has_many(:activity, { :through => :following, :source => :liked_photos })
end
