class AddCountToUser2 < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :sent_follow_requests_count, :integer, :default => 0
    change_column :users, :received_follow_requests_count, :integer, :default => 0
  end
end