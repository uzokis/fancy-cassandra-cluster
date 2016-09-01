define cassandra::cassandra_node (
  $basedir        = '/opt/cassandra',
  $version        = '3.0.8',
  $user           = 'cassandra',
  $node           = 'node1',
  $cluster_name   = 'fancycluster',
  $listen_address = '127.0.0.10',
  $rcp_address    = '127.0.0.10',
  $seeds          = '127.0.0.10,127.0.0.12',
  $jmx_port       = '7199',
  $max_heap_size  = '512M',
  $heap_newsize   = '256M') {
  file { "${basedir}/${node}":
    ensure  => directory,
    owner   => $user,
    mode    => '0755',
    require => File["${basedir}"],
  }

  exec { "unzip-package-${node}":
    command   => "tar -xzf ${basedir}/apache-cassandra-${version}-bin.tar.gz -C ${basedir}/",
    path      => '/bin/:/usr/bin/',
    timeout   => 3600,
    user      => $user,
    provider  => 'shell',
    creates   => "${basedir}/apache-cassandra-${version}",
    require   => File["${basedir}/${node}"],
    logoutput => true,
  }

  exec { "install-package-${node}":
    command   => "cp -r ${basedir}/apache-cassandra-${version}/* ${basedir}/${node}",
    path      => '/bin/:/usr/bin/',
    timeout   => 3600,
    user      => $user,
    provider  => 'shell',
    creates   => "${basedir}/${node}/bin",
    require   => Exec["unzip-package-${node}"],
    logoutput => true,
  }

  file { "${node}-cassandra.yaml":
    path    => "${basedir}/${node}/conf/cassandra.yaml",
    ensure  => file,
    owner   => $user,
    mode    => '0644',
    content => template("${module_name}/cassandra.yaml"),
    require => Exec["install-package-${node}"],
  }

  file { "${node}-cassandra-env.sh":
    path    => "${basedir}/${node}/conf/cassandra-env.sh",
    ensure  => file,
    owner   => $user,
    mode    => '0644',
    content => template("${module_name}/cassandra-env.sh"),
    require => Exec["install-package-${node}"],
  }

  file { "${node}-jvm.options":
    path    => "${basedir}/${node}/conf/jvm.options",
    ensure  => file,
    owner   => $user,
    mode    => '0644',
    content => template("${module_name}/jvm.options"),
    require => Exec["install-package-${node}"],
  }

  file { "cassandra-${node}.service":
    path    => "/etc/systemd/system/cassandra-${node}.service",
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/cassandra.service"),
    require => Exec["install-package-${node}"],
  }

  exec { "enable-cassandra-${node}":
    command   => "systemctl enable cassandra-${node}",
    path      => '/bin/:/usr/bin/',
    timeout   => 3600,
    provider  => 'shell',
    creates   => "/etc/systemd/system/multi-user.target.wants/cassandra-${node}.service",
    require   => [
      File["cassandra-${node}.service"],
      File["${node}-jvm.options"],
      File["${node}-cassandra.yaml"],
      File["${node}-cassandra-env.sh"]],
    notify    => Exec["cassandra-${node}-start"],
    logoutput => true,
  }

  exec { "cassandra-${node}-start":
    command     => "systemctl start cassandra-${node}",
    path        => '/bin/:/usr/bin/',
    timeout     => 3600,
    provider    => 'shell',
    refreshonly => true,
    logoutput   => true,
  }
}