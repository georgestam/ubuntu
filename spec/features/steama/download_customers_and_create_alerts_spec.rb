describe "Update database from steama API and create alerts" do 
  
  context 'when user is signed-in as admin user' do 
  
    sign_as :manager
    
    before {
      visit root_path  
    }
  
    it 'shows a notification on the main page' do
      find("#update-database-button").click
      expect(page).to have_selector('.alert-dismissible')
    end
    
    it 'create new users and alerts' do
      expect { 
        find('#update-database-button').click
      }.to change { 
        Alert.count 
      }.from(0).to(1).and change { 
        Customer.count 
      }.from(0).to(10)
    end
    
  end
  
end