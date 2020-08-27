class Project < ApplicationRecord
  belongs_to :client, optional: true

  def self.paginate(page: 0, limit: 5)
    order(created_at: :desc).limit(limit).offset(page.to_i * limit.to_i)
  end
end
