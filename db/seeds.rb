# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create default user
if User.count == 0
  User.create first_name: "Admin", last_name: "UDB", email: "henryalberto.diaz@gmail.com", password: "1236547890", role: "admin"
end
