describe "Create alerts#new", js: true do

  context 'when user is signed-in as field user' do

    let!(:group_alert){ FactoryGirl.create :group_alert }
    let!(:type_alert){ FactoryGirl.create :type_alert, group_alert: group_alert }
    let!(:issue){ FactoryGirl.create :issue, type_alert: type_alert }
    let!(:customer){ FactoryGirl.create :customer }

    let!(:reference_type_alert){ FactoryGirl.build :type_alert }
    let!(:reference_issue){ FactoryGirl.build :issue }
    let!(:reference_alert){ FactoryGirl.build :alert }

    sign_as

    def customer_and_created_by_setting
      find('#alert_customer_id').find(:xpath, "option[2]").select_option
      find('#alert_created_by').find(:xpath, "option[2]").select_option
      find('#group_alert').find(:xpath, "option[2]").select_option
    end

    it 'creates only a new alert if issue existed' do
      visit root_path

      # TODO: ajax calls not working for type alert (which is the same structure for group alert!). Perhaps 2 ajax calls are not allowed in capybara

      # customer_and_created_by_setting
      # find('#group_alert').find(:xpath, "option[2]").select_option
      # sleep 3
      # find('#type_alert').find(:xpath, "option[1]").select_option
      # sleep 3
      # find('#issue').find(:xpath, "option[1]").select_option
      #
      # expect {
      #   find('#submit-button').click
      # }.to change {
      #   Alert.count
      # }.from(0).to(1)
    end

    it 'creates an new alert and issue if issue does not exist' do
      visit root_path

      customer_and_created_by_setting

      find('#type_alert').find(:xpath, "option[3]").select_option # select a type of alert
      find('#issue').find(:xpath, "option[2]").select_option # select and issue

      expect {
        find('#submit-button').click
      }.to change {
        Alert.count
      }.from(0).to(1).and change {
        Issue.count
      }.from(1).to(2)
    end

    it "creates an alert 'open', issue and type_alert if type_alert does not exist" do
      visit root_path

      customer_and_created_by_setting
      # select a 'new' issue
      find('#type_alert').find(:xpath, "option[2]").select_option

      find("#description_new_alert").set reference_type_alert.name

      expect {
        find('#submit-button').click
      }.to change {
        Alert.count
      }.from(0).to(1).and change {
        TypeAlert.count
      }.from(3).to(4)

      expect(Alert.last.try(:resolved?)).to be nil

    end

    it 'does not create an alert if a solution exist' do
      visit root_path

      customer_and_created_by_setting

      # select a 'new' issue
      find('#type_alert').find(:xpath, "option[3]").select_option
      find('#issue').find(:xpath, "option[3]").select_option # select solution

      expect{find('#submit-button').click}.not_to change(Alert, :count)

    end

    it "creates an alert if a solution 'is not in the list" do
      visit root_path

      customer_and_created_by_setting

      # select a 'new' issue
      find('#type_alert').find(:xpath, "option[3]").select_option
      find('#issue').find(:xpath, "option[2]").select_option # select "it is not in the list"

      expect {
        find('#submit-button').click
      }.to change {
        Alert.count
      }.from(0).to(1)

    end

  end

end