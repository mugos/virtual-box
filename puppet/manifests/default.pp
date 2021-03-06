$as_vagrant = 'sudo -u vagrant -H bash -l -c'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

package { 'curl':
  ensure => installed
}

exec { 'nvm-install':
	command => "${as_vagrant} 'curl -L https://raw.github.com/creationix/nvm/master/install.sh | bash'",
	creates => '/home/vagrant/.nvm',
	require => Package['curl']
}

exec { 'node-install':
	command => "${as_vagrant} 'nvm install 0.10.29 && nvm alias default 0.10.29'",
	require => Exec['nvm-install']
}

exec { 'npm-install':
  command => "${as_vagrant} 'curl -L https://npmjs.org/install.sh | sh'",
  require => Exec['node-install']
}

class { 'redis':
  version => '2.8.13',
}

redis::instance { 'redis-6900':
  redis_port         => '6900',
  redis_bind_address => '10.1.2.3',
  redis_max_memory   => '1gb',
}
