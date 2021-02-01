class PrototypesController < ApplicationController
before_action :set_prototype, only: [:edit, :show]
before_action :authenticate_user!, only: [:create, :update, :destroy]
before_action :move_to_show,  only: :edit

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
    @prototype.save
  end

  def create
    @prototype = Prototype.new(prototype_params) 
    @prototype.save
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_show
    prototype = @prototype.user.id
    user = current_user.id
    unless user == prototype
      redirect_to action: :show
    else
      render :edit
    end
  end
end
