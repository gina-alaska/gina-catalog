# gLynx 3.0 Data catalog

This is the first pass through the updating to the latest ruby on rails framework.

This is currently only covering the data catalog.

The cms portion will be added in 3.1

## Concourse testing

testing concourse

## Development Requirements

* Ruby 2.1+
* Bundler
* ChefDK
* PhantomJS (for running integration tests)
* GVM (https://github.com/gina-alaska/gvm)
* NodeJS
* VirtualBox (5.0.2+)
* Vagrant
  * <code>vagrant plugins install vagrant-berkshelf</code>
  * <code>vagrant plugins install vagrant-omnibus</code>

## Setting up development environment

If you currently have been using GVM to run the development vm it is recommended that you shutdown and delete the currently running vm.  And then to make sure that you have the latest version of VirtualBox installed (5.0.2) as well as the ChefDK installed and configured to be in your path.

After checkout out the code repository use the following steps to setup the development vm.

```bash

# install latest version of vagrant, virtualbox and chefdk!
$ cd cookbook
$ kitchen converge
$ cd ..
$ bundle
$ bundle exec rake db:seed searchkick:reindex:all
$ bundle exec rake db:seed searchkick:reindex:all RAILS_ENV=test
$ bundle exec rake test # all test should pass!
$ bundle exec rails server
$ open http://catalog.192.168.222.225.xip.io

```

It should be noted that while the vm is setup and configured to run nginx and puma internally it is currently not recommended that you use that for accessing the application.  It will perform very poorly due to the way vm uses shared folders to access the development code, accessing the database and all other services installed into the vm will behave fine though.
