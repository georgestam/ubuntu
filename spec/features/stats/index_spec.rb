describe "Display Stats#index" do

  before {
    Customer.update_customer_db # upload the example tests data
    PullUsageJob.perform_now # upload the example tests data
  }

  context 'when user is signed-in as a field user' do 
  
    sign_as
    
    def same_actions
      FactoryGirl.create_list(:alert, 3)
      visit root_path
      find("#stats").click
    end 
    
    it 'displays main graphs' do
      same_actions
      find("#user-tab").click
      expect(page).to have_selector('#total-alerts-by_user')
    end
    
    it 'displays montlhy graphs' do
      same_actions
      find("#usage-tab").click
      find("#montly_graphs").click
      expect(page).to have_selector('#chart-1') # show montly hourly chart
    end
    
  end

end 