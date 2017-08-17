RSpec.describe RegistrationsController, type: :controller do

  describe 'Users#create' do
    
    let!(:reference){ FactoryGirl.build :user }
    
    def response_object
      JSON.parse(response.body)
    end
    
    before {
      devise_mapping_for_rspec
    }
    
    def the_action  
      post :create, params: params, format: :json
    end
    
    context 'when a correct params are given' do 
      
      let(:params) { 
        { 
          user: {
            email: reference.email,
            password: reference.password
          } 
        } 
      }
  
      it 'creates a new user' do
        expect {
          the_action
        }.to change { 
          User.count
        }.by(1)
      end
      
      it 'creates a token in the user table' do
        expect { 
          the_action 
        }.to change { 
          User.first.try(:authentication_token).present? 
        }.from(false).to(true).and change {
          User.first.try(:authentication_token).class
        }.from(NilClass).to(String)
      end
      
      it 'returns status code 201' do
        the_action
        expect(response.status).to eq(201) 
      end
    
    end
    
    context 'when wrong params are given' do 
      
      let(:params) { 
        { 
          user: {
            email: "wrong@email",
            password: "tooshort"
            } 
          } 
      }
  
      it 'does not create a new user' do
        expect { the_action }.to_not change(User, :count) # use this sintax (rather than User.count) in order top please rubocop
      end
      
      it 'returns status code 422' do
        the_action
        expect(response.status).to eq(422) 
      end
    
    end
  end
end