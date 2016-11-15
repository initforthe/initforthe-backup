# Defined Type: backup::model,
define backup::model (
  $attributes,
  $description                    = undef,

  $hour                           = '23',
  $minute                         = '05',
  $monthday                       = '*',
  $month                          = '*',
  $weekday                        = '*',
  $gem_bin_path                   = '/usr/local/bin',
  $tmp_path                       = '~/Backup/.tmp',

  $ensure                         = present,
  $utilities                      = undef,

  $split_into_chunks              = undef,

  $archive_root                   = undef,
  $archive_use_sudo               = false,
  $archive_add                    = undef,
  $archive_exclude                = undef,
  $archive_tar_options            = undef,

  $mongodb_name                   = undef,
  $mongodb_username               = undef,
  $mongodb_password               = undef,
  $mongodb_host                   = undef,
  $mongodb_port                   = undef,
  $mongodb_ipv6                   = undef,
  $mongodb_only_collections       = undef,
  $mongodb_additional_options     = undef,
  $mongodb_lock                   = undef,
  $mongodb_oplog                  = undef,

  $mysql_name                     = undef,
  $mysql_username                 = undef,
  $mysql_password                 = undef,
  $mysql_host                     = undef,
  $mysql_port                     = undef,
  $mysql_socket                   = undef,
  $mysql_sudo_user                = undef,
  $mysql_skip_tables              = undef,
  $mysql_only_tables              = undef,
  $mysql_additional_options       = undef,
  $mysql_prepare_backup           = undef,
  $mysql_backup_engine            = undef,
  $mysql_prepare_options          = undef,
  $mysql_verbose                  = undef,

  $openldap_name                  = undef,
  $openldap_slapcat_args          = undef,
  $openldap_use_sudo              = undef,
  $openldap_slapcat_conf          = undef,
  $openldap_slapcat_utility       = undef,

  $postgresql_name                = undef,
  $postgresql_username            = undef,
  $postgresql_password            = undef,
  $postgresql_host                = undef,
  $postgresql_port                = undef,
  $postgresql_socket              = undef,
  $postgresql_skip_tables         = undef,
  $postgresql_only_tables         = undef,
  $postgresql_additional_options  = undef,
  $postgresql_sudo_user           = undef,

  $redis_mode                     = undef,
  $redis_rdb_path                 = undef,
  $redis_invoke_save              = undef,
  $redis_host                     = undef,
  $redis_port                     = undef,
  $redis_socket                   = undef,
  $redis_password                 = undef,
  $redis_additional_options       = undef,

  $riak_node                      = undef,
  $riak_cookie                    = undef,
  $riak_user                      = undef,

  $sqlite_path                    = undef,
  $sqlite_sqlitedump_utility      = undef,

  $use_compression                = undef,

  $bzip2_compression_level        = undef,

  $custom_command                 = undef,
  $custom_extension               = undef,

  $gzip_compression_level         = undef,
  $gzip_rsyncable                 = undef,

  $use_encryption                 = undef,

  $openssl_password               = undef,
  $openssl_password_file          = undef,
  $openssl_base64                 = undef,
  $openssl_salt                   = undef,

  $gpg_keys                       = undef,
  $gpg_recipients                 = undef,
  $gpg_passphrase                 = undef,
  $gpg_mode                       = undef,

  $use_storage                    = undef,
  $use_syncer                     = undef,

  $cloudfiles_api_key             = undef,
  $cloudfiles_username            = undef,
  $cloudfiles_container           = undef,
  $cloudfiles_segments_container  = undef,
  $cloudfiles_segment_size        = undef,
  $cloudfiles_path                = undef,
  $cloudfiles_auth_url            = undef,
  $cloudfiles_region              = undef,
  $cloudfiles_servicenet          = undef,
  $cloudfiles_days_to_keep        = undef,
  $cloudfiles_max_retries         = undef,
  $cloudfiles_retry_waitsec       = undef,
  $cloudfiles_fog_options         = undef,
  # Syncer options
  $cloudfiles_mirror              = undef,
  $cloudfiles_thread_count        = undef,
  $cloudfiles_add                 = undef,
  $cloudfiles_exclude             = undef,

  $dropbox_api_key                = undef,
  $dropbox_api_secret             = undef,
  $dropbox_cache_path             = undef,
  $dropbox_access_type            = undef,
  $dropbox_path                   = undef,
  $dropbox_keep                   = undef,
  $dropbox_chunk_size             = undef,
  $dropbox_max_retries            = undef,
  $dropbox_retry_waitsec          = undef,

  $ftp_username                   = undef,
  $ftp_password                   = undef,
  $ftp_ip                         = undef,
  $ftp_port                       = undef,
  $ftp_path                       = undef,
  $ftp_keep                       = undef,
  $ftp_passive_mode               = undef,
  $ftp_timeout                    = undef,

  $local_path                     = undef,
  $local_keep                     = undef,

  $ninefold_storage_token         = undef,
  $ninefold_storage_secret        = undef,
  $ninefold_path                  = undef,
  $ninefold_keep                  = undef,

  $scp_username                   = undef,
  $scp_password                   = undef,
  $scp_ip                         = undef,
  $scp_port                       = undef,
  $scp_path                       = undef,
  $scp_keep                       = undef,
  $scp_ssh_options                = undef,

  $sftp_username                  = undef,
  $sftp_password                  = undef,
  $sftp_ip                        = undef,
  $sftp_port                      = undef,
  $sftp_path                      = undef,
  $sftp_keep                      = undef,
  $sftp_ssh_options               = undef,

  $rsync_mode                     = undef,
  $rsync_host                     = undef,
  $rsync_port                     = undef,
  $rsync_ssh_user                 = undef,
  $rsync_additional_ssh_options   = undef,
  $rsync_user                     = undef,
  $rsync_password                 = undef,
  $rsync_password_file            = undef,
  $rsync_additional_rsync_options = undef,
  $rsync_compress                 = undef,
  $rsync_path                     = undef,
  # Syncer options
  $rsync_mirror                   = undef,
  $rsync_archive                  = undef,
  $rsync_add                      = undef,
  $rsync_exclude                  = undef,

  $s3_access_key_id               = undef,
  $s3_secret_access_key           = undef,
  $s3_use_iam_profile             = undef,
  $s3_bucket                      = undef,
  $s3_region                      = undef,
  $s3_path                        = undef,
  $s3_encryption                  = undef,
  $s3_storage_class               = undef,
  $s3_chunk_size                  = undef,
  $s3_fog_options                 = undef,
  $s3_keep                        = undef,
  # Syncer options
  $s3_mirror                      = undef,
  $s3_thread_count                = undef,
  $s3_add                         = undef,
  $s3_exclude                     = undef,

  $use_notifier                   = undef,

  $ses_on_success                 = false,
  $ses_on_warning                 = true,
  $ses_on_failure                 = true,
  $ses_access_key_id              = undef,
  $ses_secret_access_key          = undef,
  $ses_region                     = undef,
  $ses_from                       = undef,
  $ses_to                         = undef,
  $ses_cc                         = undef,
  $ses_bcc                        = undef,
  $ses_reply_to                   = undef,

  $cmd_on_success                 = false,
  $cmd_on_warning                 = true,
  $cmd_on_failure                 = true,
  $cmd_command                    = undef,
  $cmd_args                       = undef,

  $campfire_on_success            = false,
  $campfire_on_warning            = true,
  $campfire_on_failure            = true,
  $campfire_api_token             = undef,
  $campfire_subdomain             = undef,
  $campfire_room_id               = undef,

  $datadog_on_success             = false,
  $datadog_on_warning             = true,
  $datadog_on_failure             = true,
  $datadog_api_key                = undef,
  $datadog_title                  = undef,
  $datadog_host                   = undef,
  $datadog_tags                   = undef,
  $datadog_alert_type             = undef,
  $datadog_source_type_name       = undef,
  $datadog_priority               = undef,
  $datadog_date_happened          = undef,
  $datadog_aggregation_key        = undef,

  $flowdock_on_success            = false,
  $flowdock_on_warning            = true,
  $flowdock_on_failure            = true,
  $flowdock_token                 = undef,
  $flowdock_from_name             = undef,
  $flowdock_from_email            = undef,
  $flowdock_subject               = undef,
  $flowdock_source                = undef,
  $flowdock_tags                  = undef,
  $flowdock_link                  = undef,

  $hipchat_on_success             = false,
  $hipchat_on_warning             = true,
  $hipchat_on_failure             = true,
  $hipchat_success_color          = undef,
  $hipchat_warning_color          = undef,
  $hipchat_failure_color          = undef,
  $hipchat_token                  = undef,
  $hipchat_from                   = undef,
  $hipchat_rooms_notified         = undef,
  $hipchat_api_version            = undef,

  $http_post_on_success           = false,
  $http_post_on_warning           = true,
  $http_post_on_failure           = true,
  $http_post_uri                  = undef,
  $http_post_headers              = undef,
  $http_post_params               = undef,
  $http_post_success_codes        = undef,
  $http_post_ssl_verify_peer      = undef,
  $http_post_ssl_ca_file          = undef,

  $mail_on_success                = false,
  $mail_on_warning                = true,
  $mail_on_failure                = true,
  $mail_from                      = undef,
  $mail_to                        = undef,
  $mail_cc                        = undef,
  $mail_bcc                       = undef,
  $mail_reply_to                  = undef,
  $mail_address                   = undef,
  $mail_port                      = undef,
  $mail_domain                    = undef,
  $mail_user_name                 = undef,
  $mail_password                  = undef,
  $mail_authentication            = undef,
  $mail_encryption                = undef,
  $mail_delivery_method           = undef,
  $mail_sendmail_args             = undef,
  $mail_exim_args                 = undef,
  $mail_folder                    = undef,
  $mail_send_log_on               = undef,

  $nagios_on_success              = false,
  $nagios_on_warning              = true,
  $nagios_on_failure              = true,
  $nagios_host                    = undef,
  $nagios_port                    = undef,
  $nagios_service_name            = undef,
  $nagios_service_host            = undef,

  $pagerduty_on_success           = false,
  $pagerduty_on_warning           = true,
  $pagerduty_on_failure           = true,
  $pagerduty_service_key          = undef,
  $pagerduty_resolve_on_warning   = undef,

  $prowl_on_success               = false,
  $prowl_on_warning               = true,
  $prowl_on_failure               = true,
  $prowl_application              = undef,
  $prowl_api_key                  = undef,

  $pushover_on_success            = false,
  $pushover_on_warning            = true,
  $pushover_on_failure            = true,
  $pushover_user                  = undef,
  $pushover_token                 = undef,
  $pushover_title                 = undef,
  $pushover_device                = undef,
  $pushover_priority              = undef,

  $slack_on_success               = false,
  $slack_on_warning               = true,
  $slack_on_failure               = true,
  $slack_webhook_url              = undef,
  $slack_channel                  = undef,
  $slack_username                 = undef,
  $slack_icon_emoji               = undef,

  $twitter_on_success             = false,
  $twitter_on_warning             = true,
  $twitter_on_failure             = true,
  $twitter_consumer_key           = undef,
  $twitter_consumer_secret        = undef,
  $twitter_oauth_token            = undef,
  $twitter_oauth_token_secret     = undef,

  $zabbix_on_success              = false,
  $zabbix_on_warning              = true,
  $zabbix_on_failure              = true,
  $zabbix_host                    = undef,
  $zabbix_port                    = undef,
  $zabbix_service_name            = undef,
  $zabbix_service_host            = undef,
  $zabbix_item_key                = undef,
) {

  if !defined(Class['backup']) {
    fail('You need to include the backup class before creating a model')
  }

  $_attrs = any2array($attributes)

  if !member(['present', 'absent'], $ensure) {
    fail("[Backup::Model::${name}]: Invalid ensure ${ensure}. Valid values are present and absent")
  }

  if !member(['archive', 'mongodb', 'mysql', 'openldap', 'postgresql', 'redis', 'riak', 'sqlite'], $_attrs) {
    $__attrs = join($_attrs, ', ')
    fail("[Backup::Model::${name}]: Invalid attribute in '${__attrs}'. Supported attributes are archive, mongodb, mysql, openldap, postgresql, redis, riak and sqlite")
  }

  if member($_attrs, 'archive') {
    if !$archive_add {
      fail("[Backup::Model::${name}]: Files or directories to be archived need to be specified with the 'add' parameter")
    }
    if !is_string($archive_add) and !is_array($archive_add) {
      fail("[Backup::Model::${name}]: The add parameter takes either an individual path as a string or an array of paths")
    }
    if !is_string($archive_exclude) and !is_array($archive_exclude) {
      fail("[Backup::Model::${name}]: The exclude parameter takes either an individual path as a string or an array of paths")
    }
  }

  if member($_attrs, 'mongodb') {
    if !$mongodb_name {
      fail("[Backup::Model::${name}]: mongodb_name is missing")
    }
    if $mongodb_username and !$mongodb_password {
      fail("[Backup::Model::${name}]: MongoDB requires a password when supplying a username")
    }
    if $mongodb_only_collections and (!is_string($mongodb_only_collections) and !is_array($mongodb_only_collections)) {
      fail("[Backup::Model::${name}]: MongoDB collections must be a string or array")
    }
    if $mongodb_port and !is_integer($mongodb_port) {
      fail("[Backup::Model::${name}]: mongodb_port is not a valid port number")
    }
    validate_bool($mongodb_lock)
  }

  if $use_compression {
    if !member(['bzip2', 'gzip', 'custom'], $use_compression) {
      fail("[Backup::Model::${name}]: Invalid compression type '${use_compression}'. Supported types are bzip2, gzip and custom")
    }
    if $bzip2_compression_level and !is_integer($bzip2_compression_level) {
      fail("[Backup::Model::${name}]: bzip2_compression_level must be an integer between 1 and 9")
    }

    if $gzip_compression_level and !is_integer($gzip_compression_level) {
      fail("[Backup::Model::${name}]: gzip_compression_level must be an integer between 1 and 9")
    }
    if $gzip_rsyncable {
      validate_bool($gzip_rsyncable)
    }
  }

  if $use_encryption {
    if !member(['openssl', 'gpg'], $use_encryption) {
      fail("[Backup::Model::${name}]: Invalid encryption type '${use_encryption}'. Supported types are openssl and gpg")
    }

    if $openssl_base64 {
      validate_bool($openssl_base64)
    }
    if $openssl_salt {
      validate_bool($openssl_salt)
    }
  }

  if $use_storage {
    if !member(['cloudfiles','dropbox','ftp','local','ninefold','scp','sftp','rsync','s3'], $use_storage) {
      fail("[Backup::Model::${name}]: Invalid storage type '${use_storage}'. Supported types are cloudfiles, dropbox, ftp, local, ninefold, scp, sftp, rsync and s3")
    }
  }

  if $use_syncer {
    if !member(['cloudfiles','rsync','s3'], $use_syncer) {
      fail("[Backup::Model::${name}]: Invalid storage type '${use_syncer}'. Supported types are cloudfiles, rsync and s3")
    }
  }

  $_notifiers = any2array($use_notifier)

  if $use_notifier {
    if !member(['ses','command','campfire','datadog','flowdock','hipchat','http_post','mail','nagios','pagerduty','prowl','pushover','slack','twitter','zabbix'], $_notifiers) {
      $__notifiers = join($_notifiers, ', ')
      fail("[Backup::Model::${name}]: Invalid notifier in '${__notifiers}'. Supported notifiers are ses, command, campfire, datadog, flowdock, hipchat, http_post, mail, nagios, pagerduty, prowl, pushover, slack, twitter and zabbix")
    }
  }

  concat {"/etc/backup/models/${name}.rb":
    ensure => $ensure,
  }

  if $ensure == present {
    $target = "/etc/backup/models/${title}.rb"

    concat::fragment { "model-${title}-header":
      target  => $target,
      content => template('backup/model/header.rb.erb'),
      order   => '01',
    }

    if $split_into_chunks {
      concat::fragment { "model-${title}-splitter":
        target  => $target,
        content => "  split_into_chunks_of ${split_into_chunks}",
        order   => '05',
      }
    }

    if member($_attrs, 'archive') {
      concat::fragment { "model-${title}-archive":
        target  => $target,
        content => template('backup/model/archive.rb.erb'),
        order   => '10',
      }
    }

    if member($_attrs, 'mongodb') {
      concat::fragment { "model-${title}-mongodb":
        target  => $target,
        content => template('backup/model/db/mongodb.rb.erb'),
        order   => '20',
      }
    }

    if member($_attrs, 'mysql') {
      concat::fragment { "model-${title}-mysql":
        target  => $target,
        content => template('backup/model/db/mysql.rb.erb'),
        order   => '20',
      }
    }

    if member($_attrs, 'openldap') {
      concat::fragment { "model-${title}-openldap":
        target  => $target,
        content => template('backup/model/db/openldap.rb.erb'),
        order   => '20',
      }
    }

    if member($_attrs, 'postgresql') {
      concat::fragment { "model-${title}-postgresql":
        target  => $target,
        content => template('backup/model/db/postgresql.rb.erb'),
        order   => '20',
      }
    }

    if member($_attrs, 'redis') {
      concat::fragment { "model-${title}-redis":
        target  => $target,
        content => template('backup/model/db/redis.rb.erb'),
        order   => '20',
      }
    }

    if member($_attrs, 'riak') {
      concat::fragment { "model-${title}-riak":
        target  => $target,
        content => template('backup/model/db/riak.rb.erb'),
        order   => '20',
      }
    }

    if member($_attrs, 'sqlite') {
      concat::fragment { "model-${title}-sqlite":
        target  => $target,
        content => template('backup/model/db/sqlite.rb.erb'),
        order   => '20',
      }
    }

    if $use_compression {
      concat::fragment {"model-${title}-compressor":
        target  => $target,
        content => template("backup/model/compressor/${use_compression}.rb.erb"),
        order   => '30',
      }
    }

    if $use_encryption {
      concat::fragment {"model-${title}-encryptor":
        target  => $target,
        content => template("backup/model/encryptor/${use_encryption}.rb.erb"),
        order   => '40',
      }
    }

    if $use_storage {
      concat::fragment {"model-${title}-storage":
        target  => $target,
        content => template("backup/model/storage/${use_storage}.rb.erb"),
        order   => '50',
      }
    }

    if $use_syncer {
      concat::fragment {"model-${title}-syncer":
        target  => $target,
        content => template("backup/model/syncer/${use_syncer}.rb.erb"),
        order   => '60',
      }
    }

    $_notifiers.each |$notifier| {
      if $notifier != '' {
        concat::fragment {"model-${title}-notifier-${notifier}":
          target  => $target,
          content => template("backup/model/notifier/${notifier}.rb.erb"),
          order   => '70',
        }
      }
    }

    concat::fragment { "model-${title}-footer":
      target  => $target,
      content => template('backup/model/footer.rb.erb'),
      order   => '99',
    }
  }

  cron { "${title}-backup":
    ensure   => $ensure,
    command  => "${gem_bin_path}/backup perform --trigger ${title} --config-file '/etc/backup/config.rb' --tmp-path ${tmp_path}",
    minute   => $minute,
    hour     => $hour,
    monthday => $monthday,
    month    => $month,
    weekday  => $weekday,
  }
}
