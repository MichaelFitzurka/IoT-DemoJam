#!/bin/bash

if [ "$(minishift status)" == "Running" ]
then
  echo "Minishift already started"
else
  echo "Starting minishift..."
  minishift start --skip-registration
  minishift console
fi
