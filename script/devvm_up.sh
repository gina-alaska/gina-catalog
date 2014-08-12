#!/bin/bash

pushd .
cd cookbook
if [ ! -f Gemfile.lock ]; then
  bundle
fi

if [ ! -f Berksfile.lock ]; then
  berks install
fi

vagrant up
popd

script/devvm_bundle.sh install
script/devvm_unicorn.sh start
script/devvm_solr.sh start

echo "********************************************************************"
echo "* If this is your first time starting the development environment, *"
echo "* you should run 'script/devvm_sunspot_reindex.sh' next            *"
echo "********************************************************************"
