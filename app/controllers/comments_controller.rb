class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
    @post.last_comment_time = Time.now
    @post.save
    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
