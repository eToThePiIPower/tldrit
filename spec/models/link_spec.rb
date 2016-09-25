require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :user }
  it { should have_many :comments }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3).is_at_most(140) }

  it { should validate_presence_of(:url) }
  it { should validate_length_of(:url).is_at_least(3).is_at_most(140) }

  it 'is valid for valid http/https URLS' do
    link = build(:link, url: 'https://www.example.com/foo/bar')
    expect(link).to be_valid
  end

  it 'is valid when there is no scheme' do
    link = build(:link, url: 'www.example.com/foo/bar')
    expect(link).to be_valid
  end

  it 'is not valid for invalid http/https URLS' do
    link = build(:link, url: 'https://www .example.com/foo/bar')
    expect(link).not_to be_valid
  end

  it 'is not valid for non http/https schemes' do
    link = build(:link, url: 'ftp://www.example.com/foo/bar')
    expect(link).not_to be_valid
  end

  describe '#host' do
    it 'returns the base hostname of the linked url' do
      link = build(:link, url: 'https://www.example.com/foo/bar')
      expect(link.host).to eq 'www.example.com'
    end

    it 'returns the base hostname of schemeless url' do
      link = build(:link, url: 'www.example.com/foo/bar')
      expect(link.host).to eq 'www.example.com'
    end
  end

  describe '#full_url' do
    it 'normalizes schemeless urls' do
      link = build(:link, url: 'example.com')
      expect(link.full_url).to eq 'http://example.com'
    end

    it 'does not change urls with a scheme' do
      link = build(:link, url: 'ftp://example.com')
      expect(link.full_url).to eq 'ftp://example.com'
    end
  end

  describe '#total_votes' do
    it 'subtracts downvotes from upvotes' do
      link = build(:link)
      allow(link).to receive_message_chain(:votes_for, :up, :size) { 5 }
      allow(link).to receive_message_chain(:votes_for, :down, :size) { 1 }

      expect(link.votes_total).to eq(4)
    end
  end
end
