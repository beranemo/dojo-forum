class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  impressionist actions: [:show]
  
  def index
    @posts = Post.page(params[:page]).per(20)
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
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
    @comments = @post.comments.page(params[:page]).per(20)
    @comment = Comment.new
    impressionist(@post, "message...")
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

end
