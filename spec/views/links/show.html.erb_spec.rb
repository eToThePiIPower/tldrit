require 'rails_helper'

RSpec.describe 'links/show', type: :view do
  before(:each) do
    @link = assign(:link, create(:link, title: 'Title', url: 'https://www.example.com/foo/bar'))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/www.example.com/)
  end
end
