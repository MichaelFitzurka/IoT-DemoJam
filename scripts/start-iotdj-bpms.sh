#!/bin/bash

cd ~/Projects/IoT_DemoJam/IoT-DemoJam_Datacenter_BPMS/jboss-eap-7.0
bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Dorg.kie.override.deploy.enabled=true -Djava.security.egd=file:/dev/urandom:wq!
