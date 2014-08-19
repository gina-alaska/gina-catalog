#!/bin/bash

cd cookbook

if [ ! -f .vagrant_ssh_config ]; then 
  vagrant ssh-config > .vagrant_ssh_config
fi

ssh -F .vagrant_ssh_config vagrant@default "TERM=dumb $@"