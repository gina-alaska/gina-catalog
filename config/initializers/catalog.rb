# module NSCatalog
#   class Application
#     config.theme                = 'default'
#     config.deploy_path          = "/www/glynx/current"
#     config.catalog_uploads_path = "#{config.deploy_path}/uploads"
#     config.archive_path         = "#{config.deploy_path}/archive"
#     config.repo_clones          = "#{config.deploy_path}/repo_clones"
#     config.repos_path           = "#{config.deploy_path}/repos"
#     config.repos_tmp            = "#{config.deploy_path}/tmp/repos"
#
#     require "#{config.root}/extras/gitrack/lib/git_http"
#     config.middleware.use GitHttp::Middleware, {
#       :project_root => "#{config.repos_path}",
#       :uri_root => '/repos',
#       :git_path => '/usr/bin/git',
#       :upload_pack => true,
#       :receive_pack => true,
#     }
#   end
# end
# =
