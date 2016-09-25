# Link: A posted URL with a title, description, and comments
class Link < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 140 }

  validates :url, presence: true, uri: true
  validates :url, length: { minimum: 3, maximum: 140 }

  acts_as_votable

  def host
    URI.parse(full_url).host
  rescue URI::InvalidURIError
    nil
  end

  def full_url
    uri = URI.parse(self[:url])
    uri.scheme ? self[:url] : 'http://' + self[:url]
  rescue URI::InvalidURIError
    self[:url]
  end

  def votes_total
    votes_for.up.size - votes_for.down.size
  end
end
