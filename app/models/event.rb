class Event < ApplicationRecord
  validates :title, presence: true
  validates :date, presence: true

  scope :past, -> { where("date < ?", Date.today) }
  scope :upcoming, -> { where("date >= ?", Date.today) }

  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :attendances, foreign_key: :attended_event_id, dependent: :destroy
  has_many :attendees, through: :attendances, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invitees, through: :invitations, dependent: :destroy
end
