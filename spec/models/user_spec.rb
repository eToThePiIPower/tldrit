require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :posts }
  it { should have_many :comments }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of(:username).case_insensitive }

  describe '#gravatar_id' do
    it 'should return a valid gravatar id' do
      email = 'MyEmailAddress@example.com '
      user = build(:user, email: email)

      expect(user.gravatar_id).to eq '0bc83cb571cd1c50ba6f3e8a78ef1346'
    end
  end

  describe '#gravatar' do
    before do
      email = 'MyEmailAddress@example.com '
      @user = build(:user, email: email)
    end

    it 'should return a valid gravatar image url' do
      expect(@user.gravatar).to match '^https://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346'
    end

    it 'should default to a size of 500 pixels' do
      expect(@user.gravatar).to match 's=500'
    end

    it 'should accept custom sizes' do
      expect(@user.gravatar(80)).to match 's=80'
    end

    it 'should request a wavatar if no avatar is set' do
      expect(@user.gravatar).to match 'd=wavatar'
    end
  end
end
