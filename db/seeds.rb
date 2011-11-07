# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new(:login => 'moomin', :password => 'moomin', :password_confirmation => 'moomin', 
:email => 'nyaago@bf.wakwak.com', :is_admin => true)
user.save!

site = Site.new(:name => 'moomin', :title => 'ムーミン')
site.save!
