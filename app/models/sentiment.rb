require 'watson'

class Sentiment < ApplicationRecord
  belongs_to :sentimentable, polymorphic: true

  NAMES = [:anger, :joy, :fear, :sadness, :disgust].freeze
end
