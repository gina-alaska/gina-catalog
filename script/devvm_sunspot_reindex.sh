#!/bin/bash

command="cd glynx && chruby-exec 1.9 -- bundle exec rake sunspot:reindex"

echo $command
script/devvm_ssh.sh $command