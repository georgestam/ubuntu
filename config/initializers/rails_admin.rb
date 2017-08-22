RailsAdmin.config do |config|
  
  config.label_methods << :custom_label_method
  
  config.model Customer do
    list do
      field :id
      field :id_steama         
      field :telephone
      field :first_name
      field :last_name
      field :description
      field :account_balance
      field :low_balance_warning
      field :low_balance_level
      field :line_number
      field :language
    end
  end
  
  config.model Alert do
    list do
      field :id
      field :customer 
      field :type_alert
      field :description
      field :status
      field :resolved_comments
      field :created_by
      field :created_at do
        column_width 30
      end
      field :updated_at do
        column_width 30
      end
    end
  end
  
  config.parent_controller = '::ApplicationController'

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with { warden.authenticate! scope: :user }
  config.current_user_method(&:current_user)
  
  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user && current_user.admin
  end
  
  # config.authorize_with do |controller|
  #   redirect_to main_app.root_path unless current_user && current_user.admin
  # end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end


