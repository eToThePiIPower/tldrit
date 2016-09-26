# Comment: a comment made by a user, attached to a post
class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :body
end
