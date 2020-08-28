class Project < ApplicationRecord
  belongs_to :client, optional: true

  def self.paginate(page: 0, limit: 5)
    page = 0 if page < 0
    limit = 5 if limit < 1

    order(created_at: :desc).limit(limit).offset(page * limit)
  end
end
