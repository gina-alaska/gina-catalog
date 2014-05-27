app_name = "glynx"


#This ensures that libgoes is installed before the bundle phase 
include_recipe_now 'yum-epel'

node[app_name]['package_deps'].each do |pkg|
  package pkg do
    action :install
  end.run_action(:install)
end
