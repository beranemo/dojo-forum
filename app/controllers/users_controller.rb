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

  private

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end
  
end
