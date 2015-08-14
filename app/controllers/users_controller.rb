class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Thank you for registration.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:password]=='' || params[:password_confirmation]=='' || params[:old_password]==''
      redirect_to edit_user_path(@user), notice: 'Fill the fields'
    elsif @user.authenticate(params[:old_password])
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to magazine_url, notice: 'Password was changed' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to edit_user_path(@user), notice: 'Wrong old password'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user!=User.find_by_id(session[:user_id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: "User \"#{@user.name}\" deleted" }
        format.json { head :no_content }
      end
    else
      redirect_to users_url, notice: 'This is your user!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
