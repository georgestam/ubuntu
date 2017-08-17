module Api
  module Respira
    module V1
      class RecordingsController < Api::Respira::V1::BaseController
        acts_as_token_authentication_handler_for User, except: %i[index show]
        before_action :set_recording, only: %i[show update destroy]
        
        def index
          @recordings = policy_scope(Recording)
        end

        def show
        end

        def update
          if @recording.update(recording_params)
            render :show
          else
            render_error
          end
        end
        
        def create
          @recording = Recording.new(recording_params)
          @recording.user = current_user
          
          file = File.read('lib/examples/json/example1.json')  
          @recording.data = file
          
          @recording.add_new_words
          
          authorize @recording
          if @recording.save
            render :show, status: :created
          else
            render_error
          end
        end
        
        def destroy
          if @recording.destroy
            redirect_to user_path(@recording.user)
          end 
        end 

        private

        def set_recording
          @recording = Recording.find(params[:id])
          authorize @recording 
        end

        def recording_params
          params.require(:recording).permit(:data, :description, :confidence, :speaker)
        end

        def render_error
          render json: { errors: @recording.errors.full_messages },
                 status: :unprocessable_entity
        end
        
      end
    end
  end
end