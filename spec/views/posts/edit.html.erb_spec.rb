require 'rails_helper'

RSpec.describe 'posts/edit', type: :view do
  before(:each) do
    @post = assign(:post, create(:post))
  end

  it 'renders the edit post form' do
    render

    assert_select 'form[action=?][method=?]', post_path(@post), 'post' do
      assert_select 'input#post_title[name=?]', 'post[title]'

      assert_select 'input#post_url[name=?]', 'post[url]'
    end
  end
end
