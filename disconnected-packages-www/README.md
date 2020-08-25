# Disconnected packages for OCP installation

## Installation

### Mirror Registries 

Mirror the openshift registry to your local private registry.
example:`quay.io/openshift-release-dev/ocp-release:4.3.33-ppc64le`

also mirror the following ppc64le images into your local repo (needed for nfs automatic provisioner and powerVM RMC (DLPAR*, LPM enablement))

```
quay.io/powercloud/rsct-ppc64le
ibmcom/nfs-client-provisioner-ppc64le:latest
```

> ***\* DLPAR note:** some changes like modifying the number a cores/threads or memory need a kubelet restart to update the new resource count into k8s.*

Update the following variables into your terraform tfvars file.

`disconnected_install_registry`: URL of the external registry used for openshift Installation 
OPenshift release must be fetch and imported into this internal registry for disconnected installation.

`disconnected_install_registry_cert`: Registry Certificate. put this into a file on the terraform server. It will be upload to the bastion server and deploy on each node in the cluster during OCP installation.

`disconnected_install_registry_ip`: IP of the external registry. This information is used in order to setup the OCP DNS server on Bastion node.

`disconnected_install_registry_fqdn`: fqdn of the external registry. This information is used in order to setup the OCP DNS server on Bastion node.

`pull_secret_file`: Must be point to a json file which contains the secret to connect to your internal registry.

`powervm_rmc_image`: specify where the powervc_rmc docker image is located (default is internet)
you can point to your internal registry after having mirrored `quay.io/powercloud/rsct-ppc64le`

`nfs_client_provisioner_image`: specify where the powervc_rmc docker image is located (default is internet)
you can point to your internal registry after having mirrored `ibmcom/nfs-client-provisioner-ppc64le:latest`

### Copy Additional Packages on http server

Just copy this pacakges on a http server accessible from all the nodes of the Cluster (bastion + master + worker)

Update the terraform variable file with the following:

`http_server_ip`: IP of the http server used to store "disconnected packages"

`http_server_subdir`: subdir in the http server where packages are stored (optional means located on the wwwroot)

`openshift_install_tarball` : http url to `openshift-install-linux.tar.gz`

`openshift_client_tarball`: http url to `openshift-client-linux.tar.gz`

### Montpellier var-ocp-disconnected.tfvars example (for reference)

