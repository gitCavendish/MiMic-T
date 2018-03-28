User.create!(name: "Example User",
             email: "example@mimi-t.org",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now
             )

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@mimic-t.org"
  password = "password"
  User.create!(
               name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
              )
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# following relationships

users = User.all
user = users.first
user_following = users[2..50]
user_followers = users[3..40]
user_following.each { |followed| user.follow(followed) }
user_followers.each { |follower| follower.follow(user) }
