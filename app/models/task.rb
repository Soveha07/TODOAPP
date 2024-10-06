class Task < ApplicationRecord
  belongs_to :category
  
  validates :description, presence: true

  STATUSES = %w[pending in_progress in_review completed]

  validates :status, inclusion: { in: STATUSES }

  def pending?
    status == 'pending'
  end

  def in_progress?
    status == 'in_progress'
  end

  def completed?
    status == 'completed'
  end

  def in_review?
    status == "in_review"
  end

  def set_status(new_status)
    update(status: new_status) if STATUSES.include?(new_status)
  end

end
