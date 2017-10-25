# Setting up the Datacenter with OpenShift / CDK.

## Setup CDK/KVM
1) Download CDK from: https://developers.redhat.com/products/cdk/download/
2) I successfully used these instructions (running-cdk-3-0-on-fedora-25)[https://developers.redhat.com/blog/2017/06/20/running-cdk-3-0-on-fedora-25/] for CDK v3.1.1 on my Fedora 26 laptop. 
3) Be sure to configure your KVM to produce a consistent IP by changing the Ipv4 configuration on your "docker-machines" profile to:
- Network: 192.168.107.0/24
- DHCP range: 192.168.107.2 - 192.168.107.2
- Forwarding: Routed network
You may need to delete and recreate this profile in order to "edit" it.

## Configure and start CDK
minishift setup-cdk --force --default-vm-driver="kvm"
minishift config set memory 8192
minishift config set image-caching true
minishift start

The start command registers your CDK with Red Hat.
Registering and unregistering are lengthy processes.  To save time, after the first registration, keep that registration active by using the skip-registration and skip-unregistration options:
i.e.: 
  minishift start --skip-registration
  minishift stop --skip-unregistration

I created convenience shell scripts for starting and stopping:
  start-iotdj-docp.sh
  stop-iotdj-docp.sh

## Import Images and templates for CDK
In order to reduce dependencies on internet connectivity, run these commands to bring the container images down to your local repository.

oc login -u system:admin
oc project openshift

oc import-image iotdj-amq63-openshift:1.0 --from=registry.access.redhat.com/jboss-amq-6/amq63-openshift:latest --confirm
oc import-image iotdj-fis-java-openshift:1.0 --from=registry.access.redhat.com/jboss-fuse-6/fis-java-openshift:latest --confirm
oc import-image iotdj-datagrid65-openshift:1.0 --from=registry.access.redhat.com/jboss-datagrid-6/datagrid65-openshift:latest --confirm 
oc import-image iotdj-decisionserver64-openshift:1.0 --from=registry.access.redhat.com/jboss-decisionserver-6/decisionserver64-openshift:latest --confirm 

oc replace --force -n openshift -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-template.yaml
oc replace --force -n openshift -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-persistent-template.yaml

## Create a Project in CDK
I'm a web console proponent, so I will walk you through the web experience.  There are command line versions for each command as well, if you so desire.

1) If you have configured the KVM correctly, your OpenShift Container Platform console should be located at: https://192.168.107.2:8443/console/
2) Click the "Create Project" button.
3) Fill out the "Create Project" form:
- Name: iotdj-docp
- Display Name: IoT DemoJam Datacenter OCP
- Description: Internet of Things DemoJam :: Datacenter OpenShift Container Platform
4) Press the "Create" button.

## Create a Nexus pod to help the build processes build faster
1) After creating the project, you are left on the "Browse Catalog" page.  Select "Uncategorized", which should be the last category.
2) Because you loaded the templates above, you should see an option for a "nexus3-persistent" pod; select it.
3) Fill out the template:
- Sonatype Nexus service name: nexus  (default value)
- Sonatype Nexus version: 3.5.2  (as the time of writing this, later versions should be fine as well - Check https://hub.docker.com/r/sonatype/nexus3/tags/).
- VOLUME_CAPACITY: 2Gi  (default value)
4) Press the "Create" button.
5) Press "Continue to overview".
6) Wait for the pod to deploy.

## Since we are waiting and you are apparently reading ahead, let's setup some membership values
1) Select the "Resources" - "Membership" menu item, you should see yourself as the user.
2) Press the "Edit Membership" button.
3) Select the "Service Accounts" tab.
4) For the "iotdj-docp / deployer" account, "Add Another Role" of "view" from the drop-down and click the "Add" button.
5) Select the "System Groups" tab.
6) For the "system:serviceaccounts:iotdj-docp" group, "Add Another Role" of "view" from the drop-down and click the "Add" button.
7) Press the "Done Editing" button.

## We have one more service account to add, to allow REST API calls to Openshift/CDK
See https://docs.openshift.com/container-platform/3.5/rest_api/index.html#rest-api-serviceaccount-tokens
I don't think there is a web equivalent for these commands, so ... to the command line.
1) Create the account with:
  oc create serviceaccount robot
2) Add the admin role to the account with:
  oc policy add-role-to-user admin system:serviceaccounts:iotdj-docp:robot
3) Since we are here and will need the token for the drone code, get the token with:
  oc serviceaccounts get-token robot

