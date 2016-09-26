class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :google_plus, :string
    add_column :users, :homepage, :string
  end
end
