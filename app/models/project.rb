class Project < ApplicationRecord
  belongs_to :client, optional: true

  enum status: { pending: 0, in_progress: 1, finished: 2 }

  def self.paginate(page: 0, limit: 5)
    page = 0 if page.negative?
    limit = 5 if limit < 1

    order(created_at: :desc).limit(limit).offset(page * limit)
  end
end
