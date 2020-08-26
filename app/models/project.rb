class Project < ApplicationRecord
  # TODO: remove
  # enum status: { pending: 0, in_progress: 1, finished: 2}

  belongs_to :client, optional: true
end
