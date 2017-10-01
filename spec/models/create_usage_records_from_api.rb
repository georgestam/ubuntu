describe Usage do
  
  let(:meter){ FactoryGirl.create :meter }
  let(:date){ Date.new(2017, 1, 17) }
  
  it 'creates usages from api' do
    binding.pry
    expect { 
      Usage.request_usage_to_api(date, meter.id)
    }.to change { 
      Usage.count
    }.from(0).to(1)
    
  end 

end 
  