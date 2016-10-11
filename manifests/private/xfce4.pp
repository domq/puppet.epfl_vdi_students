class epflsti_vdi_students::private::xfce4() {

  case $::operatingsystem {
    "Ubuntu": {
      # The shimmer-themes one is beyond silly.
      # https://bugs.launchpad.net/ubuntu/+source/xfce4-settings/+bug/980710
      $deps = [ "xfce4-session", "xfce4-panel", "shimmer-themes" ]
    }
    default: {
      fail("Unsupported operating system flavor ${::operatingsystem}")
    }
  }
  package { $deps:
    ensure => "installed"
  }
  package { "xscreensaver":
    ensure => "absent"
  }

  file { [ "/etc/skel/.config", "/etc/skel/.config/xfce4",
           "/etc/skel/.config/xfce4/xfconf",
           "/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"]:
             ensure => "directory"
  }
  file { "/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml":
    ensure => "file",
    content => template("epflsti_vdi_students/xfce4-panel.xml.erb")
  }
  file { "/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml":
    ensure => "file",
    content => template("epflsti_vdi_students/xfce4-keyboard-shortcuts.xml.erb")
  }
}
