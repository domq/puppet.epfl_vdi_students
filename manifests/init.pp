# Class: epflsti_vdi_students
#
# Turn your VM into a master template for a students course.
class epflsti_vdi_students(
  $finalize = false
) {
  class { "epfl_sso": }
  class { "epfl_sso::krb5": }

  # Grant a bunch of groups to everyone.
  file { "/etc/security/group.conf":
    content => template("epflsti_vdi_students/group.conf.erb")
  }

  # pam_group is used to grant groups fuse, plugdev, scanner, video
  # and audio to everyone
  case $::osfamily {
    'Debian': {
      File["/etc/security/group.conf"] ->
      pam { "pam_group in common-auth":
        ensure    => present,
        type      => 'auth',
        service   => 'common-auth',
        control   => 'required',
        module    => 'pam_group.so',
        position  => 'before *[type="auth" and module="pam_krb5.so"]',
      }
    }
    default: {
      fail("${::osfamily} not supported for pam_group configuration")
    }
  }

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
