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

  class { "epfl_sso": }
  class { "epfl_sso::krb5": }

  class { "epflsti_vdi_students::private::local_groups": }
  class { "epflsti_vdi_students::private::freerds": }
  class { "epflsti_vdi_students::private::xfce4": }

  if ($finalize) {
    stage { "finalize":
      require => Stage["main"]
    }
    class { "epflsti_vdi_students::private::finalize":
      stage => "finalize"
    }
  }
}
