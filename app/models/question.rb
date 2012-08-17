# A specificaton for a piece of info that the survey designer wants to collect.

class Question < ActiveRecord::Base
  belongs_to :survey
  attr_accessible :content
  validates_presence_of :content
  has_many :answers
end