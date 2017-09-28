describe "Display Stats#index", js: true do

  context 'when user is signed-in as a manager' do 
  
    sign_as :manager
    
    it 'displays main graphs' do
      FactoryGirl.create_list(:alert, 3)
      visit root_path
      find("#stats").click
      find("#user-tab").click
      expect(page).to have_selector('#total-alerts-by_user')
    end
    
  end
  
  context 'when user is signed-in as a field user' do 
  
    sign_as
    
    it 'displays main graphs' do
      FactoryGirl.create_list(:alert, 3)
      visit root_path
      find("#stats").click
      find("#user-tab").click
      expect(page).to have_selector('#total-alerts-by_user')
    end
    
  end

end 