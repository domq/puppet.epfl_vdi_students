# Class: epflsti_vdi_students::private::finalize
#
# Remove all log files, and power off.
#
# This is to be run prior to creating a new snapshot in the template VM.
class epflsti_vdi_students::private::finalize() {
  file { ["/opt/FreeRDS/bin/freerds-server.log",
          "/opt/FreeRDS/bin/freerds-manager.log",
          "/var/log/auth.log",
          "/tmp/user.log"]:
            ensure => absent
  } ->
  exec { "/sbin/poweroff": }
}
