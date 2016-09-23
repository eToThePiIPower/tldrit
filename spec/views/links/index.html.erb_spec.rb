require 'rails_helper'

RSpec.describe 'links/index', type: :view do
  before(:each) do
    assign(:links, [
             create(:link, title: 'Title', url: 'Url'),
             create(:link, title: 'Title', url: 'Url')
           ])
  end

  it 'renders a list of links' do
    render
    assert_select 'li>h4>a', text: 'Title'.to_s, count: 2
    assert_select 'li>h4>small', text: '(Url)'.to_s, count: 2
  end
end
