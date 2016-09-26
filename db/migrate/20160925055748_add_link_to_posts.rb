class AddLinkToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :link, :boolean, default: true
  end
end
