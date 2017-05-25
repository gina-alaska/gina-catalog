pkg_name=glynx
pkg_origin=uafgina
pkg_version=$(cat $PLAN_CONTEXT/../VERSION)
pkg_maintainer="Will Fisher will@alaska.edu"
pkg_description="Application Package for gLynx"
pkg_license=('MIT')
pkg_bin_dirs=(bin)

pkg_deps=(
  core/cacerts
  uafgina/imagemagick
  uafgina/geos
  uafgina/proj
)

pkg_scaffolding=uafgina/scaffolding-ruby

pkg_expose=(9292)

# if [[ ! "$(declare -p scaffolding_symlinked_files 2> /dev/null || true)" =~ "declare -a" ]]; then
#   declare -g -a scaffolding_symlinked_files
# fi
# scaffolding_symlinked_files+=(config/puma.rb)

do_build() {
  export SSL_CERT_FILE="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
  build_line "Setting rgeo bundle config"
  _bundle config build.rgeo "--with-geos-dir=$(pkg_path_for geos) --with-proj-dir=$(pkg_path_for geos)"

  do_default_build

  return 0
}
