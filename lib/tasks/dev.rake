namespace :dev do
  
  task fake_users_admin: :environment do
    
    User.create(email: "xxx@xxx.com", password: "12345678", role: "admin", name: "小明")
    User.create(email: "yyy@yyy.com", password: "12345678", role: "admin", name: "小美")
    User.create(email: "zzz@zzz.com", password: "12345678", role: "admin", name: "小華")
    
    puts "3 個 admin 已創建"    
  end

  task fake_users_normal: :environment do

    20.times do |i|
      name = FFaker::Name::first_name
      # file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")
      
      user = User.new(
        name: name,
        email: "#{name}@xxx.co",
        password: "12345678"
        # avatar: file
      )
      
      user.save!
      # puts user.name
    end
    puts "20 個普通使用者已創建"

  end

  task fake_posts: :environment do
    Post.destroy_all
    30.times do |i|
      Post.create!(
        title: "這是標題",
        content: FFaker::Lorem.sentence,
        user_id: User.all.sample.id,
        status: "craft"
        )
    end
    puts "30 個 文章 已創建"
  end
  
  task fake_comments: :environment do 
    Comment.destroy_all
    68.times do |i|
      Reply.create!(
        cotent: "這是有的沒的回覆",
        user_id: User.all.sample.id,
        post_id: Post.all.sample.id
        )
    end
    puts "68 個 回覆 已創建"
  end
  
  task rebuild: ["db:drop", "db:create", "db:migrate", "db:seed", :fake_users_admin, :fake_users_normal, :fake_posts]
  
end
