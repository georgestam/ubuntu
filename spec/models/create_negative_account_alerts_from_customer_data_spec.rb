describe Balance do
  
  it 'creates balances from costumers' do
    FactoryGirl.create_list(:customer, 4)
    
    expect { 
      Balance.update_balance
    }.to change { 
      Balance.count
    }.from(0).to(4)
    
  end 
  
  it 'creates alerts from balances' do
    # create type of alert 'Customer has negative account' as it is a requeried field to assign alerts
    negative_acount = FactoryGirl.create :type_alert, name: "Negative account"
    FactoryGirl.create :issue, type_alert: negative_acount 
    
    # this should create one alert
    customer = FactoryGirl.create :customer
    FactoryGirl.create :balance, :four_days_ago, :negative_acount, customer: customer
    FactoryGirl.create :balance, :negative_acount, customer: customer
    
    # this should not create any alert
    2.times do 
      FactoryGirl.create :balance, :four_days_ago, :negative_acount
      FactoryGirl.create :balance, :negative_acount
    end 
    
    expect { 
      Alert.check_customers_with_negative_acount
    }.to change { 
      Alert.count
    }.from(0).to(1)
    
  end 

end 