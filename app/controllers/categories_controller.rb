class CategoriesController < ApplicationController
  
  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @posts = @category.posts.where(status: "craft").order(id: :desc).page(params[:page]).per(20)
  end
end
