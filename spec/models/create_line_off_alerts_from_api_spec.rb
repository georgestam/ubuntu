describe Alert do
  
  let(:line_off_type_alert) { FactoryGirl.create :type_alert, name: "Line is off" }
  
  it 'creates alerts for customers with line off from api' do
    
    # create line of issue
    FactoryGirl.create :issue, type_alert: line_off_type_alert
    
    # create customers
    Customer.update_customer_db
    
    expect { 
      Alert.create_alert_for_customers_with_line_off
    }.to change { 
      Alert.count
    }.from(0).to(1)
    
  end 

end 
  