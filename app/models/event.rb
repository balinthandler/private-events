class MyDateValidator < ActiveModel::Validator
  def validate(record)
    unless record.date >= Date.today
      record.errors.add :date, "You can't create an event in the past!"
    end
  end
end

class Event < ApplicationRecord
  include ActiveModel::Validations

  validates :title, presence: true
  validates :date, presence: true
  validates_with MyDateValidator


  scope :past, -> { where("date < ?", Date.today) }
  scope :upcoming, -> { where("date >= ?", Date.today) }

  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :attendances, foreign_key: :attended_event_id, dependent: :destroy
  has_many :attendees, through: :attendances, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invitees, through: :invitations, dependent: :destroy
end
