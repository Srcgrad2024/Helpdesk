# Controller for managing comments in the admin dashboard
class Admin::CommentsController < ApplicationController
  # Ensure user is authenticated and is an admin
  before_action :authenticate_user!
  before_action :authorize_admin!

  # Create a new comment for a ticket
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to admin_tickets_path, notice: "Comment added."
    else
      redirect_to admin_tickets_path, alert: "Failed to add comment."
    end
  end

  # Private methods for strong parameters and authorization
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  # Authorization check for admin users
  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
