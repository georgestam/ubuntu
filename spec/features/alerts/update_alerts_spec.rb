describe "Update alerts#show", js: true do

  sign_as
  
  context 'when user is signed-in as field user' do

    let!(:alert){ FactoryGirl.create :alert, user: user}
    let!(:issue){ FactoryGirl.create :issue, type_alert: alert.type_alert }
    let!(:reference_issue){ FactoryGirl.build :issue }

    def visit_my_alerts
      visit root_path
      find('#my_alerts').click 
    end 
    
    it "creates a new solution" do
      alert.user = user # Since alert has to users, FactoryGirl does not Assign properly the user
      alert.save!
      
      visit_my_alerts
      
      first('.fa-check').click
      find('#alert_issue').find(:xpath, "option[2]").select_option #write your own solution
      find("#resolved_description").set reference_issue.resolution
      
      expect {
        find('#submit-button').click
      }.to change {
        Issue.count
      }.from(1).to(2)

      expect(Issue.last.resolution).to eq reference_issue.resolution
    end 
    
    it "shows an alert as a resolved if an solution is selected and marked as resolved" do  
    end
    it "does not show the alert as a resolved if there is not text in the solution" do
    end
    it "marks an alert as a unresolved" do
    end 

  end

end