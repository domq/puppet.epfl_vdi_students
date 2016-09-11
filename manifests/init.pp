# Class: epflsti_vdi_students
#
# Turn your VM into a master template for a students course.
class epflsti_vdi_students(
  $finalize = false
) {
  class { "epfl_sso": }
  class { "epfl_sso::krb5": }

  # TODO: this hasn't really been tested and in fact, is quite unlikely
  # to work. E.g. the script install /usr/local/bin/cmake which links
  # to a libcurl that doesn't SSL.
  exec { "wget -O- https://raw.githubusercontent.com/epfl-sti/FreeRDS/master/build-freerds.sh | bash":
    path => $::path,
    creates => "/opt/FreeRDS/bin/freerds-manager"
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
