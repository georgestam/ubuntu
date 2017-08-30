describe "Create alerts#new" do 
    
  context 'when user is signed-in as field user' do 
    
    let!(:status){ FactoryGirl.create :status }
    let!(:type_alert){ FactoryGirl.create :type_alert }
    let!(:customer){ FactoryGirl.create :customer }
    let!(:reference_alert){ FactoryGirl.build :alert }
  
    sign_as
    
    it 'creates a new alert if all fields are completed' do
      visit root_path
      
      find('#alert_customer_id').find(:xpath, "option[2]").select_option
      find('#alert_type_alert_id').find(:xpath, "option[2]").select_option
      find("#alert_description").set reference_alert.description
      find('#alert_status_id').find(:xpath, "option[2]").select_option
      find("#alert_resolved_comments").set reference_alert.resolved_comments
      find("#alert_created_by").set reference_alert.created_by
      find("#alert_assigned_to").set reference_alert.assigned_to
     
      expect { 
        find('#submit-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1)
    end
    
    it 'does not create an alert if customer is not selected' do
      visit root_path
      
      find('#alert_type_alert_id').find(:xpath, "option[2]").select_option
      find("#alert_description").set reference_alert.description
      find('#alert_status_id').find(:xpath, "option[2]").select_option
      find("#alert_resolved_comments").set reference_alert.resolved_comments
      find("#alert_created_by").set reference_alert.created_by
      find("#alert_assigned_to").set reference_alert.assigned_to
      
      expect { find('#submit-button').click }.to_not change(Alert, :count)
    end
    
  end
  
end