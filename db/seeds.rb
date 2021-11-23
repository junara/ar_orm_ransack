# frozen_string_literal: true

def reset_all
  Comment.delete_all
  Blog.delete_all
  User.delete_all
end

reset_all

10.times do
  User.create!({
                 name: Faker::JapaneseMedia::DragonBall.character,
                 age: (1..100).to_a.sample
               })
end

user_ids = User.all.pluck(:id)

100.times do
  blog = Blog.new(
    status: %i[edited published canceled].sample,
    document: Faker::Lorem.sentence(word_count: 50),
    user_id: user_ids.sample
  )
  blog.published_dt = Faker::Date.between(from: '2021-01-01', to: '2021-12-31') if blog.published? || blog.canceled?
  blog.save!
end

Blog.all.find_each do |blog|
  next if blog.edited?

  num = (0..5).to_a.sample
  num.times do
    blog.comments.create!(
      {
        user_id: user_ids.sample,
        document: Faker::Lorem.sentence(word_count: 10),
        published_dt: Faker::Date.between(from: blog.published_dt.to_s, to: blog.published_dt.since(1.year))
      }
    )
  end
end
