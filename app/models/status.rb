class Status < ApplicationRecord
  has_many :alerts, dependent: :destroy
end
