class task-puppet {
	
	package { 'vim-enhanced': 
		ensure	=> 'installed',
	}

	package { 'curl':
		ensure	=> 'installed',
	}

	package { 'git':
		ensure	=> 'installed',
	}

	user { 'monitor':
		ensure		=> 'present',
		managehome	=> true,
		shell		=> '/bin/bash',
	}

	file { '/home/monitor/scripts':
		ensure	=> 'directory',
		owner	=> ['root', 'monitor'],
		group	=> 'root',
		mode	=> '0750',
	}

	exec { 'get_memory_check':
		command	=> '/usr/bin/wget -q https://raw.githubusercontent.com/BerKeyinde/SE_Exercise/master/memory_check -O /home/monitor/scripts/memory_check',
		creates	=> '/home/monitor/scripts/memory_check',
	}

	file { '/home/monitor/scripts/memory_check':
		mode	=> '0755',
		require => Exec['get_memory_check'],
	}

	file { '/home/monitor/src':
		ensure	=> 'directory',
		owner	=> ['root', 'monitor'],
		group	=> 'root',
		mode	=> '0750',
	}

	file { '/home/monitor/src/my_memory_check':
		ensure	=> 'link',
		target	=> '/home/monitor/scripts/memory_check',
	}

	cron { 'puppet-apply':
		ensure	=> 'present',
		command	=> '/bin/bash /home/monitor/src/my_memory_check -c 90 -w 80 -e m.cahinde@gmail.com',
		user	=> root,
		minute	=> '*/10',
	}

	exec { 'hostname':
		command	=> 'hostname bpx.server.local',
		path	=> '/bin/',
	} 

	exec { 'mv':
		command	=> 'mv /etc/localtime /etc/localtime.bak',
		path	=> '/bin/',
	}

	file { '/etc/localtime':
		ensure	=> 'link',
		target	=> '/usr/share/zoneinfo/Asia/Taipei',
	}
}
