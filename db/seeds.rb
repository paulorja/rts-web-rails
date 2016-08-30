# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create({login: 'admin', password: '1234', user_type: 1})
UserData.create({user_id: 1, wood: 999999, gold: 999999})
puts 'CREATE ADMIN'