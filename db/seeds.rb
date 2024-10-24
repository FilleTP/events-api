# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

Event.destroy_all
Category.destroy_all
User.destroy_all

category_names = ["Sport", "Music", "Art", "Cooking", "Spiritual"]

category_names.each do |category|
  Category.create!(name: category)
  puts "Created the category: #{category}"
end

user_1 = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123", name: "Filip")
user_2 = User.create!(email: "testing@example.com", password: "password1234", password_confirmation: "password1234", name: "Linda")


puts "Created users: Filip and Linda"

# Real Catalonia Addresses for Events
addresses = [
  "Carrer de Mallorca, 401, 08013 Barcelona, Spain",
  "Plaça d'Espanya, 2, 08014 Barcelona, Spain",
  "Passeig de Gràcia, 92, 08008 Barcelona, Spain",
  "Carrer de la Marina, 19-21, 08005 Barcelona, Spain",
  "Avinguda Diagonal, 640, 08017 Barcelona, Spain",
  "Carrer d'Aragó, 255, 08007 Barcelona, Spain",
  "Carrer de Balmes, 132, 08008 Barcelona, Spain",
  "Gran Via de les Corts Catalanes, 670, 08010 Barcelona, Spain",
  "Rambla de Catalunya, 73, 08007 Barcelona, Spain",
  "Passeig de Sant Joan, 55, 08009 Barcelona, Spain"
]

# Define event names and descriptions for each category
event_details = {
  "Sport" => [
    { name: "Barcelona 10K Run", description: "Join us for a thrilling 10K run through the heart of Barcelona. Perfect for both beginners and seasoned runners." },
    { name: "Beach Volleyball Tournament", description: "A fun and competitive beach volleyball tournament by the coast. Form your team and enjoy the game!" },
    { name: "Mountain Biking Challenge", description: "Explore the beautiful trails in Catalonia on a mountain biking adventure. A test of endurance and skill." },
    { name: "Tennis Doubles Championship", description: "Compete in our doubles tennis tournament, open to all skill levels. A great way to enjoy a sunny day outdoors." }
  ],
  "Music" => [
    { name: "Jazz Night at the Park", description: "Enjoy an evening of smooth jazz with some of the finest local and international musicians at the park." },
    { name: "Rock Festival 2024", description: "Get ready to rock with live performances from top bands across the globe. An unforgettable night of music and fun." },
    { name: "Acoustic Guitar Sessions", description: "An intimate acoustic guitar session with local artists, bringing the best of folk and indie tunes." },
    { name: "Classical Symphony Concert", description: "Experience the magic of classical music performed by a world-renowned symphony orchestra." }
  ],
  "Art" => [
    { name: "Barcelona Street Art Tour", description: "Discover the vibrant street art scene in Barcelona with our expert guide. Explore murals and graffiti across the city." },
    { name: "Modern Art Exhibition", description: "A curated exhibition showcasing the latest in modern art. From abstract paintings to conceptual sculptures." },
    { name: "Photography Masterclass", description: "Learn from the best in the field of photography with this hands-on masterclass. Suitable for all levels." },
    { name: "Ceramics Workshop", description: "A hands-on ceramics workshop where you'll learn to create your own pottery pieces. All materials provided." }
  ],
  "Cooking" => [
    { name: "Paella Cooking Class", description: "Master the art of making traditional Spanish paella with this hands-on cooking class. Delicious and fun!" },
    { name: "Catalan Tapas Workshop", description: "Learn to prepare a variety of traditional Catalan tapas with our expert chefs. A flavorful experience!" },
    { name: "Wine & Cheese Pairing", description: "A sophisticated evening of wine and cheese pairing. Discover the best combinations from local producers." },
    { name: "Vegan Mediterranean Cuisine", description: "Explore the rich flavors of Mediterranean cuisine with a vegan twist. A healthy and delicious cooking class." }
  ],
  "Spiritual" => [
    { name: "Meditation and Mindfulness Retreat", description: "A peaceful retreat focusing on meditation and mindfulness practices to help you reconnect with yourself." },
    { name: "Yoga by the Sea", description: "Start your day with a rejuvenating yoga session by the sea. Suitable for all skill levels, beginners welcome!" },
    { name: "Sound Healing Therapy", description: "Experience the soothing effects of sound healing therapy with crystal bowls, gongs, and other instruments." },
    { name: "Full Moon Ceremony", description: "Join us for a spiritual full moon ceremony to cleanse your energy and set positive intentions for the month ahead." }
  ]
}

# Create Events for each category
Category.all.each do |category|
  event_details[category.name].each_with_index do |event, index|
    user = index.even? ? user_1 : user_2

    Event.create!(
      name: event[:name],
      start_date: Faker::Time.forward(days: 10 + index, period: :morning),
      end_date: Faker::Time.forward(days: 10 + index, period: :afternoon),
      description: event[:description],
      capacity: rand(50..100),
      address: addresses.sample,
      user: user,
      category: category
    )

    puts "Created #{event[:name]} in category: #{category.name}"
  end
end

puts "Seeding completed!"
