class UsersController < ApplicationController
  before_action :authenticate_user, only: [:edit, :update, :show, :destory]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def create
    @user = User.new user_params
    if @user.save
      auth_token = Knock::AuthToken.new payload: { sub: @user.id }
      render json: {status: 200, msg: 'User was created.'}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :password, :passwod_confirmation)
    end
end
