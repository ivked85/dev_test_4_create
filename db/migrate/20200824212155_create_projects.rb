class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :status, default: 0
      t.datetime :created_at
      t.references :client, foreign_key: true
    end
  end
end
