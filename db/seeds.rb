# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if ENV['RAILS_ENV'] == 'development'
  # Test user
  u = User.create(email: 'idontknow@my.email', password: 'changeme', password_confirmation: 'changeme')
  FactoryGirl.create_list(:cattle, 20, user_id: u.id)

  # Create further users
  us = FactoryGirl.create_list(:user, 20)
  us.each do | u |
    FactoryGirl.create_list(:cattle, 20, user_id: u.id)
  end
end
