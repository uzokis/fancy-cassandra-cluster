### What is this repository for? ###

* This repository contains a vagrantfile & puppet manifests to quickly setup a cassandra cluster for development or experimentation.
+ It's been tested with 
    * [Cassandra 3.0.8](http://cassandra.apache.org/)
	* [CentOS 7](https://www.centos.org/)
	* [Vagrant 1.7.4](https://www.vagrantup.com/)
	* [Puppet 3.8.7](https://puppet.com/) (masterless)
    * [VirtualBox 5.0.26](https://www.virtualbox.org/)
    * Windows 8 (as host)
* Without changes this project will spawn a single guest running 3 cassandra nodes in 1 cluster, which should be reachable from the host. The cluster contains no data.

### How do I get set up? ###

1. Install [Vagrant](https://www.vagrantup.com/) & [VirtualBox](https://www.virtualbox.org/) on your host system. 
2. Clone this repository to a local directory.
3. Run `vagrant up` in the root folder. Vagrant & puppet will now automatically provision the guest system and when the process is finished you'll have your cassandra cluster up & running.
4. Use ssh/putty to logon via the forwarded port to the guest (credentials are vagrant/vagrant), alternatively you can use `vagrant ssh` if your host has an ssh client on the path.
5. Cassandra authentication is disabled so you can logon with any credentials to the system keyspace from the host (eg. with [DBeaver](http://dbeaver.jkiss.org/)), these are the default interfaces which should be available:
    * Node1: 10.99.88.11:9042
	* Node2: 10.99.88.12:9042
	* Node3: 10.99.88.13:9042

### What to configure where? ###

If you're not happy with the standard behavior feel free to adapt the scripts, here are some guidelines:

* Change guest properties such as available memory, network interfaces,... in `Vagrantfile`
* `puppet/manifests/default.pp` is the starting point for the puppet agent, it installs/prepares prerequisites for the cassandra installation (java, downloads the cassandra binary, defines 3 nodes) and defines configuration used in the cassandra_node module (ip, ports)
* `puppet/modules/cassandra/manifests/cassandra_node.pp` actually installs a node and enables & starts it as a service (using systemd)
* `puppet/manifests/cassandra/templates/` this folder contains generic cassandra config file templates & a systemd template

### Useful commands ###
#### Cassandra & CentOS (in the guest) ####
* `systemctl stop cassandra-node1` - Stop a node
* `systemctl start cassandra-node2` - Start a node
* `systemctl status cassandra-node2` - Check the process status of a node
* `/opt/cassandra/node1/bin/nodetool status` - Check the status of the cluster

#### Vagrant (in the host) ####
* `vagrant up` - Bring the guest system up, provision if non-existent
* `vagrant provision` - run the provisioning (will trigger a puppet run)
* `vagrant reload` - restart the guest

### On the TODO list ###
* Spawn a hardened, production-ready cluster: http://thelastpickle.com/blog/2015/09/30/hardening-cassandra-step-by-step-part-1-server-to-server.html
* Create some alternative Vagrantfiles & puppet manifests to spawn multi-machine clusters
* Test more versions and rename the templates to version specific config files

### Who do I talk to? ###

* You can find me on twitter: [@vanfraeyenhove](https://twitter.com/vanfraeyenhove)