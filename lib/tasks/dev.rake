namespace :dev do
  
  task fake_users_admin: :environment do
    
    User.create(email: "xxx@xxx.com", password: "12345678", role: "admin", name: "小明")
    User.create(email: "yyy@yyy.com", password: "12345678", role: "admin", name: "小美")
    User.create(email: "zzz@zzz.com", password: "12345678", role: "admin", name: "小華")
    
    puts "3 個 admin 已創建"    
  end

  task fake_users_normal: :environment do

    User.create(email: "xxx1@xxx1.com", password: "12345678", role: "normal", name: "陳大天")
    User.create(email: "yyy1@yyy1.com", password: "12345678", role: "normal", name: "李天華")
    User.create(email: "zzz1@zzz1.com", password: "12345678", role: "normal", name: "楊超越")
    puts "3 個普通使用者已創建"

  end

  task fake_posts: :environment do
    Post.destroy_all
    30.times do |i|
      Post.create!(
        title: "這是標題",
        content: FFaker::Lorem.sentence,
        user_id: User.all.sample.id,
        status: "craft",
        who_can_see: "all"
        )
    end
    puts "30 個 文章 已創建"
  end
  
  task fake_comments: :environment do 
    Comment.destroy_all
    50.times do |i|
      Reply.create!(
        cotent: "這是有的沒的回覆",
        user_id: User.all.sample.id,
        post_id: Post.all.sample.id
        )
    end
    puts "50 個 回覆 已創建"
  end
  
  task rebuild: ["db:drop", "db:create", "db:migrate", "db:seed", :fake_users_admin, :fake_users_normal, :fake_posts]
  
end
