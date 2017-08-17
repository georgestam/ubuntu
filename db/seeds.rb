User.destroy_all
Recording.destroy_all

User.create!({
  email: "laima@ubuntu.org",
  password: "password10",
  name: 'laima',
  admin: true
  })

file = File.read('lib/examples/json/example1.json')

1.times do
  Recording.create!({
    data: file,
    description: Faker::ChuckNorris.fact,
    user: User.first,
    confidence: 80,
    speaker: 1
    })
end

file = File.read('lib/examples/json/example2.json')

1.times do
  Recording.create!({
    data: file,
    description: Faker::ChuckNorris.fact,
    user: User.first,
    confidence: 80,
    speaker: 1
    })
end
