include cassandracluster

class cassandracluster {
  $version = '3.0.8'
  $basedir = '/opt/cassandra'
  $user = 'cassandra'

  # shared resources & prerequisites
  package { 'wget': ensure => installed, }

  package { 'java-1.8.0-openjdk.x86_64': ensure => installed, }

  file { "${basedir}":
    ensure => directory,
    owner  => $user,
    mode   => '0755',
  }

  exec { "retrieve_apache-cassandra-${version}-bin.tar.gz":
    command => "/usr/bin/wget -q http://www-eu.apache.org/dist/cassandra/${version}/apache-cassandra-${version}-bin.tar.gz -O ${basedir}/apache-cassandra-${version}-bin.tar.gz",
    creates => "${basedir}/apache-cassandra-${version}-bin.tar.gz",
    require => [Package["wget"], File["${basedir}"]],
    user    => "${user}"
  }

  file { "${basedir}/apache-cassandra-${version}-bin.tar.gz":
    path    => "${basedir}/apache-cassandra-${version}-bin.tar.gz",
    ensure  => 'file',
    mode    => 'a+x',
    owner   => "${user}",
    require => [File["${basedir}"], Exec["retrieve_apache-cassandra-${version}-bin.tar.gz"]]
  }

  user { "$user":
    ensure           => 'present',
    gid              => 'users',
    home             => "${basedir}",
    password         => '!!',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    uid              => '501',
  }

  # nodes
  cassandra::cassandra_node { 'node1':
    node           => 'node1',
    version        => $version,
    listen_address => '10.99.88.11',
    rcp_address    => '10.99.88.11',
    jmx_port       => '7099',
    seeds          => '10.99.88.11,10.99.88.13',
    require        => [
      File["${basedir}/apache-cassandra-${version}-bin.tar.gz"],
      User["${user}"],
      Package['java-1.8.0-openjdk.x86_64'],
      ]
  }

  cassandra::cassandra_node { 'node2':
    node           => 'node2',
    version        => $version,
    listen_address => '10.99.88.12',
    rcp_address    => '10.99.88.12',
    jmx_port       => '7191',
    seeds          => '10.99.88.11,10.99.88.13',
    require        => [
      File["${basedir}/apache-cassandra-${version}-bin.tar.gz"],
      User["${user}"],
      Package['java-1.8.0-openjdk.x86_64'],
      ]
  }

  cassandra::cassandra_node { 'node3':
    node           => 'node3',
    version        => $version,
    listen_address => '10.99.88.13',
    rcp_address    => '10.99.88.13',
    jmx_port       => '7299',
    seeds          => '10.99.88.11,10.99.88.13',
    require        => [
      File["${basedir}/apache-cassandra-${version}-bin.tar.gz"],
      User["${user}"],
      Package['java-1.8.0-openjdk.x86_64'],
      ]
  }
}