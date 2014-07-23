#!/bin/bash

action=$1

command="cd glynx && chruby-exec 1.9 -- bundle ${action}"

echo $command
script/devvm_ssh.sh $command