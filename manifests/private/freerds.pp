class epflsti_vdi_students::private::freerds() {
   file { [  "/opt", "/opt/FreeRDS", "/opt/FreeRDS/share", "/opt/FreeRDS/sbin",
             "/opt/FreeRDS/etc", "/opt/FreeRDS/etc/freerds" ]:
    ensure => "directory"
  }
  file { "/opt/FreeRDS/share/start_script_lib.sh":
    content => template("epflsti_vdi_students/start_script_lib.sh.erb"),
  }

  file { "/opt/FreeRDS/sbin/start_greeter":
    content => template("epflsti_vdi_students/start_greeter.erb"),
    mode => "0755"
  }

  file { "/opt/FreeRDS/sbin/start_xession":
    content => template("epflsti_vdi_students/start_xsession.erb"),
    mode => "0755"
  }

  file { "/opt/FreeRDS/etc/freerds/config.ini":
    content => template("epflsti_vdi_students/config.ini.erb"),
  }
}
