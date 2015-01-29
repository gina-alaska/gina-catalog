include_recipe 'memcached::default'

service 'memcached' do
  action [:enable, :start]
end
