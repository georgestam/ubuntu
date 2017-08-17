class User < ApplicationRecord
  acts_as_token_authenticatable
  
  LANGUAGES = %w[ar en].freeze
  
  has_many :recordings, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :email, email_format: { message: "doesn't look like an email address" }, presence: true
  validates :name, presence: true 
  
  def words_known_by_user
    words_arrays = []
    Recording.where(user: self).each do |recording|
      words_arrays << recording.learning_words
    end 
    # create one array from all the arrays
    words = words_arrays.flatten
    # select only the words that have been at least 3 times
    known_words = words.select{|word| words.count(word) > 2 }
    # remove dublicate words and return only one word of each 
    known_words.uniq
  end 
  
  def learning_words_by_user
    words = []
    Recording.where(user: self).each do |recording|
      words << recording.learning_words
    end 
    # the words that you are learning = total number new words but and no dublicated - the words that you already know.  
    words.uniq.flatten - words_known_by_user
  end 
  
end


