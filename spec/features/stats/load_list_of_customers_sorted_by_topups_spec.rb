describe "Load List of customers sorted by sum of topups" do 
  
  context 'when user is signed-in as admin user' do 
  
    sign_as :manager
    
    it 'load lists' do
      visit root_path 
      find('#update-database-button').click
      find("#stats").click
      find("#top-up").click
      find("#display-customers").click
      expect(page).to have_selector('.tariff_text')
    end
    
  end
  
end