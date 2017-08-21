RSpec.describe Api::Respira::V1::RecordingsController, type: :controller do
  
  describe 'recrodings#show' do
    
    let!(:user){ FactoryGirl.create :user }
    let!(:recording){ FactoryGirl.create :recording, user: user }
      
    def the_action  
      get :show, params: { id: recording.id }, format: :json
    end
    
    def response_object
      JSON.parse(response.body)
    end 
    
    before {
      the_action
    }
      
    it 'responds with a corresponding object' do
      expect(response_object.fetch('description')).to eq recording.description
      expect(response_object.fetch('data')).to eq recording.data
    end
    
    it 'returns status code 200' do
      expect(response.status).to eq(200) 
    end
    
  end
end
