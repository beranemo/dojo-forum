class AddWhoCanSeeToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :who_can_see, :string, limit: 20
  end
end
