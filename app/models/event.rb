class Event < ApplicationRecord
  validates :title, presence: true
  validates :date, presence: true
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :attendances, foreign_key: :attended_event_id, dependent: :destroy
  has_many :attendees, through: :attendances
end
