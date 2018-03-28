#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# install java-1.7.0-openjdk-devel
package 'java-1.7.0-openjdk-devel'

# 'sudo groupadd tomcat'
group 'tomcat'

# 'sudo useradd -M -s /bin/nologin -g tomat -d /opt/tomcat tomcat'
user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

remote_file 'apache-tomcat-8.0.32.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz'
end

directory '/opt/tomcat' do
  # action :create
  group 'tomcat'
end

# TODO: NOT DESIRED STATE
execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

# TODO: NOT DESIRED STATE
execute 'chgrp -R tomcat /opt/tomcat'

directory '/opt/tomcat/conf' do
  mode '0070'
end

# TODO: NOT DESIRED STATE
execute 'chmod -R g+r /opt/tomcat/conf'

# TODO: NOT DESIRED STATE
execute 'chmod g+x /opt/tomcat/conf'

# TODO: NOT DESIRED STATE
#execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

file %w(webapps work temp logs).each do |path|
  ("/opt/tomcat/#{path}") do
    owner 'tomcat'
  end
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

# TODO: NOT DESIRED STATE
execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
