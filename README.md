# README #

### What is this repository for? ###

* This repository contains a vagrantfile & puppet manifests to quickly setup a cassandra cluster for development or experimentation.
+ It's been tested with 
    * Cassandra 3.0.8
	* CentOS 7
	* Vagrant 1.7.4
	* Puppet 3.8.7
    * Windows 8 (as host)
* Without changes this project will spawn a single guest running 3 cassandra nodes in 1 cluster, which should be reachable from the host

### How do I get set up? ###

1. Install Vagrant on your host system
2. Checkout this repository
3. Run `vagrant up` in the root folder
4. Use ssh/putty to logon via the forwarded port to the guest (credentials are vagrant/vagrant), alternatively you can use `vagrant ssh` if your host has an ssh client setup
5. Cassandra authentication is disabled so you can logon with any credentials to the system keyspace from the host (eg. with [DBeaver](http://dbeaver.jkiss.org/))
    * Node1: 10.99.88.11:9042
	* Node2: 10.99.88.12:9042
	* Node3: 10.99.88.13:9042


### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact