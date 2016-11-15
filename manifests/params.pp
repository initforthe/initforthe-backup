# Private class backup::params
class backup::params {
  $ensure               = 'latest'
  $package_name         = 'backup'
  $package_provider     = 'gem'
  $install_dependencies = true
  $purge_jobs           = true

  $package_dependencies = ['ruby-dev', 'libxslt1-dev', 'libxml2-dev', 'g++', 'patch']

  $root_path = undef
  $tmp_path  = undef
  $data_path = undef

  $logger_quiet      = undef
  $logfile_max_bytes = undef
  $use_syslog        = undef
  $syslog_ident      = undef
}
