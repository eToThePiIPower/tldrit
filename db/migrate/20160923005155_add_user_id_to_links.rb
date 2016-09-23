class AddUserIdToLinks < ActiveRecord::Migration
  def change
    add_reference :links, :user, index: true, foreign_key: true
  end
end
