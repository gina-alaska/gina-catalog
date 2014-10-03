#!/bin/bash

action=$1

command="sudo service solr_glynx ${action}"

echo $command
script/devvm_ssh.sh $command