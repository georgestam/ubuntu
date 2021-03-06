describe "Pull database from steama API and create alerts" do 
  
  context 'when user is signed-in as admin user' do 
  
    sign_as :manager
    
    before {
      visit root_path 
    }
  
    it 'shows a notification on the main page' do
      find("#update-database-button").click
      expect(page).to have_selector('.alert-dismissible')
    end
    
    it 'create new users customers' do
      
      expect { 
        find('#update-database-button').click
      }.to change { 
        Customer.count 
      }.from(0).to(10)
    end
    
    it 'create alerts sudden_drop_in_balance' do
      FactoryGirl.create :type_alert, name: "Sudden high drop in account balance"
      find('#update-database-button').click
      
      Customer.first.update_attributes({  
          account_balance: "20000"
          })
      
      expect { 
        find('#update-database-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1)
    end
    
  end
  
end