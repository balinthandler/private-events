class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present? && value >= Date.today
      record.errors.add attribute, "You can't create an event in the past!"
    end
  end
end

class Event < ApplicationRecord
  include ActiveModel::Validations

  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true, date: true


  scope :past, -> { where("date < ?", Date.today) }
  scope :upcoming, -> { where("date >= ?", Date.today) }

  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :attendances, foreign_key: :attended_event_id, dependent: :destroy
  has_many :attendees, through: :attendances, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invitees, through: :invitations, dependent: :destroy
  has_many :comments, dependent: :destroy
end
