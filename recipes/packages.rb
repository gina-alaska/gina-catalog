app_name = "glynx"

node[app_name]['package_deps'].each do |pkg|
  package pkg do
    action :install
  end
end
