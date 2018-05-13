class Api::V1::PostsController < ApiController
  def index
    @posts = Post.all
    render json: {
      data: @posts
    }
  end
  
  def show
    @post = Post.find_by(id: params[:id])
    if !@post
      render json: {
        message: "Can't find the post!",
        status: 400
      }
    else
      render json: {
      title: @post.title,
      content: @post.content
    }
    end
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      render json: {
        message: "Post created successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end
  
  def update
    @post = post.find_by(id: params[:id])
    if @post.update(post_params)
      render json: {
        message: "Post updated successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end
  
  private

  def post_params
    params.permit(:title, :content, :image)
  end  
end
