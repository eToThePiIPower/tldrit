require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      post = create(:post)
      get :index
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      post = create(:post)
      get :show, id: post.id
      expect(assigns(:post)).to eq(post)
    end

    context 'when a user is signed in' do
      it 'assigns a new comment as @comment' do
        sign_in(create(:user))
        post = create(:post)

        get :show, id: post.id

        expect(assigns(:comment)).to be_a_new(Comment)
      end
    end

    context 'when no user is signed in' do
      it 'assigns does not a new comment as @comment' do
        post = create(:post)

        get :show, id: post.id

        expect(assigns(:comment)).to be_nil
      end
    end
  end

  describe 'GET #new' do
    context 'when a user is signed in' do
      before do
        @user = create(:user)
        sign_in(@user)
      end

      it 'assigns a new post as @post' do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
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
        @post = create(:post)
        @owner = @post.user
        sign_in(@owner)
      end

      it 'assigns the requested post as @post' do
        get :edit, id: @post.id
        expect(assigns(:post)).to eq(@post)
      end
    end

    context 'when another user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
        @user = create(:user)
        sign_in(@user)
      end

      it 'flashes an authorization error' do
        get :edit, id: @post.id
        expect(flash[:alert]).to match(/You are not authorized/)
      end

      it 'redirects to the root path' do
        get :edit, id: @post.id
        expect(response).to redirect_to root_path
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
      end

      it 'redirects to the sign_in page' do
        get :edit, id: @post.id
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
        it 'creates a new Post' do
          expect do
            post :create, post: attributes_for(:post)
          end.to change(Post, :count).by(1)
        end

        it 'assigns a newly created post as @post' do
          post :create, post: attributes_for(:post)

          expect(assigns(:post)).to be_a(Post)
          expect(assigns(:post)).to be_persisted
          expect(assigns(:post).user).to be_a(User)
        end

        it 'redirects to the created post' do
          post :create, post: attributes_for(:post)
          expect(response).to redirect_to(Post.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved post as @post' do
          post :create, post: attributes_for(:post, :invalid)
          expect(assigns(:post)).to be_a_new(Post)
        end

        it "re-renders the 'new' template" do
          post :create, post: attributes_for(:post, title: '')
          expect(response).to render_template('new')
        end
      end
    end

    context 'when no user is signed in' do
      context 'with valid params' do
        it 'does not create a new Post' do
          expect do
            post :create, post: attributes_for(:post)
          end.not_to change(Post, :count)
        end

        it 'redirects to the sign_in page' do
          post :create, post: attributes_for(:post, title: '')
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when the owner is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
        sign_in(@owner)
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:post, title: 'Something New')
        end

        it 'updates the requested post' do
          put :update, id: @post.id, post: new_attributes
          @post.reload

          expect(@post.title).to eq 'Something New'
        end

        it 'assigns the requested post as @post' do
          put :update, id: @post.id, post: new_attributes
          expect(assigns(:post)).to eq(@post)
        end

        it 'redirects to the post' do
          put :update, id: @post.id, post: new_attributes
          expect(response).to redirect_to(@post)
        end
      end

      context 'with invalid params' do
        it 'assigns the post as @post' do
          put :update, id: @post.id, post: attributes_for(:post, :invalid)
          expect(assigns(:post)).to eq(@post)
        end

        it "re-renders the 'edit' template" do
          put :update, id: @post.id, post: attributes_for(:post, :invalid)
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when another user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
        @user = create(:user)
        sign_in(@user)
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:post, title: 'Something New')
        end

        it 'does not updates the requested post' do
          old_title = @post.title

          put :update, id: @post.id, post: new_attributes
          @post.reload

          expect(@post.title).to eq old_title
        end

        it 'flashes an authorization error' do
          put :update, id: @post.id, post: new_attributes
          expect(flash[:alert]).to match(/You are not authorized/)
        end

        it 'redirects to the root path' do
          put :update, id: @post.id, post: new_attributes
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:post, title: 'Something New')
        end

        it 'does not updates the requested post' do
          old_title = @post.title

          put :update, id: @post.id, post: new_attributes
          @post.reload

          expect(@post.title).to eq old_title
        end

        it 'redirects to the sign_in page' do
          put :update, id: @post.id, post: new_attributes
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the owner is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
        sign_in(@owner)
      end

      it 'destroys the requested post' do
        expect do
          delete :destroy, id: @post.id
        end.to change(Post, :count).by(-1)
      end

      it 'redirects to the posts list' do
        delete :destroy, id: @post.id
        expect(response).to redirect_to(posts_url)
      end
    end

    context 'when another user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
        @user = create(:user)
        sign_in(@user)
      end

      it 'does not destroys the requested post' do
        expect do
          delete :destroy, id: @post.id
        end.not_to change(Post, :count)
      end

      it 'flashes an authorization error' do
        delete :destroy, id: @post.id
        expect(flash[:alert]).to match(/You are not authorized/)
      end

      it 'redirects to the root path' do
        delete :destroy, id: @post.id
        expect(response).to redirect_to root_path
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        @owner = @post.user
      end

      it 'does not destroys the requested post' do
        expect do
          delete :destroy, id: @post.id
        end.not_to change(Post, :count)
      end

      it 'redirects to the sign_in page' do
        delete :destroy, id: @post.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT #upvote' do
    context 'when a user is logged in' do
      before do
        @post = create(:post)
        @user = create(:user)
        sign_in(@user)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'increases upvotes by 1' do
        expect do
          put :upvote, id: @post.id
        end.to change(@post.votes_for.up, :count).by(1)
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'does not increase upvotes' do
        expect do
          put :upvote, id: @post.id
        end.not_to change(@post.votes_for.up, :count)
      end
    end
  end

  describe 'PUT #downvote' do
    context 'when a user is logged in' do
      before do
        @post = create(:post)
        @user = create(:user)
        sign_in(@user)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'increases downvotes by 1' do
        expect do
          put :downvote, id: @post.id
        end.to change(@post.votes_for.down, :count).by(1)
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        request.env['HTTP_REFERER'] = '/'
      end

      it 'does not increase downvotes' do
        expect do
          put :downvote, id: @post.id
        end.not_to change(@post.votes_for.down, :count)
      end
    end
  end
end
