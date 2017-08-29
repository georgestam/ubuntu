describe "Display rails admin" do 
  
  context 'when user is signed-in as admin user' do 
  
    sign_as :admin
    
    it 'displays main panel' do
      visit root_path
      find("#admin-panel-button").click 
      expect(page).to have_selector('.rails_admin')
    end
    
  end
  
  context 'when user is signed-in as field user' do 
  
    sign_as
    
    it 'does not display rails_admin and redirects to alerts#new' do
      visit '/admin'
      expect(page).to have_selector('#alerts-new') 
    end
    
  end
  
end