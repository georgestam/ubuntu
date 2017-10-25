describe Topup do
  
  let!(:customer){ FactoryGirl.create :customer }
  
  it 'creates topups from api' do
    expect { 
      Topup.update_topups_from_api
    }.to change { 
      Topup.count
    }.from(0).to(4)
    
  end 

end 
  