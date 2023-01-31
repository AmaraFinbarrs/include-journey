# app/models/affirmation.rb
class Affirmation < ApplicationRecord
  belongs_to :team_member
  validates_format_of :text, with: Rails.application.config.regex_text_field, on: :create

  scope :archived, -> { where('scheduled_date < ?', Date.today) }
  scope :upcoming, -> { where('scheduled_date >= ?', Date.today) }

  validates_presence_of :text, :scheduled_date, :team_member_id

  def date
    scheduled_date.strftime('%d/%m/%Y')
  end
end
