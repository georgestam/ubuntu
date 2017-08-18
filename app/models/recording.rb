class Recording < ApplicationRecord
  belongs_to :user
  
  mount_uploader :file, RecordUploader
  
  # serialize :data, JSON
  
  before_validation :create_array
  
  def create_array
    
    total_words_known = self.user.words_known_by_user
    new_words = []
     
      
      unless word_known
        new_words << word_with_confidence
      end
    end 
    self.learning_words = new_words
  end 
  
  def words_with_confidence
    
  
    # This defines the speaker:
    # data_hash['results'][1]['speaker'] > 1
    # This defines sentences:
    # self.data['results'][1]
    # This defines each words:
    # self.data['results'][1]["word_alternatives"][3]['alternatives'] > [{"confidence"=>0.515, "word"=>"and"}, {"confidence"=>0.3248, "word"=>"<eps>"}, {"confidence"=>0.043, "word"=>"in"}
    data = JSON.parse(self.data)
    users = []
    data['results'].each do |sentence|
      if sentence['speaker'] == self.speaker
        sentence["word_alternatives"].each do |word|
          word['alternatives'].each do |word_options|
            if word_options["confidence"] > (self.confidence.to_f) / 100
              words << word_options["word"]
            end 
          end 
        end 
      end
    end
    words
  end

end
