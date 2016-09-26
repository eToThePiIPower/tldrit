# Post: A posted URL with a title, description, and comments
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 140 }

  validates :url, uri: true
  validates :url, presence: true, if: :link
  validates :url, length: { minimum: 3, maximum: 140 }, if: :link

  validates :description, presence: true, unless: :link
  validates :description, length: { minimum: 20, maximum: 2000 }, unless: :link

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

  def score
    cached_votes_score
  end

  def link?
    url.present?
  end
end
