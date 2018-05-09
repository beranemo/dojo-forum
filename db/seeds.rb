Category.destroy_all

category_list = [
  { name: "商業類" },
  { name: "技術類" },
  { name: "心理類" }
]

category_list.each do |category|
  Category.create(name: category[:name])
end
puts "預設分類已創建!"

# Default admin
User.destroy_all

User.create(email: "admin@example.com", password: "12345678", role: "admin", name: "大大")
puts "預設管理員已創建!"
