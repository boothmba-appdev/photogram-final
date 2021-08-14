class AddCountToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sent_follow_requests_count, :integer
    add_column :users, :received_follow_requests_count, :integer
  end
end
