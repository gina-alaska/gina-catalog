# This file is the heart of your application's habitat.
# See full docs at https://www.habitat.sh/docs/reference/plan-syntax/

# Required.
# Sets the name of the package. This will be used in along with `pkg_origin`,
# and `pkg_version` to define the fully-qualified package name, which determines
# where the package is installed to on disk, how it is referred to in package
# metadata, and so on.
pkg_name=glynx

# Required unless overridden by the `HAB_ORIGIN` environment variable.
# The origin is used to denote a particular upstream of a package.
pkg_origin=uafgina

# Required.
# Sets the version of the package.
pkg_version=$(cat $PLAN_CONTEXT/../VERSION)

# Required.
# A URL that specifies where to download the source from. Any valid wget url
# will work. Typically, the relative path for the URL is partially constructed
# from the pkg_name and pkg_version values; however, this convention is not
# required.
pkg_source=nosource.tar.gz

# Required if a valid URL is provided for pkg_source or unless do_verify() is overridden.
# The value for pkg_shasum is a sha-256 sum of the downloaded pkg_source. If you
# do not have the checksum, you can easily generate it by downloading the source
# and using the sha256sum or gsha256sum tools. Also, if you do not have
# do_verify() overridden, and you do not have the correct sha-256 sum, then the
# expected value will be shown in the build output of your package.
# pkg_shasum=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

# Optional.
# The name and email address of the package maintainer.
pkg_maintainer="Will Fisher will@alaska.edu"

# Required for core plans, optional otherwise.
# A short description of the package. It can be a simple string, or you can
# create a multi-line description using markdown to provide a rich description
# of your package.
pkg_description="Application Package for gLynx"

# Optional.
# An array of valid software licenses that relate to this package.
# Please choose a license from http://spdx.org/licenses/
pkg_license=('MIT')

# Optional.
# An array of paths, relative to the final install of the software, where
# binaries can be found. Used to populate PATH for software that depends on
# your package.
pkg_bin_dirs=(bin)

# Optional.
# An array of the package dependencies needed only at build time.
pkg_build_deps=(
  core/coreutils
  core/gcc
  core/gcc-libs
  core/make
  core/git
  core/which
  core/pkg-config
  core/curl
)

pkg_deps=(
  core/bundler/1.13.7
  core/ruby/2.3.1/20161214031900
  core/cacerts
  core/glibc
  core/libffi
  core/libyaml
  core/libxml2
  core/libxslt
  core/postgresql
  core/node
  core/openssl
  core/zlib
  uafgina/imagemagick
  uafgina/geos
  uafgina/proj
)

pkg_expose=(9292)

do_download() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  return 0
}

do_prepare() {
  build_line "Setting link for /usr/bin/env to 'coreutils'"
  [[ ! -f /usr/bin/env ]] && ln -s $(pkg_path_for coreutils)/bin/env /usr/bin/env

  build_line "Setting link for /usr/bin/which to 'which'"
  [[ ! -f /usr/bin/which ]] && ln -s $(pkg_path_for which)/bin/which /usr/bin/which

  build_line "Setting link for /usr/bin/pkg-config to 'pkg-config'"
  [[ ! -f /usr/bin/which ]] && ln -s $(pkg_path_for pkg-config)/bin/pkg-config /usr/bin/pkg-config

  return 0
}

do_build() {
  # splitting these out to deal with issue of files
  # from tmp and preventing kitchen related stuff form being copied.
  cp -a $PLAN_CONTEXT/../Gemfile .
  cp -a $PLAN_CONTEXT/../Gemfile.lock .
  cp -a $PLAN_CONTEXT/../README.md .
  cp -a $PLAN_CONTEXT/../Rakefile .
  cp -a $PLAN_CONTEXT/../VERSION .
  cp -a $PLAN_CONTEXT/../config.ru .

  cp -a $PLAN_CONTEXT/../app .
  cp -a $PLAN_CONTEXT/../bin .
  cp -a $PLAN_CONTEXT/../config .
  cp -a $PLAN_CONTEXT/../db .
  cp -a $PLAN_CONTEXT/../lib .
  cp -a $PLAN_CONTEXT/../portal_templates .
  cp -a $PLAN_CONTEXT/../public .
  cp -a $PLAN_CONTEXT/../vendor .

  mkdir log

  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"

  local _bundler_dir=$(pkg_path_for core/bundler)
  local _libxml2_dir=$(pkg_path_for core/libxml2)
  local _libxslt_dir=$(pkg_path_for core/libxslt)
  local _postgresql_dir=$(pkg_path_for core/postgresql)
  local _pg_config=${_postgresql_dir}/bin/pg_config
  local _zlib_dir=$(pkg_path_for zlib)

  # Update ssl ca for bundler to use
  export GIT_SSL_CAINFO="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
  export SSL_CERT_FILE="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"

  export GEM_HOME=${pkg_path}/vendor/bundler
  export GEM_PATH=${_bundler_dir}:${GEM_HOME}

  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pkg_path_for gcc-libs)/lib

  # don't let bundler split up the nokogiri config string (it breaks
  # the build), so specify it as an env var instead
  # -- Thanks JTimberman for writing this!
  export NOKOGIRI_CONFIG="--use-system-libraries --with-zlib-dir=${_zlib_dir} --with-xslt-dir=${_libxslt_dir} --with-xml2-include=${_libxml2_dir}/include/libxml2 --with-xml2-lib=${_libxml2_dir}/lib"
  bundle config build.nokogiri '${NOKOGIRI_CONFIG}'
  build_line "Setting pg_config=${_pg_config}"
  bundle config build.pg --with-pg-config=$_pg_config

  build_line "Setting rgeo bundle config"
  bundle config build.rgeo "--with-geos-dir=$(pkg_path_for geos) --with-proj-dir=$(pkg_path_for geos)"

  # Remove the specific ruby version, because our ruby is 2.3
  sed -e 's/^ruby.*//' -i Gemfile

  build_line "Vendoring Gems"
  bundle install --jobs 2 --retry 5 --deployment --with production --without development test

  build_line "Precompiling Assets"
  bin/rake assets:precompile HAB_PRECOMPILE=true

  build_line "Create tmp"
  bin/rake tmp:create
}

do_install() {
  cp -a . "${pkg_prefix}/static"

  for binstub in ${pkg_prefix}/static/bin/*; do
    build_line "Setting shebang for ${binstub} to 'ruby'"
    [[ -f $binstub ]] && sed -e "s#/usr/bin/env ruby#$(pkg_path_for ruby)/bin/ruby#" -i "$binstub"
  done

  if [[ `readlink /usr/bin/env` = "$(pkg_path_for coreutils)/bin/env" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/env'"
    rm /usr/bin/env
  fi

  if [[ `readlink /usr/bin/which` = "$(pkg_path_for coreutils)/bin/which" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/which'"
    rm /usr/bin/which
  fi

  if [[ `readlink /usr/bin/pkg-config` = "$(pkg_path_for pkg-config)/bin/pkg-config" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/pkg-config'"
    rm /usr/bin/pkg-config
  fi
 }