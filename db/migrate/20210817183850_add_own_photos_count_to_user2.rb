class AddOwnPhotosCountToUser2 < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :own_photos_count, :integer, :default => 0
    change_column :users, :likes_count, :integer, :default => 0
    change_column :users, :comments_count, :integer, :default => 0
    change_column :photos, :comments_count, :integer, :default => 0
    change_column :photos, :likes_count, :integer, :default => 0
  end
end