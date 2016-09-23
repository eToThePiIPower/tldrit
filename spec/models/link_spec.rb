require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3).is_at_most(140) }

  it { should validate_presence_of(:url) }

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

  it 'normalizes schemeless urls' do
    link = build(:link, url: 'example.com')
    expect(link.url).to eq 'http://example.com'
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
end
