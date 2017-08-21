RSpec.describe Api::Respira::V1::RecordingsController, type: :controller do
  
  describe 'recrodings#index' do
    
    let!(:user){ FactoryGirl.create :user }
    let!(:recording){ FactoryGirl.create :recording, user: user }
    
    def the_action  
      get :index, format: :json
    end
    
    def response_object
      JSON.parse(response.body)
    end 
    
    before {
      the_action
    }
    
    it 'returns an object' do
      expect(response_object.size).to eq(1)
    end
    
    it 'responds with a corresponding object' do
      expect(response_object.first.fetch("description")).to eq recording.description
      expect(response_object.first.fetch("data")).to eq recording.data
    end
    
    it 'returns status code 200' do
      expect(response.status).to eq(200) 
    end
    
  end
end
