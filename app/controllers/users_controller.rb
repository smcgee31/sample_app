class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      login @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # this is the same as `redirect_to user_url(@user)`
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end