'    Copyright 2013 Mirantis, Inc.
'
'    Licensed under the Apache License, Version 2.0 (the "License"); you may
'    not use this file except in compliance with the License. You may obtain
'    a copy of the License at
'
'         http://www.apache.org/licenses/LICENSE-2.0
'
'    Unless required by applicable law or agreed to in writing, software
'    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
'    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
'    License for the specific language governing permissions and limitations
'    under the License.

' This script creates a master node for the product, launches its installation,
' and waits for its completion


' Create master node for the product
dim name
name = vm_name_prefix + "master"
if is_vm_present(name) then
	delete_vm name
end if
create_vm name, host_nic_name(0), vm_master_cpu_cores, vm_master_memory_mb, vm_master_disk_mb

' Add additional NICs
add_hostonly_adapter_to_vm name, 2, host_nic_name(1)

' Add NAT adapter for internet access
add_nat_adapter_to_vm name, 3, vm_master_nat_network

' Mount ISO with installer
mount_iso_to_vm name, iso_path

' Start virtual machine with the master node
start_vm name

' Wait until the machine gets installed and Puppet completes its run
wscript.echo vm_master_ip+ " " + vm_master_username+ " " + vm_master_password
wait_for_product_vm_to_install vm_master_ip, vm_master_username, vm_master_password

'' Enable outbound network/internet access for the machine
enable_outbound_network_for_product_vm vm_master_ip, vm_master_username, vm_master_password, 3, vm_master_nat_gateway

' Report success
wscript.echo "Master node has been installed."
