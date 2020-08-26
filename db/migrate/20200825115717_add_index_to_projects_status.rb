class AddIndexToProjectsStatus < ActiveRecord::Migration[6.0]
  def change
    add_index :projects, :status
  end
end
