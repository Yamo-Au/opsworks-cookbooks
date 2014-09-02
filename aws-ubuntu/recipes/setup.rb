# AWS OpsWorks Recipe for Ubuntu VMs to be executed during the Setup lifecycle phase
# - Adds memory swap: This should be used in instances with low RAM -
#   e.g. AWS t1.micro - to prevent "out of memory" issues.

swap_size = node[:awsubuntu][:swapsize]
Chef::Log.debug("Creating SWAP with size #{swap_size} bytes")

script "memory_swap" do
  interpreter "bash"
  user "root"
  cwd "/"
  code <<-EOH
  /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=#{swap_size}
  /sbin/mkswap /var/swap.1
  /sbin/swapon /var/swap.1
  EOH
end

# Mount EBS Volume to host sites
mount_point = node['ebs']['raids']['/dev/md0']['mount_point'] rescue nil

if mount_point
  node[:deploy].each do |application, deploy|
    directory "#{mount_point}/#{application}" do
      owner deploy[:user]
      group deploy[:group]
      mode 00770
      recursive true
    end

    link "/srv/www/#{application}" do
      to "#{mount_point}/#{application}"
    end
  end
end
