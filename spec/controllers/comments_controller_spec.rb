require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    before do
      @post = create(:post)
    end

    context 'when a user is signed in' do
      before do
        @user = create(:user)
        sign_in(@user)
      end

      context 'with valid params' do
        it 'creates a new Comment' do
          expect do
            post :create, comment: attributes_for(:comment), post_id: @post.id
          end.to change(Comment, :count).by(1)
        end

        it 'assigns a newly created Comment as @comment' do
          post :create, comment: attributes_for(:comment), post_id: @post.id

          expect(assigns(:comment)).to be_a(Comment)
          expect(assigns(:comment)).to be_persisted
        end

        it 'belongs to the correct post and user' do
          post :create, comment: attributes_for(:comment), post_id: @post.id

          expect(Comment.last.post).to eq(@post)
          expect(Comment.last.user).to eq(@user)
        end

        it 'redirects to the parent post' do
          post :create, comment: attributes_for(:comment), post_id: @post.id
          expect(response).to redirect_to(@post)
        end
      end

      context 'with invalid params' do
        it 'does not save the comment if the body is invalid' do
          expect do
            post :create, comment: attributes_for(:comment, body: ''), post_id: @post.id
          end.not_to change(Comment, :count)
        end

        it 'does not save the comment if the post_id is invalid' do
          expect do
            post :create, comment: attributes_for(:comment), post_id: (Post.last.id + 1)
          end.not_to change(Comment, :count)
        end

        it 'redirects to the parent post' do
          post :create, comment: attributes_for(:comment, body: ''), post_id: @post.id
          expect(response).to redirect_to @post
        end
      end
    end

    context 'when no user is signed in' do
      context 'with valid params' do
        it 'does not create a new Comment' do
          expect do
            post :create, comment: attributes_for(:comment), post_id: @post.id
          end.not_to change(Comment, :count)
        end

        it 'redirects to the sign_in page' do
          post :create, comment: attributes_for(:comment), post_id: @post.id
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @post = create(:post)
      @comment = create(:comment, post: @post)
      @commenter = @comment.user
    end

    context 'when the user is signed in' do
      before do
        sign_in(@commenter)
      end

      it 'deletes the Comment' do
        expect do
          delete :destroy, id: @comment.id, post_id: @post.id
        end.to change(Comment, :count).by(-1)
      end

      it 'redirects to the parent post' do
        delete :destroy, id: @comment.id, post_id: @post.id
        expect(response).to redirect_to(@post)
      end

      it 'only deletes one Comment' do
        other_comment = create(:comment, post: @post, user: @commenter)

        expect do
          delete :destroy, id: @comment.id, post_id: @post.id
        end.to change(Comment, :count).by(-1)
        expect(other_comment).to be_persisted
      end
    end

    context 'when no user is signed in' do
      it 'does not delete the Comment' do
        expect do
          delete :destroy, id: @comment.id, post_id: @post.id
        end.not_to change(Comment, :count)
      end

      it 'redirects to the sign_in page' do
        delete :destroy, id: @comment.id, post_id: @post.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when another user is signed in' do
      before do
        @user = create(:user)
        sign_in(@user)
      end

      it 'does not delete the Comment' do
        expect do
          delete :destroy, id: @comment.id, post_id: @post.id
        end.not_to change(Comment, :count)
      end

      it 'redirects to the post page' do
        delete :destroy, id: @comment.id, post_id: @post.id
        expect(response).to redirect_to @post
      end
    end
  end

  describe 'PUT #update' do
    context 'when the commenter is signed in' do
      before do
        @post = create(:post)
        @comment = create(:comment, post: @post)
        @commenter = @comment.user
        sign_in(@commenter)
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:comment, body: 'Something New')
        end

        it 'updates the requested comment' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          @comment.reload

          expect(@comment.body).to eq 'Something New'
        end

        it 'assigns the requested comment as @comment' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(assigns(:comment)).to eq(@comment)
        end

        it 'redirects to the post' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(response).to redirect_to(@post)
        end
      end

      context 'with invalid params' do
        let(:new_attributes) do
          attributes_for(:comment, body: nil)
        end

        it 'does not updates the requested comment' do
          old_body = @comment.body
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          @comment.reload

          expect(@comment.body).to eq old_body
        end

        it 'assigns the comment as @comment' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(assigns(:comment)).to eq(@comment)
        end

        it "re-renders the 'edit' template" do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when another user is logged in' do
      before do
        @post = create(:post)
        @comment = create(:comment, post: @post)
        @commenter = @comment.user
        @user = create(:user)
        sign_in(@user)
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:post, title: 'Something New')
        end

        it 'does not updates the requested post' do
          old_body = @comment.body

          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          @post.reload

          expect(@comment.body).to eq old_body
        end

        it 'flashes an authorization error' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(flash[:alert]).to match(/You are not authorized/)
        end

        it 'redirects to the root path' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(response).to redirect_to @post
        end
      end
    end

    context 'when no user is logged in' do
      before do
        @post = create(:post)
        @comment = create(:comment, post: @post)
        @commenter = @comment.user
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:post, title: 'Something New')
        end

        it 'does not updates the requested post' do
          old_body = @comment.body

          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          @comment.reload

          expect(@comment.body).to eq old_body
        end

        it 'redirects to the sign_in page' do
          put :update, id: @comment.id, post_id: @post.id, comment: new_attributes
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
