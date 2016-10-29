# Class: epflsti_vdi_students::private::finalize
#
# Reset all log files, and power off.
#
# This is to be run prior to creating a new snapshot in the template VM.
class epflsti_vdi_students::private::finalize() {
  if (! $::is_virtual) {
    fail("finalize can only be invoked on a virtual machine!")
  }
  file { ["/opt/FreeRDS/bin/freerds-server.log",
          "/opt/FreeRDS/bin/freerds-manager.log",
          "/var/log/auth.log",
          "/tmp/user.log",
          "/home/caperez",
          "/home/quatrava"]:
            ensure => absent,
            recurse => true,
            purge => true,
            force => true
  } ->
  exec { "/sbin/poweroff": }
}
