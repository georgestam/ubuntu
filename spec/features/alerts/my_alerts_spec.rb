describe "Display my alerts in pages#index" do

  context 'when user is signed-in as a manager' do 
  
  sign_as :manager

  let!(:alert){ FactoryGirl.create :alert }

  def the_action
    visit root_path
    find("#my_alerts").click
  end

  it 'displays main info' do
    the_action
    expect(page).to have_selector('#show_my_alerts', visible: :all)
  end

    #  it 'displays one open alert' do
    #    the_action
    #    expect(find("#my_open_alert", visible: :all).count).to eq 1    
    # end
    
  end

end 