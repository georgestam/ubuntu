describe "Update alerts#show", js: true do

  sign_as
  
  context 'when user is signed-in as field user' do

    let!(:alert){ FactoryGirl.create :alert, user: user}
    let!(:issue){ FactoryGirl.create :issue, type_alert: alert.type_alert }
    let!(:reference_issue){ FactoryGirl.build :issue }

    def visit_my_alerts
      alert.user = user # Since alert has to users, FactoryGirl does not Assign properly the user
      alert.save!
      visit root_path
      find('#my_alerts').click 
    end 
    
    it "creates a new solution" do
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
    
    it "shows an alert as a resolved if a solution is selected and marked as resolved" do  
      visit_my_alerts
      
      first('.fa-check').click
      find('#alert_issue').find(:xpath, "option[3]").select_option #write your own solution
      find('#resolved_').find(:xpath, "option[2]").select_option
      find('#submit-button').click
      
      expect(alert.reload.resolved?).to eq true
    end
    
    it "does not show the alert as a resolved if there is not text in the solution" do
      visit_my_alerts
      
      first('.fa-check').click
      find('#alert_issue').find(:xpath, "option[2]").select_option #write your own solution
      find("#resolved_description").set ""
      find('#resolved_').find(:xpath, "option[2]").select_option
      
      expect{find('#submit-button').click}.not_to change(Issue, :count)

      expect(alert.reload.resolved?).to eq nil
    end
    
    it "marks an alert as a unresolved" do
    end 

  end

end