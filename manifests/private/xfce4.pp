class epflsti_vdi_students::private::xfce4() {

  case $::operatingsystem {
    "Ubuntu": {
      # This is beyond silly.
      # https://bugs.launchpad.net/ubuntu/+source/xfce4-settings/+bug/980710
      $deps = [ "xfce4-session", "shimmer-themes" ]
    }
    default: {
      fail("Unsupported operating system flavor ${::operatingsystem}")
    }
  }
  package { $deps:
    ensure => "installed"
  }
}
