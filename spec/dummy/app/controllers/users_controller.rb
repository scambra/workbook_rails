class UsersController < ApplicationController
  respond_to :xlsx, :html

  def show
    @user = User.find(params[:id])
    respond_with(@user) do |format|
      format.xlsx { render "respond_with" }
    end
  end

  def send_instructions
    @user = User.find(params[:user_id])
    @user.send_instructions
    render plain: "Email sent"
  end
end
