class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end
  
  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
  end
  
  def collects
    @user = User.find(params[:id])
    @collects = @user.favorited_posts
  end
  
  def drafts
    @user = User.find(params[:id])
    @posts = Post.all.where(status: "draft").order(id: :desc)
  end
  
  def friends
    @user = User.find(params[:id])
    
    # 送出好友邀請，想要他成為好友
    @wanted_friends = @user.friends - @user.want2yous
    
    # 想要你成為他好友的人
    @want2yous = @user.want2yous - @user.friends
    
    # 互相為好友的人
    @befrinds = @user.want2yous & @user.friends
  end

  private

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end
  
end
