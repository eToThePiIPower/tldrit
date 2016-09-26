require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to :user }
  it { should have_many :comments }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3).is_at_most(140) }

  context 'if link' do
    before { allow(subject).to receive(:link).and_return(true) }
    it { should validate_presence_of(:url) }
    it { should_not validate_presence_of(:description) }
    it { should validate_length_of(:url).is_at_least(3).is_at_most(140) }
  end

  context 'if not link' do
    before { allow(subject).to receive(:link).and_return(false) }
    it { should validate_presence_of(:description) }
    it { should_not validate_presence_of(:url) }
    it { should validate_length_of(:description).is_at_least(20).is_at_most(2000) }
  end

  it 'is valid for valid http/https URLS' do
    post = build(:post, url: 'https://www.example.com/foo/bar')
    expect(post).to be_valid
  end

  it 'is valid when there is no scheme' do
    post = build(:post, url: 'www.example.com/foo/bar')
    expect(post).to be_valid
  end

  it 'is not valid for invalid http/https URLS' do
    post = build(:post, url: 'https://www .example.com/foo/bar')
    expect(post).not_to be_valid
  end

  it 'is not valid for non http/https schemes' do
    post = build(:post, url: 'ftp://www.example.com/foo/bar')
    expect(post).not_to be_valid
  end

  describe '#host' do
    it 'returns the base hostname of the posted url' do
      post = build(:post, url: 'https://www.example.com/foo/bar')
      expect(post.host).to eq 'www.example.com'
    end

    it 'returns the base hostname of schemeless url' do
      post = build(:post, url: 'www.example.com/foo/bar')
      expect(post.host).to eq 'www.example.com'
    end
  end

  describe '#full_url' do
    it 'normalizes schemeless urls' do
      post = build(:post, url: 'example.com')
      expect(post.full_url).to eq 'http://example.com'
    end

    it 'does not change urls with a scheme' do
      post = build(:post, url: 'ftp://example.com')
      expect(post.full_url).to eq 'ftp://example.com'
    end
  end

  describe '#score' do
    it 'subtracts downvotes from upvotes' do
      post = build(:post)
      expect(post).to receive(:cached_votes_score)
      post.score
    end
  end
end
