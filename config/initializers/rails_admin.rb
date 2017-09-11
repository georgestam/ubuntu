RailsAdmin.config do |config|
  
  config.label_methods << :custom_label_method
  
  
  
  config.model GroupAlert do
    weight -1
  end
  
  config.model TypeAlert do
    weight 0
  end
  
  config.model Issue do
    label "Solutions"
    weight 1
  end
  
  config.model Alert do
    weight 2
    edit do
      field :group_and_type
      field :customer
      field :assigned_to
      field :created_by
      field :issue do
        label "Solution"
      end
      field :resolved_comments do
        label "Solution notes"
      end
      field :resolved_at 
      
      field :status_id
      field :description
    end
    list do
      field :id do
        column_width 30
      end 
      field :group_and_type do
        column_width 200
        formatted_value do 
          value.to_s
        end
        column_width 120
      end
      field :customer do
        column_width 120
      end 
      field :assigned_to do
        column_width 100
      end 
      field :created_by do
        column_width 100
      end 
      field :created_at do
        column_width 200
      end
      field :issue do
        label "Solution"
        column_width 200
      end
      field :resolved_comments do
        label "Solution notes"
        column_width 200
      end
      field :resolved_at do
        column_width 200
      end
      
      field :status_id
      field :description
    end
  end
  
  config.model Customer do
    weight 3
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
  
  config.model Status do
    visible false
  end
  
  
    
  config.model User do
    weight 4
    edit do
      field :name        
      field :email
      field :role, :enum do 
        enum_method do
          :role_enum
        end
      end 
      field :password, :password 
      field :password_confirmation, :password 
    end
    list do
      field :id
      field :name        
      field :email
      field :role, :enum do 
        enum_method do
          :role_enum
        end
      end 
    end
  end 
  
  config.parent_controller = '::ApplicationController'

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with { warden.authenticate! scope: :user }
  config.current_user_method(&:current_user)
  
  # config.authorize_with do |controller|
  #   redirect_to main_app.root_path unless current_user && current_user.admin
  # end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  config.authorize_with :pundit

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


