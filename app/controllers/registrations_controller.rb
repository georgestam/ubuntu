class RegistrationsController < Devise::RegistrationsController
  respond_to :json, only: [:create]
  
  def sign_up_params
   params.require(:user).permit(:name, :email, :password)
  end

end 
