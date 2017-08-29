describe "Update Database from steama API and create alerts", js: true do 
  
  context 'when user is signed-in as admin user' do 
  
    sign_as :admin
    
    it 'shows an alert of the main page' do
      visit root_path
      find("#update-database-button").click
      expect(page).to have_selector('.alert-dismissible')
    end
    
  end
  
end