class Admin::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @tickets = Ticket.includes(:user).order(created_at: :desc)
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
