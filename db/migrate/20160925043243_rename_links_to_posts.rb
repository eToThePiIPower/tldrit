class RenameLinksToPosts < ActiveRecord::Migration
  def change
    rename_table :links, :posts
    rename_column :comments, :link_id, :post_id
  end
end
