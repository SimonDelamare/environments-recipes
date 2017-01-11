class env::std::add_g5kcode_to_path {

  file {
    '/root/.ssh':
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0700';
  }

exec {
'set_path_g5kcode':
     command => "/bin/bash -c \"if grep --quiet 'PATH' /etc/environment; then sed -i '/^PATH/ s/$/:\\/grid5000\\/code\\/bin/' /etc/environment; else  echo 'PATH=/usr/local/bin:/usr/bin:/bin:/grid5000/code/bin' >> /std/environment ;fi\"";
}
  augeas {
    'g5kcode_root_environment_path':
      lens    => "Shellvars.lns",
      incl    => "/root/.ssh/environment",
      changes => ["set PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",];
  }
  # Sounds dirty as fuck, but Augeas does not manage /etc/profile which is a bash file, and not a real configuration file (or I'm really bad with Augeas).
  file_line { 'g5kcode_etc_profile_path':
     path => '/etc/profile',
     line => 'export PATH=$PATH:/grid5000/code/bin';
  }
}
