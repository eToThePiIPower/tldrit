# Comment: a comment made by a user, attached to a post
class Comment < ActiveRecord::Base
  belongs_to :link
  belongs_to :user

  validates_presence_of :body
end
