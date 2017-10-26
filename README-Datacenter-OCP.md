# Setting Up the Datacenter with OpenShift / CDK.

## Setup CDK/KVM
- Download the Red Hat Container Development Kit (CDK) from: https://developers.redhat.com/products/cdk/download/
- I successfully used these instructions [running-cdk-3-0-on-fedora-25](https://developers.redhat.com/blog/2017/06/20/running-cdk-3-0-on-fedora-25/) for CDK v3.1.1 on my Fedora 26 laptop.
- Be sure to configure your KVM to produce a consistent IPs by changing the IPv4 configuration on your "docker-machines" profile to:
> **Network:** 192.168.107.0/24  
> **DHCP range:** 192.168.107.2 - 192.168.107.2  
> **Forwarding:** Routed network  
You may need to delete and recreate this profile in order to "edit" it.

## Configure and Start CDK
```sh
minishift setup-cdk --force --default-vm-driver="kvm"
minishift config set memory 8192
minishift config set image-caching true
minishift start
```
- The start command registers your CDK with Red Hat.  
- Registering and unregistering are lengthy processes.  To save time, after the first registration, keep that registration active by using the skip-registration and skip-unregistration options, i.e.:
```sh
minishift start --skip-registration
minishift stop --skip-unregistration
```

I created convenience shell scripts for starting and stopping, to do just that:
```sh
start-iotdj-docp.sh
stop-iotdj-docp.sh
```

## Import Images and Templates for CDK
In order to reduce dependencies on internet connectivity, run these commands to bring the container images down to your local repository.
```sh
oc login -u system:admin
oc project openshift

oc import-image iotdj-amq63-openshift:1.0 --from=registry.access.redhat.com/jboss-amq-6/amq63-openshift:latest --confirm
oc import-image iotdj-fis-java-openshift:1.0 --from=registry.access.redhat.com/jboss-fuse-6/fis-java-openshift:latest --confirm
oc import-image iotdj-datagrid65-openshift:1.0 --from=registry.access.redhat.com/jboss-datagrid-6/datagrid65-openshift:latest --confirm 
oc import-image iotdj-decisionserver64-openshift:1.0 --from=registry.access.redhat.com/jboss-decisionserver-6/decisionserver64-openshift:latest --confirm 

oc replace --force -n openshift -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-template.yaml
oc replace --force -n openshift -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-persistent-template.yaml
```

## Create a Project in CDK
I'm a web console proponent, so I will walk you through the web experience.  There are command line versions for each command as well, if you so desire.

1) If you have configured the KVM correctly, your OpenShift Container Platform console should be located at: https://192.168.107.2:8443/console/
2) Click the "Create Project" button.
3) Fill out the "Create Project" form:
> **Name:** iotdj-docp  
> **Display Name:** IoT DemoJam Datacenter OCP  
> **Description:** Internet of Things DemoJam :: Datacenter OpenShift Container Platform
4) Press the "Create" button.

## Create a [Nexus Repository](https://www.sonatype.com/nexus-repository-sonatype) Pod to Build Faster
For more information, see: https://blog.openshift.com/improving-build-time-java-builds-openshift/
1) After creating the project, you are left on the "Browse Catalog" page.  Select "Uncategorized", which should be the last category.
2) Because you loaded the templates above, you should see an option for a "nexus3-persistent" pod; select it.
3) Fill out the template:
> **Sonatype Nexus service name:** nexus  *(default value)*  
> **Sonatype Nexus version:** 3.5.2  *(as the time of writing this, later versions should be fine as well - Check https://hub.docker.com/r/sonatype/nexus3/tags/)*  
> **VOLUME_CAPACITY:** 2Gi  *(default value)*
4) Press the "Create" button.
5) Press "Continue to overview".
6) Wait for the pod to deploy.

## Since We Are Waiting and You Are Apparently Reading Ahead, Let's Setup the Membership
1) Select the "Resources" - "Membership" menu item, you should see yourself as the user.
2) Press the "Edit Membership" button.
3) Select the "Service Accounts" tab.
4) For the "iotdj-docp / deployer" account, "Add Another Role" of "view" from the drop-down and click the "Add" button.
5) Select the "System Groups" tab.
6) For the "system:serviceaccounts:iotdj-docp" group, "Add Another Role" of "view" from the drop-down and click the "Add" button.
7) Press the "Done Editing" button.

## Add One More Service Account for REST API Calls
For more information, see: https://docs.openshift.com/container-platform/3.5/rest_api/index.html#rest-api-serviceaccount-tokens  
I don't think there is a web equivalent for these commands, so ... to the command line.
1) Create the account with:
```sh
oc create serviceaccount robot
```
2) Add the admin role to the account with:
```sh
oc policy add-role-to-user admin system:serviceaccounts:iotdj-docp:robot
```
3) Since we are here and will need the token for the drone code later, get the token with:
```sh
oc serviceaccounts get-token robot
```

## Let's Configure Our New Nexus Pod
Your Nexus Repository Manager pod should be ready.
1) Going back to the OpenShift console, click on the Nexus route, which should be: http://nexus-iotd-docp.192.168.107.2.nip.io
2) Sign in with the default account setup:
> **Username:** admin  
> **Password:** admin123  
> Change the account password as per your sense of security dictates.
3) Create a maven2 proxy repository for MQTT:
> Click the gear icon. *(Server administration and configuration)*  
> Click the "Repositories" button.  
> Click the "+ Create repository" button.  
> Select the "maven2 (proxy)" recipe.  
> Fill out the 2 values in red:  
>> **Name:** paho-mqtt-client  
>> **Proxy - Remote storage:** https://repo.eclipse.org/content/repositories/paho-releases/  
> Click the "Create repository" button
4) And we need to make redhat-ga and our new paho-mqtt-client publicly available:
> Back on the Repositories list, select the "maven-public" repository.  
> Under the "Group" section select the "redhat-ga" repository and move it over the the "Members" list with the ">" button.  
> Do the same for your new "paho-mqtt-client" repository.  
> Click the "Save" button.
5) One last thing, we need to add our Business Rules to the Nexus repository.  In the [IoT-DemoJam_Datacenter-OCP_BusinessRules](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_BusinessRules) project there is a [shell script](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_BusinessRules/blob/master/maven-add.sh) to compile and add the jar to Nexus.
```sh
. maven-add.sh
```

## More Pods!
Please see the other project's read-me's for the remaining pods.  
[IoT-DemoJam_Datacenter-OCP_FIS](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_FIS/blob/master/README.md) for AMQ and Fuse Integration Service  
[IoT-DemoJam_Datacenter-OCP_BRMSDS](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_BRMSDS/blob/master/README.md) for Data Grid and BRMS Decision Server

## ExternalIPs have been disabled?
If you get an error message, as per this title, the following [solution](https://access.redhat.com/solutions/2464791) for OpenShift helped me with CDK.  
This happened inconsistently, and even after applying the solution, sometimes I still had issues with external resources.  Sadly, bouncing minishift seemed to help, and if you come up clean, you are good to go.
```sh
minishift ssh
sudo vi /mnt/sda1/var/lib/minishift/openshift.local.config/master/master-config.yaml
```
Change the following line, save and then exit the shell:
```
- externalIPNetworkCIDRs: null
+ externalIPNetworkCIDRs: ["0.0.0.0/0"]
```
