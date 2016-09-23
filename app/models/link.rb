# Link: A posted URL with a title, description, and comments
class Link < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 140 }

  validates :url, presence: true, uri: true
  validates :url, length: { minimum: 3, maximum: 140 }

  def host
    URI.parse(url).host || URI.parse('http://' + url).host
  rescue URI::InvalidURIError
    nil
  end

  def url
    uri = URI.parse(self[:url])
    uri.scheme ? self[:url] : 'http://' + self[:url]
  rescue URI::InvalidURIError
    self[:url]
  end
end
