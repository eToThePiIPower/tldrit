require 'digest/md5'
# User: The master class
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username
  validates_uniqueness_of :username, case_sensitive: false

  validates :homepage, uri: true, if: :homepage

  has_many :posts
  has_many :comments

  acts_as_voter

  # Socials
  def facebook_url
    "https://facebook.com/#{facebook}"
  end

  def twitter_url
    "https://twitter.com/#{twitter}"
  end

  def google_plus_url
    "https://plus.google.com/+#{google_plus}"
  end

  def homepage_url
    homepage
  end

  # Gravatar functions

  GRAVATAR_BASE = 'https://www.gravatar.com/avatar/'.freeze
  GRAVATAR_DEFAULT = 'wavatar'.freeze # identicon,monsterid,wavatar,retro,mm
  def gravatar_id
    base_email = email.strip.downcase
    Digest::MD5.hexdigest(base_email)
  end

  def gravatar(size = 500)
    GRAVATAR_BASE + gravatar_id + "?s=#{size}&d=#{GRAVATAR_DEFAULT}"
  end
end
