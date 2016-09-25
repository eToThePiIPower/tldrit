require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/links/1/comments').to route_to('comments#create', link_id: '1')
    end

    it 'routes to #create' do
      expect(delete: '/links/1/comments/2').to route_to('comments#destroy', link_id: '1', id: '2')
    end

    it 'routes to #edit' do
      expect(get: '/links/1/comments/2/edit').to route_to('comments#edit', link_id: '1', id: '2')
    end

    it 'routes to #update' do
      expect(put: '/links/1/comments/2').to route_to('comments#update', link_id: '1', id: '2')
    end
  end
end
