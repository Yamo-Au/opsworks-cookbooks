# Deploy applications to EBS volume
default[:deploy] = {}
node[:deploy].each do |application, deploy|
  default[:deploy][application][:deploy_to] = "/mnt/www/#{application}"
end