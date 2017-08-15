# gLynx 3.0 Data catalog

This is the first pass through the updating to the latest ruby on rails framework.

This is currently only covering the data catalog.

The cms portion will be added in 3.1

## Concourse testing

testing concourse, another change

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
$ bundle
$ bundle exec rake dev:rebuild
$ bundle exec rails server
$ open http://localhost:9292
# click manager login at the bottom of the page
$ rake "admin:set[YOUREMAIL]"
# refresh the page

```

It should be noted that while the vm is setup and configured to run nginx and puma internally it is currently not recommended that you use that for accessing the application.  It will perform very poorly due to the way vm uses shared folders to access the development code, accessing the database and all other services installed into the vm will behave fine though.


## Notes on building habitat packages

From the root of the gina-catalog repo directory run the following commands.

```bash
hab studio enter
build
# create docker image for local testing
hab pkg export docker uafgina/glynx
```

You can examine the `results/last_build.env` file to see the details about the build package
Resulting `hart` packages will be created as `results/uafgina-glynx-VERSION-PKGIDENT.hart`

### Testing locally using docker

**TODO: Convert this to use a postgresql with postgis docker container instead of trying to use an instance on the host machine.**

This requires a few things to work.

1. Locally running postgresql that docker containers can connect to.
2. Updating the docker-compose.yml file with the details needed to connect to the postgresql server
```
db={user='postgres',password='',port='5432',host='10.19.16.195'}
```
3. Run the `docker-compose up`
4. If there is no `glynx_production` database created you may need to run `docker exec DOCKERINSTANCEID hab pkg exec uafgina/glynx glynx-rake db:create`
5. After a short delay you should see the pumas start
6. Run `docker ps` to see the port that `9292` is mapped to on the localhost, in the example below that would be `32771`
```
b5ea6ceaf806        uafgina/glynx                                      "/init.sh start ua..."   22 seconds ago      Up 21 seconds       9631/tcp, 0.0.0.0:32771->9292/tcp   ginacatalog_glynx_1
```
7. Open a browser and point to `localhost:PORT`

### Depends on a custom version of the core/scaffolding-ruby package (uafgina/scaffolding-ruby)
