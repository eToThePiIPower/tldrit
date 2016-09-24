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
    context 'when a user is signed in' do
      before do
        @user = create(:user)
        sign_in(@user)
      end

      it 'assigns a new link as @link' do
        get :new
        expect(assigns(:link)).to be_a_new(Link)
      end
    end

    context 'when no user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
      end

      it 'redirects to the sign_in page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'when the owner is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
        sign_in(@owner)
      end

      it 'assigns the requested link as @link' do
        get :edit, id: @link.id
        expect(assigns(:link)).to eq(@link)
      end
    end

    context 'when another user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
        @user = create(:user)
        sign_in(@user)
      end

      it 'flashes an authorization error' do
        get :edit, id: @link.id
        expect(flash[:alert]).to match(/You are not authorized/)
      end

      it 'redirects to the root path' do
        get :edit, id: @link.id
        expect(response).to redirect_to root_path
      end
    end

    context 'when no user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
      end

      it 'redirects to the sign_in page' do
        get :edit, id: @link.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'when a user is signed in' do
      before do
        @user = create(:user)
        sign_in(@user)
      end

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
          expect(assigns(:link).user).to be_a(User)
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

    context 'when no user is signed in' do
      context 'with valid params' do
        it 'does not create a new Link' do
          expect do
            post :create, link: attributes_for(:link)
          end.not_to change(Link, :count)
        end

        it 'redirects to the sign_in page' do
          post :create, link: attributes_for(:link, title: '')
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when the owner is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
        sign_in(@owner)
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:link, title: 'Something New')
        end

        it 'updates the requested link' do
          put :update, id: @link.id, link: new_attributes
          @link.reload

          expect(@link.title).to eq 'Something New'
        end

        it 'assigns the requested link as @link' do
          put :update, id: @link.id, link: new_attributes
          expect(assigns(:link)).to eq(@link)
        end

        it 'redirects to the link' do
          put :update, id: @link.id, link: new_attributes
          expect(response).to redirect_to(@link)
        end
      end

      context 'with invalid params' do
        it 'assigns the link as @link' do
          put :update, id: @link.id, link: attributes_for(:link, :invalid)
          expect(assigns(:link)).to eq(@link)
        end

        it "re-renders the 'edit' template" do
          put :update, id: @link.id, link: attributes_for(:link, :invalid)
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when another user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
        @user = create(:user)
        sign_in(@user)
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:link, title: 'Something New')
        end

        it 'does not updates the requested link' do
          old_title = @link.title

          put :update, id: @link.id, link: new_attributes
          @link.reload

          expect(@link.title).to eq old_title
        end

        it 'flashes an authorization error' do
          delete :destroy, id: @link.id
          expect(flash[:alert]).to match(/You are not authorized/)
        end

        it 'redirects to the root path' do
          put :update, id: @link.id, link: new_attributes
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when no user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:link, title: 'Something New')
        end

        it 'does not updates the requested link' do
          old_title = @link.title

          put :update, id: @link.id, link: new_attributes
          @link.reload

          expect(@link.title).to eq old_title
        end

        it 'redirects to the sign_in page' do
          put :update, id: @link.id, link: new_attributes
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the owner is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
        sign_in(@owner)
      end

      it 'destroys the requested link' do
        expect do
          delete :destroy, id: @link.id
        end.to change(Link, :count).by(-1)
      end

      it 'redirects to the links list' do
        delete :destroy, id: @link.id
        expect(response).to redirect_to(links_url)
      end
    end

    context 'when another user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
        @user = create(:user)
        sign_in(@user)
      end

      it 'does not destroys the requested link' do
        expect do
          delete :destroy, id: @link.id
        end.not_to change(Link, :count)
      end

      it 'flashes an authorization error' do
        delete :destroy, id: @link.id
        expect(flash[:alert]).to match(/You are not authorized/)
      end

      it 'redirects to the root path' do
        delete :destroy, id: @link.id
        expect(response).to redirect_to root_path
      end
    end

    context 'when no user is logged in' do
      before do
        @link = create(:link)
        @owner = @link.user
      end

      it 'does not destroys the requested link' do
        expect do
          delete :destroy, id: @link.id
        end.not_to change(Link, :count)
      end

      it 'redirects to the sign_in page' do
        delete :destroy, id: @link.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT #upvote' do
    context 'when a user is logged in' do
      before do
        @link = create(:link)
        @user = create(:user)
        sign_in(@user)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'increases upvotes by 1' do
        expect do
          put :upvote, id: @link.id
        end.to change(@link.votes_for.up, :count).by(1)
      end
    end

    context 'when no user is logged in' do
      before do
        @link = create(:link)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'does not increase upvotes' do
        expect do
          put :upvote, id: @link.id
        end.not_to change(@link.votes_for.up, :count)
      end
    end
  end

  describe 'PUT #downvote' do
    context 'when a user is logged in' do
      before do
        @link = create(:link)
        @user = create(:user)
        sign_in(@user)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'increases downvotes by 1' do
        expect do
          put :downvote, id: @link.id
        end.to change(@link.votes_for.down, :count).by(1)
      end
    end

    context 'when no user is logged in' do
      before do
        @link = create(:link)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'does not increase downvotes' do
        expect do
          put :downvote, id: @link.id
        end.not_to change(@link.votes_for.down, :count)
      end
    end
  end
end
