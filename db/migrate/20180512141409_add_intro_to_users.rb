class AddIntroToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :intro, :text
  end
end
