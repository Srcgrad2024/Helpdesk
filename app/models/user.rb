# Model to manage users in the application
class User < ApplicationRecord
  # Include default devise modules for authentication and user management features
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
  
  # User can have many tickets; if user is deleted, tickets are not deleted but their user reference is nullified
  has_many :tickets, dependent: :nullify
  # enum role: { user: 0, admin: 1 }
end
