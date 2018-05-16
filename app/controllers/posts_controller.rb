class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  impressionist actions: [:show]
  
  def index
    @categories = Category.all
    
    @order_tag = params[:tag]
    
    if user_signed_in?
      if @order_tag == "last_comment_time"
        @posts = Post.all.where(status: "craft").check_who_can_see(current_user).order(last_comment_time: :desc).page(params[:page]).per(20)
      elsif @order_tag == "comments_count"
        @posts = Post.all.where(status: "craft").check_who_can_see(current_user).order(comments_count: :desc).page(params[:page]).per(20)
      elsif @order_tag == "impressionist_count"
        @posts = Post.all.where(status: "craft").check_who_can_see(current_user).order(impressionist_count: :desc).page(params[:page]).per(20)
      else
        @posts = Post.all.where(status: "craft").check_who_can_see(current_user).order(id: :desc).page(params[:page]).per(20)
      end
    else
      if @order_tag == "last_comment_time"
        @posts = Post.all.where(status: "craft", who_can_see: "all").order(last_comment_time: :desc).page(params[:page]).per(20)
      elsif @order_tag == "comments_count"
        @posts = Post.all.where(status: "craft", who_can_see: "all").order(comments_count: :desc).page(params[:page]).per(20)
      elsif @order_tag == "impressionist_count"
        @posts = Post.all.where(status: "craft", who_can_see: "all").order(impressionist_count: :desc).page(params[:page]).per(20)
      else
        @posts = Post.all.where(status: "craft", who_can_see: "all").order(id: :desc).page(params[:page]).per(20)
      end
    end
  end
  
  def new
    @post = Post.new
  end
   
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # "commit"=>"暫存成草稿", "controller"=>"posts"
    if params[:commit] == "暫存成草稿"
      @post.status = "draft"
    else
      @post.status = "craft"
    end
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
    
    if @post.status == "draft" && @post.user != current_user
      flash[:alert] = "您無此權限做此操作"
      redirect_to root_path
    else
      @comments = @post.comments.page(params[:page]).per(20)
      @comment = Comment.new
      impressionist(@post, "message...")
    end 
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if params[:commit] == "草稿儲存"
      @post.status = "draft"
    else
      @post.status = "craft"
    end
    @post.update(post_params)
    if params[:from_type] == "1"
      redirect_to user_path(@post.user)
    else
      redirect_to post_path(@post)
    end
    #redirect_back(fallback_location: root_path)  # 導回上一頁
  end
  
  def favorite
    @post = Post.find(params[:id])
    favorites = Favorite.where(post: @post, user: current_user)
    if favorites.exists?
      # flash[:alert] = "已被收藏"
    else
      @post.favorites.create!(user: current_user)
      # flash[:notice] = "文章收藏成功"
    end
    # redirect_back(fallback_location: root_path)  # 導回上一頁
  end

  def unfavorite
    @post = Post.find(params[:id])
    favorites = Favorite.where(post: @post, user: current_user)
    favorites.destroy_all
    # flash[:alert] = "已取消收藏文章"
    # redirect_back(fallback_location: root_path)  # 導回上一頁
  end
  
  def template_unfavorite
    @post = Post.find(params[:id])
    favorites = Favorite.where(post: @post, user: current_user)
    favorites.destroy_all
    flash[:alert] = "已取消收藏文章"
    redirect_back(fallback_location: root_path)  # 導回上一頁
  end
  
  def feeds
    @users_count = User.count
    @posts_count = Post.count
    @comments_count = Comment.count
    
    @hot_users = User.all.order(comments_count: :desc).limit(10)
    @hot_posts = Post.all.order(comments_count: :desc).limit(10)
  end
  
  private
  def post_params
    params.require(:post).permit(:title, :content, :image, :who_can_see, category_ids: [])
  end
  

end