```
### Configure the OpenStack Provider
auth_url                    = "https://10.4.78.1:5000/v3/"
user_name                   = "root"
password                    = "powerlinux"
tenant_name                 = "ibm-default"
domain_name                 = "Default"
openstack_availability_zone = ""

### Configure the Instance details
network_name                = "vlan478"
#network_type               = "SRIOV"
scg_id                      = "49ba71f8-a9c9-483b-8ac0-2bfcd3dc4761"
rhel_username               = "root"
#keypair_name                = "mykeypair"
public_key_file             = "data/id_rsa.pub"
private_key_file            = "data/id_rsa"
private_key                 = ""
public_key                  = ""
rhel_subscription_username  = "thierry.huche@fr.ibm.com"
rhel_subscription_password  = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# installeur 4.3 279c3e4f-93d2-47c4-b6a2-22ccb3e85a6a
# installeur 4.5 b407e4a6-3804-4753-af2b-9cb015902d69

bastion                     = {instance_type    = "bastion", image_id     = "ff1df1ef-b98a-482f-9644-4a0b867ac69a"}
bootstrap                   = {instance_type    = "coreos", image_id     = "279c3e4f-93d2-47c4-b6a2-22ccb3e85a6a",  "count"   = 1}
master                      = {instance_type    = "master-mini",  image_id     = "279c3e4f-93d2-47c4-b6a2-22ccb3e85a6a",  "count"   = 3}
worker                      = {instance_type    = "worker-mini",  image_id     = "279c3e4f-93d2-47c4-b6a2-22ccb3e85a6a",  "count"   = 2}


### OpenShift variables
#openshift_install_tarball   = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/latest-4.5/openshift-install-linux.tar.gz"
#openshift_client_tarball    = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/latest-4.5/openshift-client-linux.tar.gz"
openshift_install_tarball   = "http://10.4.78.33/disconnected_install/openshift-install-linux.tar.gz"
openshift_client_tarball    = "http://10.4.78.33/disconnected_install/openshift-client-linux.tar.gz"

#pull_secret_file = "data/pull-secret.txt"
pull_secret_file = "data/pull-secret-disconnected.json"
cluster_domain = "fit.com"
cluster_id_prefix = "fit"
cluster_id = "ocp"

dns_forwarders      = "10.11.5.2; 10.11.5.1"
mount_etcd_ramdisk  = false
installer_log_level = "debug"
ansible_extra_options = "-v"
rhcos_kernel_options  = ["slub_max_order=0"]
sysctl_tuned_options  = false
#sysctl_options = ["kernel.shmmni = 16384", "net.ipv4.tcp_tw_reuse = 1"]
#match_array = <<EOF
#- label: node-role.kubernetes.io/master
#- label: icp4data
#  value: database-db2oltp
#  type: pod
#- label: disk
#  value: ssd
#EOF
chrony_config = true
chrony_config_servers = [ {server = "10.3.21.254", options = "iburst"} ]

## Uncomment any one of the below formats to use proxy. Default 'port' will be 3128 if not specified. Not authenticated if 'user' is not specified.
#proxy = {}
#proxy = {server = "hostname_or_ip"}
#proxy = {server = "hostname_or_ip", port = "3128", user = "pxuser", password = "pxpassword"}

#storage_type    = "nfs"
#volume_size = "300" # Value in GB
volume_storage_template = "V9002_FIT"

#upgrade_image = ""
#upgrade_pause_time = "90"
#upgrade_delay_time = "600"

## Disconnected Installation
#enable_local_registry = true
#ocp_release_tag = "4.5.5-ppc64le"
http_server_ip = "10.4.78.33"
http_server_subdir = "disconnected_install"

disconnected_install_registry = "myregistry:5000/ocp/openshift4"
disconnected_install_registry_cert = "data/domain.crt"
disconnected_install_registry_ip = "10.4.78.33"
disconnected_install_registry_fqdn = "myregistry"

powervm_rmc_image = "myregistry:5000/powercloud/rsct-ppc64le:latest"
nfs_client_provisioner_image = "myregistry:5000/ibmcom/nfs-client-provisioner-ppc64le:latest"
```

## Disconnected Package list 

Here is the list of the package we need to get for a complete Openshift disconnected installation with terraform and ansible and how to get them.

## openshift install and client

Those two files (`openshift-client-linux.tar.gz` and `openshift-install-linux.tar.gz`) must be downloaded from **mirror.openshift.com** (to be adapted with the version you need)

https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/stable-4.3/

## Ansible playbook

- ocp4-helpernode (for fit)

```
git clone https://github.com/schabrolles/ocp4-helpernode.git
cd ocp4-helpernode
git archive --format=tgz -o ../ocp4-helpernode.tar.gz --prefix=ocp4-helpernode/ fit
```

- ocp4-playbooks (for fit)

```
git clone https://github.com/schabrolles/ocp4-playbooks.git
cd ocp4-playbooks
git archive --format=tgz -o ../ocp4-playbooks.tar.gz --prefix=ocp4-playbooks/ fit
```

## python-openshift python module (pip)

Preparing a local install for pip module openshift.

On a RHEL system (same major version than bastion node)
```
mkdir python-openshift
pip download -d ./python-openshift openshift 
tar zcvf python-openshift.tar.gz python-openshift
```

## helm binary (needed by ocp4-helpernode ansible playbook)

This package is needed by ocp4-helpernode ansible playbook.

https://get.helm.sh/helm-v3.3.0-linux-ppc64le.tar.gz
