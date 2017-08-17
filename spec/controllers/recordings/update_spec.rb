RSpec.describe Api::Respira::V1::RecordingsController, type: :controller do

  describe 'recrodings#update' do
    
    let(:user){ FactoryGirl.create :user }
    let(:recording){ FactoryGirl.create :recording, user: user }
    let(:reference){ FactoryGirl.create :recording, user: user, data: "some new json parsed to a string" }
    
    def response_object
      JSON.parse(response.body)
    end
    
    let(:params) { 
      {
        id: recording.id,
        user_email: user.email,
        user_token: token,
        recording: {
          description: reference.description,
          data: reference.data
        }
      } 
    }
    
    def the_action  
      patch :update, params: params, format: :json
    end
    
    context 'when correct token is given' do 
      
      let(:token){ user.authentication_token }

      it 'updates recording attributes' do
        expect {
          the_action
        }.to change { 
          recording.reload.description
        }.from(recording.description).to(reference.description).and change {
          recording.reload.data
        }.from(recording.data).to(reference.data)
      end
      
      it 'responds with a corresponding object' do
        the_action
        expect(response_object.fetch('description')).to eq reference.description
        expect(response_object.fetch('data')).to eq reference.data
      end
      
      it 'returns status code 200' do
        the_action
        expect(response.status).to eq(200) 
      end
    
    end
      
    context 'when a wrong token is given' do
      
      let(:token){ "wrong token" }
    
      it 'responds with a corresponding object' do
        the_action
        expect(response_object.fetch('error')).to eq "You need to sign in or sign up before continuing."
      end
      
      it 'returns status code 401' do
        the_action
        expect(response.status).to eq(401)
      end
      
    end
  end
end