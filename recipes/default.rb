# Cookbook Name:: ohai-brightbox
# Recipe:: default
#
# Copyright 2014, Itison, Ltd

ohai "reload brightbox" do
  plugin "brightbox"
  action :nothing
end

cookbook_file "#{node[:ohai][:plugin_path]}/brightbox.rb" do
  source "brightbox.rb"
  notifies :reload, "ohai[reload brightbox]"
end

include_recipe "ohai::default"
