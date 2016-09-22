require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3).is_at_most(140) }

  it { should validate_presence_of(:url) }
  it { should validate_length_of(:url).is_at_least(3).is_at_most(140) }
end
