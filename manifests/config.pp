# Private class backup::config
class backup::config (
  $root_path = $::backup::root_path,
  $tmp_path = $::backup::tmp_path,
  $data_path = $::backup::data_path,
){
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/etc/backup/config.rb':
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template('backup/config.rb.erb'),
  }
}
