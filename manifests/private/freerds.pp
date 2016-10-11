class epflsti_vdi_students::private::freerds() {
   file { [  "/opt", "/opt/FreeRDS", "/opt/FreeRDS/share", "/opt/FreeRDS/sbin",
             "/opt/FreeRDS/etc", "/opt/FreeRDS/etc/freerds" ]:
    ensure => "directory"
  }
  file { "/opt/FreeRDS/share/start_script_lib.sh":
    content => template("epflsti_vdi_students/start_script_lib.sh.erb"),
  }

  file { "/opt/FreeRDS/sbin/start_greeter":
    content => template("epflsti_vdi_students/start_greeter.erb"),
  }

  file { "/opt/FreeRDS/sbin/start_xsession":
    content => template("epflsti_vdi_students/start_xsession.erb"),
    mode => "0755"
  }

  file { "/opt/FreeRDS/etc/freerds/config.ini":
    content => template("epflsti_vdi_students/config.ini.erb"),
  }

  package { ["docbook-xsl", "libwayland-dev"]:
    ensure => "installed"
  } ->
  exec { "Compile FreeRDS from source":
    command => "wget -O- https://raw.githubusercontent.com/epfl-sti/FreeRDS/master/build-freerds.sh | bash",
    path => $::path,
    timeout     => 1800,
    creates => "/opt/FreeRDS/bin/freerds-manager"
  }

  ensure_resource('class', 'systemd')
  if ($::systemd_available == "true") {
    systemd::service { 'freerds-server':
        description  => 'FreeRDS server',
        execstart    => '/opt/FreeRDS/bin/freerds-server --no-daemon',
        wants        => ['network.target'],
    } ->
    service { 'freerds-server':
      ensure => running,
      enable => true
    }  

    systemd::service { 'freerds-manager':
        description  => 'FreeRDS manager',
        execstart    => '/opt/FreeRDS/bin/freerds-manager --no-daemon',
        wants        => ['network.target'],
    }
    service { 'freerds-manager':
      ensure => running,
      enable => true
    }  
  } else {
    warn("System V-style setup of FreeRDS is not supported yet. FreeRDS won't be started.")
  }
}
