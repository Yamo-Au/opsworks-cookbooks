#
# Cookbook Name:: deploy
# Recipe:: wordpress
#

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    path deploy[:deploy_to]
  end

end
