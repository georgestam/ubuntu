RailsAdmin.config do |config|

  config.label_methods << :custom_label_method

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

  config.model GroupAlert do
    navigation_label 'Alerts'
    weight -1
  end

  config.model TypeAlert do
    navigation_label 'Alerts'
    weight 0
  end

  config.model Issue do
    navigation_label 'Alerts'
    weight 1
    list do
      field :type_alert
      field :alerts
      field :resolution
    end

  end

  config.model Alert do
    navigation_label 'Alerts'
    weight 2
    edit do
      field :type_alert
      field :customer
      field :user
      field :created_by
      field :issue do
        label "Solution (please save and edit the field again if the Type Alert has changed)"
        associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          issue = bindings[:object]
          Proc.new { |scope|
            # scoping all Players currently, let's limit them to the team's league
            # Be sure to limit if there are a lot of Players and order them by position
            scope.where(type_alert_id: issue.type_alert_id) if issue.present?
          }
        end
      end
      field :resolved_comments do
        label "notes"
      end
      field :resolved_at
    end
    list do
      scopes %i[all_open all_resolved my_open my_resolved]
      field :id do
        column_width 30
      end
      field :group_alert do
        column_width 200
        formatted_value do
          bindings[:object].title
        end
        column_width 120
      end
      field :type_alert do
        column_width 200
        formatted_value do
          value.to_s
        end
        column_width 120
      end
      field :customer do
        column_width 120
      end
      field :user do
        column_width 100
      end
      field :created_by do
        column_width 100
      end
      field :created_at do
        column_width 200
      end
      field :issue do
        column_width 200
      end
      field :resolved_comments do
        label "Notes"
        column_width 200
      end
      field :resolved_at do
        column_width 200
      end
    end
  end

  config.model Customer do
    weight 3
    list do
      field :id
      field :alerts 
      field :ignore_alerts
      field :telephone
      field :first_name
      field :last_name
      field :id_steama
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
      field :slack_username
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
      field :slack_username
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

end


