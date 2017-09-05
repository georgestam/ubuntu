class User < ApplicationRecord
  acts_as_token_authenticatable
  
  LANGUAGES = %w[ar en].freeze
  ROLES = %w[manager super_user field_user].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :email, email_format: { message: "doesn't look like an email address" }, presence: true
  validates :role, inclusion: { in: ROLES }
  validates :name, presence: true
  
  def role_enum
     ROLES
  end
  
  def manager?
    self.role == "manager"
  end 
  
  def super_user?
    self.role == "super_user"
  end 
  
  def field_user?
    self.role == "field_user"
  end 
  
end


