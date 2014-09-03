node[:opsworks][:applications].each do |application|
  normal[:deploy][application[:name]][:deploy_to] = "/mnt/sites/#{application[:name]}"
end