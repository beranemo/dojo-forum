class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
    @post.last_comment_time = Time.now
    @post.save
    redirect_to post_path(@post)
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    if current_user.id == @comment.user.id
      @comment.destroy
      redirect_to post_path(@post)
      # redirect_back(fallback_location: root_path)  # 導回上一頁
    end
  end
  
  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to post_path(@post)    
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
