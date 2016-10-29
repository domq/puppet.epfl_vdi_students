# Class: epflsti_vdi_students::private::local_groups
#
# Use pam_group to grant a bunch of useful groups to all users
#
class epflsti_vdi_students::private::local_groups() {
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
}
