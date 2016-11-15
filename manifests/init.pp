# Class: backup
class backup (
  $root_path = undef,
  $tmp_path = undef,
  $data_path = undef,

  # S3 Access credentials
  $s3_access_key_id = undef,
  $s3_secret_access_key = undef,

  # Mail Notifier configuration
  $mail_from = undef,
  $mail_to = undef,
  $mail_host = undef,
  $mail_port = undef,
  $mail_domain = undef,
  $mail_username = undef,
  $mail_password = undef,
  $mail_auth_type = undef,
  $mail_encryption = undef,

) inherits backup::params {
  class { '::backup::install': } ~>
  class { '::backup::config': }
}
