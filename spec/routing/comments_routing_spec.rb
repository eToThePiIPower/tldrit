require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/posts/1/comments').to route_to('comments#create', post_id: '1')
    end

    it 'routes to #create' do
      expect(delete: '/posts/1/comments/2').to route_to('comments#destroy', post_id: '1', id: '2')
    end

    it 'routes to #edit' do
      expect(get: '/posts/1/comments/2/edit').to route_to('comments#edit', post_id: '1', id: '2')
    end

    it 'routes to #update' do
      expect(put: '/posts/1/comments/2').to route_to('comments#update', post_id: '1', id: '2')
    end
  end
end
