#
# Cookbook Name:: deploy
# Recipe:: wordpress
#

include_recipe 'php'

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
end
