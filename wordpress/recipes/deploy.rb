#
# Cookbook Name:: deploy
# Recipe:: wordpress
#

include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    path deploy[:deploy_to]
  end

end
