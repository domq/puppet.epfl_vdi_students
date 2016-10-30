# Class: epflsti_vdi_students::private::vworkspace
#
# Makes your VM able to receive connections from Dell vWorkspace
#
# * FreeRDS et al is compiled from source at https://github.com/epfl-sti/FreeRDS and
#   https://github.com/epfl-sti/FreeRDP
# * qdcsvc is packaged as a binary-only .deb out of the VPSI-provided master images
#
class epflsti_vdi_students::private::vworkspace() {
   file { [  "/opt", "/opt/FreeRDS", "/opt/FreeRDS/share", "/opt/FreeRDS/sbin",
             "/opt/FreeRDS/etc", "/opt/FreeRDS/etc/freerds" ]:
    ensure => "directory"
  }
  file { "/opt/FreeRDS/share/start_script_lib.sh":
    content => template("epflsti_vdi_students/start_script_lib.sh.erb"),
  }

  file { "/opt/FreeRDS/sbin/start_greeter":
    content => template("epflsti_vdi_students/start_greeter.erb"),
    mode => "0755"
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

  case $::osfamily {
    Debian: {
      apt::source { 'sti-soft':
        location => inline_template('http://sti-soft.epfl.ch/<%= @operatingsystem.downcase %>'),
        key => {
          id      => 'FEB223CCC11BB8D39DCC33EDE982B51A904A23B7',
          source  => 'http://sti-soft.epfl.ch/ubuntu/sti-soft.epfl.ch.gpg.key',
        },
        release  => $::lsbdistcodename
      } ->
      package { "qdcsvc": } 
    }
    default: {
      fail("Don't know how to install qdcsvc for ${::operatingsystem}")
    }
  }
}
