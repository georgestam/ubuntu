class User < ApplicationRecord
  acts_as_token_authenticatable
  
  LANGUAGES = %w[ar en].freeze
  ROLES = %w[manager super field].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :email, email_format: { message: "doesn't look like an email address" }, presence: true
  validates :manager, inclusion: [ROLES]
  
  def roles_enum
     ROLES
  end
  
end


