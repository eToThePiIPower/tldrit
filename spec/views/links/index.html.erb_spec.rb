require 'rails_helper'

RSpec.describe 'links/index', type: :view do
  before(:each) do
    assign(:links, [
             create(:link, title: 'Title', url: 'http://www.example.com/foo/bar'),
             create(:link, title: 'Title', url: 'www.example.com/foo/bar')
           ])
  end

  it 'renders a list of links' do
    render
    assert_select 'li>h4>a', text: 'Title'.to_s, count: 2
    assert_select 'li>h4>small', text: '(www.example.com)'.to_s, count: 2
  end
end
