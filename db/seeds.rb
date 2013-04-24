# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create default user
User.destroy_all
User.create first_name: "Henry", last_name: "Diaz", email: "henryalberto.diaz@gmail.com", password: "123456789", role: "admin"
User.create first_name: "Emely", last_name: "Hernandez", email: "aleca_eh@hotmail.com", password: "123456789", role: "admin"
