require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  before(:each) do
    assign(:posts, [
             create(:post, title: 'Title', url: 'http://www.example.com/foo/bar'),
             create(:post, title: 'Title', url: 'www.example.com/foo/bar')
           ])
  end

  it 'renders a list of posts' do
    render
    assert_select 'li>h4>a', text: 'Title'.to_s, count: 2
    assert_select 'li>h4>small', text: '(www.example.com)'.to_s, count: 2
  end
end
