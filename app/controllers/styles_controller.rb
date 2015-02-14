class StylesController < ApplicationController
  def index
    @styles = Style.all
  end

  def new
    @style = Style.new
  end

  def show
    @style = Style.find(params[:id])
  end

  def create
    @style = Style.new params.require(:style).permit(:name, :descriptiom)

    if current_user.nil?
      redirect_to signin_path, notice: "you should sign in to create styles"
    elsif @style.save
      redirect_to @style
    else
      render :new
    end
  end

  def destroy
    unless current_user.nil?
      style = Style.find(params[:id])
      style.delete
      redirect_to styles_path
    else
      redirect_to signin_path, notice: "you should sign in to create styles"
    end
  end
end