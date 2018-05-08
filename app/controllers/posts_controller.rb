class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  
  def index
    @posts = Post.all
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "文章已成功新增"
      redirect_to root_path
    else
      flash.now[:alert] = "文章新增失敗"
      render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end

end
