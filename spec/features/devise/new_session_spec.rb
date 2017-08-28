describe "User Logging in" do 
    
  context "when the user goes to login page" do
    
    before {
      visit root_path
    }
    
    let!(:password){ "password10" }
    let!(:reference_user){ FactoryGirl.create :user, password: password }
    
    it "shows the login page" do
      expect(page).to have_selector :css, '#login'
    end
    
    it 'creates a new session' do
      find("#user_email").set reference_user.email
      find("#user_password").set password
      
      expect { 
        find('#sign_in').click
      }.to change { 
        User.last.sign_in_count
      }.from(0).to(1)
    end 
    
  end 
  
  context 'when user is signed-in as admin user' do 
  
    sign_as :admin
    
    it 'displays main panel' do
      visit root_path
      expect(page).to have_selector('#main-panel')
    end
    
  end
  
  context 'when user is signed-in as field user' do 
  
    sign_as
    
    it 'displays new alert form' do
      visit root_path
      expect(page).to have_selector('#alerts-new')
    end
    
  end
  
end