#
# Cookbook:: prepare_env
# Recipe:: ec2nginx
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# include_recipe "nodejs::nodejs_from_package"
# include_recipe "nodejs::npm"

apt_update 'update apt' do
    frequency 86400
    action :periodic
end

docker_service 'default' do
    action [:create, :start]
end

execute 'enable docker permission' do
    command 'chmod 777 /var/run/docker.sock'
    # elevated true
end

docker_image 'awsacdev/build_nginx' do
    tag 'latest'
    action :pull
end

docker_container 'nginxweb' do
    repo 'awsacdev/build_nginx'
    tag 'latest'
    port '80:80'
    # volumes ['/path/:/pathincontainer']
    action :run
end



directory '/htmlfile' do
    action :create
end

# cookbook_file '/warfile/Devops_maven_1-1.0.0.war' do
#     source 'Devops_maven_1-1.0.0.war'
# end

remote_directory '/htmlfile' do
    source 'htmlfile'
end

execute 'copy html file to docker' do
    command 'docker container cp /htmlfile/. nginxweb:/usr/share/nginx/html'
end