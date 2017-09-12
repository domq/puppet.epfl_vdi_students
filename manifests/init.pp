# Class: epflsti_vdi_students
#
# Turn your VM into a master template for a students course.
#
# === Parameters:
#
# $finalize::  Set to true to cause Puppet to purge all staging state
#              (log files etc) and then shutdown the machine, in preparation
#              for creating a new snapshot to use as a deployment master.
class epflsti_vdi_students(
  $finalize = false
) {
  ensure_resource("class", "quirks")

  class { "epfl_sso": sshd_gssapi_auth => true }

  package { "open-vm-tools":
    ensure => 'installed'
  }
  
  class { "epflsti_vdi_students::private::local_groups": }
  class { "epflsti_vdi_students::private::vworkspace": }
  class { "epflsti_vdi_students::private::xfce4": }

  case $::osfamily {
    'Debian': {
      $smbnetfs_package = "smbnetfs"
    }
    'RedHat': {
      fail("Unable to install smbnetfs")
    }
  }
  package { $smbnetfs_package:
    ensure => "installed"
  }
  
  if ($finalize) {
    stage { "finalize":
      require => Stage["main"]
    }
    class { "epflsti_vdi_students::private::finalize":
      stage => "finalize"
    }
  }
}
