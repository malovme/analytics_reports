class Report < ApplicationRecord
  validates :name, :start_date, :end_date, :metrics, :presence => true
  validate :end_after_start

  serialize :metrics
  serialize :dimensions

  private

  def end_after_start
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
