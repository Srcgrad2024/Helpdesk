# Controller for managing user profiles
class Users::ProfileController < ApplicationController
  # Ensure the user is authenticated before accessing profile actions
  before_action :authenticate_user!

  # Show the current user's profile
  def show
    @user = current_user
  end

  # Edit the current user's profile
  def edit
    @user = current_user
  end

  # Update the current user's profile
  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Private parameters for profile update
  private

  # Permitted parameters for profile update
  def profile_params
    params.require(:user).permit(:name, :surname, :contact)
  end
end
