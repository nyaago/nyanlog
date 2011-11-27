# -*- coding: utf-8 -*-
require 'machinist/active_record'
require 'sham'

Sham.login {|index| "account#{index}" }
Sham.password { 'password' }
Sham.password_confirmation { 'password' }
Sham.email { |index| "account#{index}@hogehoge.com" } 

Sham.site_name  { |index| "site#{index}"}
Sham.site_title  {|index| "サイト#{index}"}

Sham.folder_name  {|index| "folder" + ('a'..'z').to_a[index] }
Sham.folder_title  {|index| "folderタイトル" + ('a'..'z').to_a[index] }
Sham.article_title  {|index| "記事#{index}"}
Sham.article_content  {|index| "<p>記事#{index}</p>"}

User.blueprint do
  login { Sham.login }
  password { 'password' }
  password_confirmation { 'password' }
  email { Sham.email }
end

Site.blueprint do
  name { Sham.site_name }
  title { Sham.site_title }
end

Folder.blueprint do
  name { Sham.folder_name }
  title { Sham.folder_title }
  
end

Menu.blueprint do
  menu_type { 'Header' }
end

Article.blueprint do
  title { Sham.article_title }
  content { Sham.article_content }
end

AppSetting.blueprint do
end


#User.make
#Site.make

#p User.all
#p Site.all
