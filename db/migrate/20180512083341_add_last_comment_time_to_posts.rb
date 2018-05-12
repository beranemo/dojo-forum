class AddLastCommentTimeToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :last_comment_time, :datetime
  end
end
