class PrototypesController < ApplicationController
  before_action :authenticate_user!,only: [:new, :edit, :destroy] 

  def index
    @prototypes = Prototype.all
    if user_signed_in?
    @name = current_user.name
    end
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
    redirect_to prototypes_path
    else
    render :new
   end
  end

  def show
    @comment = Comment.new()
    @prototype = Prototype.find(params[:id])
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
    redirect_to prototype_path(@prototype.id)
    else
    render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to prototypes_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:name, :title, :image, :catch_copy, :concept).merge(user_id: current_user.id)
  end
end
