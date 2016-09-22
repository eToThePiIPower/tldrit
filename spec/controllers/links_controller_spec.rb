require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'GET #index' do
    it 'assigns all links as @links' do
      link = create(:link)
      get :index
      expect(assigns(:links)).to eq([link])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested link as @link' do
      link = create(:link)
      get :show, id: link.id
      expect(assigns(:link)).to eq(link)
    end
  end

  describe 'GET #new' do
    it 'assigns a new link as @link' do
      get :new
      expect(assigns(:link)).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested link as @link' do
      link = create(:link)
      get :edit, id: link.id
      expect(assigns(:link)).to eq(link)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Link' do
        expect do
          post :create, link: attributes_for(:link)
        end.to change(Link, :count).by(1)
      end

      it 'assigns a newly created link as @link' do
        post :create, link: attributes_for(:link)

        expect(assigns(:link)).to be_a(Link)
        expect(assigns(:link)).to be_persisted
      end

      it 'redirects to the created link' do
        post :create, link: attributes_for(:link)
        expect(response).to redirect_to(Link.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved link as @link' do
        post :create, link: attributes_for(:link, :invalid)
        expect(assigns(:link)).to be_a_new(Link)
      end

      it "re-renders the 'new' template" do
        post :create, link: attributes_for(:link, title: '')
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:link, title: 'Something New')
      end

      it 'updates the requested link' do
        link = create(:link)

        put :update, id: link.id, link: new_attributes
        link.reload

        expect(link.title).to eq 'Something New'
      end

      it 'assigns the requested link as @link' do
        link = create(:link)
        put :update, id: link.id, link: new_attributes
        expect(assigns(:link)).to eq(link)
      end

      it 'redirects to the link' do
        link = create(:link)
        put :update, id: link.id, link: new_attributes
        expect(response).to redirect_to(link)
      end
    end

    context 'with invalid params' do
      it 'assigns the link as @link' do
        link = create(:link)
        put :update, id: link.id, link: attributes_for(:link, :invalid)
        expect(assigns(:link)).to eq(link)
      end

      it "re-renders the 'edit' template" do
        link = create(:link)
        put :update, id: link.id, link: attributes_for(:link, :invalid)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested link' do
      link = create(:link)
      expect do
        delete :destroy, id: link.id
      end.to change(Link, :count).by(-1)
    end

    it 'redirects to the links list' do
      link = create(:link)
      delete :destroy, id: link.id
      expect(response).to redirect_to(links_url)
    end
  end
end
