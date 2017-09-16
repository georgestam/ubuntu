describe "Display pages#info" do

  context 'when user is signed-in as a manager' do 
  
    sign_as :manager
    
    it 'displays main info' do
      visit root_path
      find("#info").click
      expect(page).to have_selector('#notes')
    end
    
  end

end 