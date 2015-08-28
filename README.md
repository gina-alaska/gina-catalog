# gLynx 3.0 Data catalog

This is the first pass through the updating to the latest ruby on rails framework.

This is currently only covering the data catalog.

The cms portion will be added in 3.1

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

After checkout out the code repository use the following steps to setup the development vm.

```bash

$ cd cookbook
