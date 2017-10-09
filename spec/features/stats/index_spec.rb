describe "Display Stats#index", js: true do

  before {
    Customer.update_customer_db 
    PullUsageJob.perform_now 
  }

  context 'when user is signed-in as a field user' do 
  
    sign_as
    
    def same_actions
      FactoryGirl.create_list(:alert, 2)
      visit root_path
      find("#stats").click
    end 
    
    it 'displays main graphs' do
      same_actions
      find("#user-tab").click
      expect(page).to have_selector('#total-alerts-by_user')
    end
    
    it 'displays usage graphs' do
      same_actions
      find("#include-usage").set(true)
      find("#update-stats").click
      find("#usage-tab").click
      expect(page).to have_selector('#total-usage-cumulative')
    end
    
  end

end 