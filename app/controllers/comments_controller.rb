class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!
  before_action :authorize_ownership!, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @post, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { head status: :unprocessable_entity }
      end
    end
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post = @post

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_to @post }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue
    redirect_to :root
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_ownership!
    @comment = current_user.comments.find_by(params.permit(:id, :post_id))
    return unless @comment.nil?
    redirect_to @post
    flash[:alert] = 'You are not authorized to perform that operation'
  end
end
