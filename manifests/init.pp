# Class: epflsti_vdi_students
#
# Turn your VM into a master template for a students course.
class epflsti_vdi_students(
  $finalize = false
) {
  class { "epfl_sso": }
  class { "epfl_sso::krb5": }

  exec { "curl -O- https://raw.githubusercontent.com/epfl-sti/FreeRDS/master/build-freerds.sh | bash":
    path => $::path,
    creates => "/opt/FreeRDS/bin/freerds-manager"
  }
  
  if ($finalize) {
    file { ["/opt/FreeRDS/bin/freerds-server.log",
            "/opt/FreeRDS/bin/freerds-manager.log",
            "/var/log/auth.log",
            "/tmp/user.log"]:
              ensure => absent
    }
    exec { "/sbin/poweroff": }
  }
}
