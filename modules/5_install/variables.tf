################################################################
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# ©Copyright IBM Corp. 2020
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################

variable "cluster_domain" {
  default   = "example.com"
}
variable "cluster_id" {
  default   = "test-ocp"
}

variable "dns_forwarders" {
    default   = "8.8.8.8; 9.9.9.9"
}
variable gateway_ip {}
variable cidr {}
variable allocation_pools {}

variable "bastion_ip" {}
variable "rhel_username" {}
variable "private_key" {}
variable "ssh_agent" {}
variable "connection_timeout" {}
variable "jump_host" {}

variable "bootstrap_ip" {}
variable "master_ips" {}
variable "worker_ips" {}

variable bootstrap_mac {}
variable master_macs {}
variable worker_macs {}

variable "openshift_client_tarball" {}
variable "openshift_install_tarball" {}

variable "public_key" {}
variable "pull_secret" {}
variable "release_image_override" {}

variable "enable_local_registry" {}
variable "local_registry_image" {}
variable "ocp_release_tag" {}

variable helpernode_repo { default = "https://github.com/RedHatOfficial/ocp4-helpernode" }
variable helpernode_tag { default = "master" }
variable install_playbook_repo { default = "https://github.com/ocp-power-automation/ocp4-playbooks" }
variable install_playbook_tag { default = "master" }

variable "storage_type" {}
variable "log_level" {}

variable "ansible_extra_options" {}
variable "rhcos_kernel_options" {}

variable "sysctl_tuned_options" {}
variable "sysctl_options" {}
variable "match_array" {}
variable "chrony_config" { default = true }
variable "chrony_config_servers" {}

variable "setup_squid_proxy" {}
variable "proxy" {}

variable "upgrade_version" {}
variable "upgrade_channel" {}
variable "upgrade_pause_time" {}
variable "upgrade_delay_time" {}

variable "http_server_ip" { default = "10.4.78.33" }
variable "http_server_subdir" {}
variable "http_server_url" {}
variable "powervm_rmc_image" {}
variable "nfs_client_provisioner_image" {}
