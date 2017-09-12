module RailsAdmin
  module Config
    module Actions
      
      class Edit < RailsAdmin::Config::Actions::Base
        
        register_instance_option :member? do
          true
        end
        
        register_instance_option :http_methods do
          [:get, :post]
        end
        
        register_instance_option :pjax? do
          false
        end
        
        register_instance_option :bulkable? do
          false
        end
        
        register_instance_option :link_icon do
          'fa fa-times'
        end
        
        register_instance_option :controller do
          Proc.new do
            model_name = nil
            if @object.is_a?(Alert)
              @alert = @object
              model_name = 'alert'
            else
              raise "Alert @object expected"
            end
            
            if request.get?
              render :edit
            end
          end
        end
      end
    end
  end
end