describe "Display my alerts in pages#index" do

  context 'when user is signed-in as a manager' do 
  
    sign_as :manager

    let!(:group_alert){ FactoryGirl.create :group_alert, user: user }
    let!(:type_alert){ FactoryGirl.create :type_alert, group_alert: group_alert }
    let!(:alert){ FactoryGirl.create :alert, created_by_id: user.id, type_alert: type_alert }

    def the_action
      visit root_path
      find("#my_alerts").click
    end

    it 'displays main info' do
      the_action
      expect(page).to have_selector('#show_my_alerts', visible: :all)
    end

    it 'displays one open alert' do
      the_action
      expect(page).to have_selector('#my_open_alert', count: 1)  
    end
    
  end

end 