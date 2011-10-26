# -*- coding: utf-8 -*-
require 'machinist/active_record'
require 'sham'

Sham.login {|index| "account#{index}" }
Sham.password { 'password' }
Sham.password_confirmation { 'password' }
Sham.email { |index| "account#{index}@hogehoge.com" } 

Sham.site_name  { |index| "site#{index}"}
Sham.site_title  {|index| "サイト#{index}"}

Sham.page_name  {|index| "page" + ('a'..'z').to_a[index] }
Sham.article_title  {|index| "記事#{index}"}
Sham.article_content  {|index| "<p>記事#{index}</p>"}

User.blueprint do
  login { Sham.login }
  password { 'password' }
  password_confirmation { 'password' }
  email { Sham.email }
end
p "@@@@@@@"
p User.all

User.make


