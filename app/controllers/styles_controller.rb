class StylesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_admin, only: :destroy
  before_action :set_style, only: [:edit, :update, :show, :destroy]

  def index
    @styles = Style.all
  end

  def new
    @style = Style.new
  end

  def edit
  end

  def show
  end

  def create
    @style = Style.new(style_params)

    if current_user.nil?
      redirect_to signin_path, notice: "you should sign in to create styles"
    elsif @style.save
      redirect_to @style
    else
      render :new
    end
  end

  def update
    if @style.update(style_params)
      redirect_to @style, notice: 'Style was successfully updated!'
    else
      redirect_to edit_style_path @style
    end
  end

  def destroy
    unless current_user.nil?
      @style.delete
      redirect_to styles_path
    else
      redirect_to signin_path, notice: "you should sign in to create styles"
    end
  end

  private
    def set_style
      @style = Style.find(params[:id])
    end

    def style_params
      params.require(:style).permit(:name, :description)
    end
end