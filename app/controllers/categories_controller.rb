class CategoriesController < ApplicationController
  
  def show
    @categories = Category.all
    @category = Category.find(params[:id])
     
    @order_tag = params[:tag]
    
    if user_signed_in?
      if @order_tag == "last_comment_time"
        @posts = @category.posts.where(status: "craft").check_who_can_see(current_user).order(last_comment_time: :desc).page(params[:page]).per(20)
      elsif @order_tag == "comments_count"
        @posts = @category.posts.where(status: "craft").check_who_can_see(current_user).order(comments_count: :desc).page(params[:page]).per(20)
      elsif @order_tag == "impressionist_count"
        @posts = @category.posts.where(status: "craft").check_who_can_see(current_user).order(impressionist_count: :desc).page(params[:page]).per(20)
      else
        @posts = @category.posts.where(status: "craft").check_who_can_see(current_user).order(id: :desc).page(params[:page]).per(20)
      end
    else
      if @order_tag == "last_comment_time"
        @posts = @category.posts.where(status: "craft", who_can_see: "all").order(last_comment_time: :desc).page(params[:page]).per(20)
      elsif @order_tag == "comments_count"
        @posts = @category.posts.where(status: "craft", who_can_see: "all").order(comments_count: :desc).page(params[:page]).per(20)
      elsif @order_tag == "impressionist_count"
        @posts = @category.posts.where(status: "craft", who_can_see: "all").order(impressionist_count: :desc).page(params[:page]).per(20)
      else
        @posts = @category.posts.where(status: "craft", who_can_see: "all").order(id: :desc).page(params[:page]).per(20)
      end
    end
  end
end
