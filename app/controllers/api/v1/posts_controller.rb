class Api::V1::PostsController < ApiController
  def index
    @posts = Post.all
    render json: {
      data: @posts
    }
  end
  
  def show
    @post = Post.find(params[:id])
    render json: {
      title: @post.title,
      content: @post.content
    }
  end
end
