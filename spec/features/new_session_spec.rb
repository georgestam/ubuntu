describe "User Logging in" do 
  
  before {
    visit root_path
  }
    
  context "when the user goes to login page" do
    
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
  
end