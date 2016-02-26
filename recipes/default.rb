include_recipe 'aws'
include_recipe 'cassandra-dse::default'
include_recipe 'ntp::default'

	directory '/home/ec2-user/.aws' do
	  mode '0775'
	  action :create
	end
	template '/home/ec2-user/.aws/config' do
	  source 'config.erb'
	  owner 'ec2-user'
	  group 'ec2-user'  
	  mode '0600'
	  action :create
	end

	directory '/root/.aws' do
	  mode '0775'
	  action :create
	end
	template '/root/.aws/config' do
	  source 'config.erb'
	  owner 'root'
	  group 'root'  
	  mode '0600'
	  action :create
	end
	
node['aws-tag']['tags'].each do |key,value|
	execute 'add_tags' do
		command "aws ec2 create-tags --resources $(curl http://169.254.169.254/latest/meta-data/instance-id) --tags Key=#{key},Value=#{value}"
		action :run
	end
end

#aws_resource_tag node['ec2']['instance_id'] do
#  tags(node['aws-tag']['tags'])
#  action :update
#end

