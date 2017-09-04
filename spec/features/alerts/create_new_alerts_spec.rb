describe "Create alerts#new", js: true do 
    
  context 'when user is signed-in as field user' do 
    
    let!(:group_alert){ FactoryGirl.create :group_alert }
    let!(:type_alert){ FactoryGirl.create :type_alert, group_alert: group_alert }
    let!(:issue){ FactoryGirl.create :issue, type_alert: type_alert }
    let!(:customer){ FactoryGirl.create :customer }
    
    let!(:reference_type_alert){ FactoryGirl.build :type_alert }
    let!(:reference_issue){ FactoryGirl.build :issue }
    let!(:reference_alert){ FactoryGirl.build :alert }
  
    sign_as
    
    def customer_and_created_by_setting
      find('#alert_customer_id').find(:xpath, "option[2]").select_option
      find('#alert_created_by').find(:xpath, "option[2]").select_option
      find('#group_alert').find(:xpath, "option[2]").select_option
    end 
    
    it 'creates only a new alert if issue existed' do
      visit root_path
      
      # TODO: ajax calls not working for type alert (which is the same structure for group alert!). Perhaps 2 ajax calls are not allowed in capybara
      
      # customer_and_created_by_setting
      # find('#group_alert').find(:xpath, "option[2]").select_option
      # sleep 3
      # find('#type_alert').find(:xpath, "option[1]").select_option
      # sleep 3
      # find('#issue').find(:xpath, "option[1]").select_option
      # 
      # expect { 
      #   find('#submit-button').click
      # }.to change { 
      #   Alert.count 
      # }.from(0).to(1)
    end
    
    it 'creates an new alert and issue if issue does not exist' do
      visit root_path
            
      customer_and_created_by_setting
      sleep 3
      find('#type_alert').find(:xpath, "option[2]").select_option
      
      find("#resolved_description").set reference_issue.resolution
      
      expect { 
        find('#submit-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1).and change { 
        Issue.count 
      }.from(2).to(3)
    end
    
    it "creates an new 'open' alert, issue and type_alert if type_alert does not exist" do
      visit root_path
            
      customer_and_created_by_setting
      
      find("#description_new_alert").set reference_type_alert.name
      find("#resolved_description_new").set reference_issue.resolution
      
      expect { 
        find('#submit-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1).and change { 
        Issue.count 
      }.from(2).to(3).and change { 
        TypeAlert.count 
      }.from(3).to(4)
      
      expect(Alert.last.try(:resolved?)).to be nil

    end
    
    it 'creates a new alert marked as resolved' do
      visit root_path
            
      customer_and_created_by_setting
      
      find("#description_new_alert").set reference_type_alert.name
      find("#resolved_description_new").set reference_issue.resolution
      
      find('#status').find(:xpath, "option[2]").select_option
      
      expect { 
        find('#submit-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1)
      
      expect(Alert.last.try(:resolved?)).to be true
    end
    
    it 'does not create a new alert marked as resolved if resolved description is missing' do
      visit root_path
            
      customer_and_created_by_setting
      
      find("#description_new_alert").set reference_type_alert.name
      
      find('#status').find(:xpath, "option[2]").select_option
      
      expect { 
        find('#submit-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1)
      
      expect(Alert.last.try(:resolved?)).to be nil
    end
    
    it 'does not create an alert if customer is not selected' do
      visit root_path
      
      find("#description_new_alert").set reference_type_alert.name
      find("#resolved_description_new").set reference_issue.resolution
      
      expect { find('#submit-button').click }.to_not change(Alert, :count)
    end
    
  end
  
end