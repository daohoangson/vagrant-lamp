require_recipe "apt"
require_recipe "git"
require_recipe "zsh"
require_recipe "oh-my-zsh"
require_recipe "apache2"
require_recipe "apache2::mod_rewrite"
require_recipe "mysql"
require_recipe "php"
require_recipe "apache2::mod_php5"

# Install packages
%w{ vim screen mc subversion }.each do |a_package|
  package a_package
end

# Install ruby gems
%w{ rake }.each do |a_gem|
  gem_package a_gem
end

# Configure sites
sites = data_bag("sites")

sites.each do |name|
  site = data_bag_item("sites", name)

  # Add site to apache config
  web_app site["host"] do
    template "sites.conf.erb"
    server_name site["host"]
    server_aliases site["aliases"]
    docroot "/vagrant/public/#{site["host"]}"
  end  

   # Add site info in /etc/hosts
   bash "hosts" do
     code "echo 127.0.0.1 #{site["host"]} #{site["aliases"].join(' ')} >> /etc/hosts"
   end
end