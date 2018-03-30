User.create!(name: "caven xu",
             email: "example@mimi-t.org",
             password: "111111",
             password_confirmation: "111111",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             icon: open('app/assets/images/8.png')
             )

def fetch_fake_images_from(path)
  dir = Dir.new(path)
  image_names = dir.entries.delete_if { |entry| entry =~ /^\./ }
  image_url = path + image_names.sample
end



50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@mimic-t.org"
  password = "password"
  fake_image = open ("app")
  User.create!(
               name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               remote_icon_url: "http://placebeard.it/g/200/200"
              )
end

users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.paragraph(rand(1..3))
  users.each { |user| user.microposts.create!(content: content) }
end

Micropost.all.each do |micropost|
 rand(1..6).times do
   micropost.buckets.create(remote_picture_url: "https://placeimg.com/200/200/any")
   micropost.comments.create(user_id: User.all.ids.sample, message: Faker::Lorem.paragraph)
   micropost.likes.create(user_id: User.all.ids.sample)
 end
end



# following relationships

users = User.all
user = users.first
user_following = users[2..50]
user_followers = users[3..40]
user_following.each { |followed| user.follow(followed) }
user_followers.each { |follower| follower.follow(user) }
