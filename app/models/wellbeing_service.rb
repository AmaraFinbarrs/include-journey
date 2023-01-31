# app/models/wellbeing_service.rb
class WellbeingService < ApplicationRecord
  belongs_to :team_member

  has_many :metrics_services
  has_many :wellbeing_metrics, through: :metrics_services

  validates_presence_of :name, :website
  validates_format_of :name, with: Rails.application.config.regex_name, on: [:create, :update]
  validates_format_of :description, with: Rails.application.config.regex_text_field, on: [:create, :update]
  validates_format_of :website, with: Rails.application.config.regex_website, on: [:create, :update]
  validates_format_of :contact_number, with: Rails.application.config.regex_telephone, on: [:create, :update]

  def linked(wellbeing_metric_id)
    metrics_services.any? { |ms| ms.wellbeing_metric_id == wellbeing_metric_id }
  end

  def unlink_metric(wellbeing_metric_id)
    return unless linked(wellbeing_metric_id)

    metrics_services.find_by(wellbeing_metric_id: wellbeing_metric_id).destroy!
  end

  def link_metric(wellbeing_metric_id)
    return if linked(wellbeing_metric_id)

    metrics_services.create!(wellbeing_metric_id: wellbeing_metric_id)
  end

  def metrics
    wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" }
  end
end
