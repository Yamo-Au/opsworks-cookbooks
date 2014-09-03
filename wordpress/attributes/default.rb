# Default configuration for the AWS OpsWorks cookbook for Wordpress
#

# Enable the Wordpress W3 Total Cache plugin (http://wordpress.org/plugins/w3-total-cache/)?
default['wordpress']['wp_config']['enable_W3TC'] = false

# Force logins via https (http://codex.wordpress.org/Administration_Over_SSL#To_Force_SSL_Logins_and_SSL_Admin_Access)
default['wordpress']['wp_config']['force_secure_logins'] = false

<<<<<<< HEAD
=======
# Deploy applications to EBS volume
default[:deploy] = {}
node[:deploy].each do |application, deploy|
  default[:deploy][application][:deploy_to] = "/mnt/www/#{application}"
  default[:deploy][application][:chef_provider] = node[:deploy][application][:chef_provider] ? node[:deploy][application][:chef_provider] : node[:opsworks][:deploy_chef_provider]
  unless valid_deploy_chef_providers.include?(node[:deploy][application][:chef_provider])
    raise "Invalid chef_provider '#{node[:deploy][application][:chef_provider]}' for app '#{application}'. Valid providers: #{valid_deploy_chef_providers.join(', ')}."
  end
  default[:deploy][application][:keep_releases] = node[:deploy][application][:keep_releases] ? node[:deploy][application][:keep_releases] : node[:opsworks][:deploy_keep_releases]
  default[:deploy][application][:current_path] = "#{node[:deploy][application][:deploy_to]}/current"
  default[:deploy][application][:document_root] = ''
  default[:deploy][application][:ignore_bundler_groups] = node[:opsworks][:rails][:ignore_bundler_groups]
  if deploy[:document_root]
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/#{deploy[:document_root]}/"
  else
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/"
  end

  if File.exists?('/usr/local/bin/rake')
    # local Ruby rake is installed
    default[:deploy][application][:rake] = '/usr/local/bin/rake'
  else
    # use default Rake/ruby
    default[:deploy][application][:rake] = 'rake'
  end

  default[:deploy][application][:migrate] = false

  if node[:deploy][application][:auto_bundle_on_deploy]
    default[:deploy][application][:migrate_command] = "if [ -f Gemfile ]; then echo 'OpsWorks: Gemfile found - running migration with bundle exec' && /usr/local/bin/bundle exec #{node[:deploy][application][:rake]} db:migrate; else echo 'OpsWorks: no Gemfile - running plain migrations' && #{node[:deploy][application][:rake]} db:migrate; fi"
  else
    default[:deploy][application][:migrate_command] = "#{node[:deploy][application][:rake]} db:migrate"
  end
  default[:deploy][application][:rails_env] = 'production'
  default[:deploy][application][:action] = 'deploy'
  default[:deploy][application][:user] = node[:opsworks][:deploy_user][:user]
  default[:deploy][application][:group] = node[:opsworks][:deploy_user][:group]
  default[:deploy][application][:shell] = node[:opsworks][:deploy_user][:shell]
  default[:deploy][application][:home] = if !node[:opsworks][:deploy_user][:home].nil?
                                           node[:opsworks][:deploy_user][:home]
                                         elsif self[:passwd] && self[:passwd][self[:deploy][application][:user]] && self[:passwd][self[:deploy][application][:user]][:dir]
                                           self[:passwd][self[:deploy][application][:user]][:dir]
                                         else
                                           "/home/#{self[:deploy][application][:user]}"
                                         end
  default[:deploy][application][:sleep_before_restart] = 0
  default[:deploy][application][:stack][:needs_reload] = true
  default[:deploy][application][:enable_submodules] = true
  default[:deploy][application][:shallow_clone] = false
  default[:deploy][application][:delete_cached_copy] = true
  default[:deploy][application][:create_dirs_before_symlink] = ['tmp', 'public', 'config']
  default[:deploy][application][:symlink_before_migrate] = {}

  default[:deploy][application][:environment] = {"RAILS_ENV" => deploy[:rails_env],
                                                 "RUBYOPT" => "",
                                                 "RACK_ENV" => deploy[:rails_env],
                                                 "HOME" => node[:deploy][application][:home]}
  default[:deploy][application][:ssl_support] = false
  default[:deploy][application][:auto_npm_install_on_deploy] = true

  # nodejs
  default[:deploy][application][:nodejs][:restart_command] = "monit restart node_web_app_#{application}"
  default[:deploy][application][:nodejs][:stop_command] = "monit stop node_web_app_#{application}"
  default[:deploy][application][:nodejs][:port] = deploy[:ssl_support] ? 443 : 80
end
>>>>>>> FETCH_HEAD
