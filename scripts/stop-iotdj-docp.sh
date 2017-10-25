#!/bin/bash

if [ "$(minishift status)" == "Running" ]
then
  echo "Stoping minishift..."
  minishift stop --skip-unregistration
else
  echo "Minishift already stoped"
fi
