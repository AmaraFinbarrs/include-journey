# app/models/wba_self.rb
class WellbeingAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true

  has_many :wba_scores, foreign_key: :wellbeing_assessment_id, dependent: :delete_all

  def today?
    created_at.today?
  end
end
