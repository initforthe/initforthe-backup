require 'spec_helper'

describe 'backup::model' do
  let(:pre_condition) { 'include backup' }
  let(:title) { 'my_model' }

  context 'with an invalid attribute' do
    let(:params) { { attributes: 'foo', } }
    it { should_not compile }
  end

  context 'with invalid archive attibutes' do
    let(:params) { { attributes: 'archive' } }
    it { should_not compile }

    context 'with a hash for archive_add' do
      let(:params) {
        {
          attributes: 'archive',
          archive_add: {
            foo: 'bar'
          }
        }
      }
      it { should_not compile }
    end
  end

  context 'with valid archive attributes' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/baz'
      }
    }

    it { should compile }
    it { should contain_cron("my_model-backup").with({
      :hour => '23',
      :minute => '05',
      :monthday => '*',
      :weekday => '*',
      :month => '*',
      :command => "/usr/local/bin/backup perform --trigger my_model --config-file '/etc/backup/config.rb' --tmp-path ~/Backup/.tmp"
    })}
    it { should contain_concat__fragment("model-my_model-archive").with_content(<<-EOF
  archive my_model_archive do |archive|
    archive.add "/var/baz"
  end
    EOF
    ) }

    context 'with a full set of archive attributes' do
      let(:params) {
        {
          attributes: 'archive',
          archive_add: '/var/baz',
          archive_exclude: ['/var/bar', '/srv/apps'],
          archive_tar_options: '--foo_opt',
          archive_use_sudo: true,
          archive_root: '/var',
        }
      }

      it { should contain_concat__fragment("model-my_model-archive").with_content(<<-EOF
  archive my_model_archive do |archive|
    archive.root = "/var"
    archive.use_sudo = true
    archive.add "/var/baz"
    archive.exclude "/var/bar"
    archive.exclude "/srv/apps"
    archive.tar_options = "--foo_opt"
  end
      EOF
      ) }
    end
  end

  context 'without a database specified for mongodb' do
    let(:params) {
      { attributes: 'mongodb', }
    }
    it { should_not compile }
  end

  context 'with valid mongodb attributes' do
    let(:params) {
      {
        attributes: 'mongodb',
        mongodb_name: 'mydb',
        mongodb_username: 'myuser',
        mongodb_password: 'mypass',
        mongodb_host: 'localhost',
        mongodb_port: 12345,
        mongodb_only_collections: ['foo', 'bar', 'baz'],
        mongodb_additional_options: '--fat',
        mongodb_lock: true,
        mongodb_oplog: true,
      }
    }

    it { should contain_concat__fragment("model-my_model-mongodb").with_content(<<-EOF
  database MongoDB do |db|
    db.name               = "mydb"
    db.username           = "myuser"
    db.password           = "mypass"
    db.host               = "localhost"
    db.port               = 12345
    db.only_collections   = ["foo", "bar", "baz"]
    db.additional_options = "--fat"
    db.lock               = true
    db.oplog              = true
  end
    EOF
    )}
  end

  context 'with valid mysql attributes' do
    let(:params) {
      {
        attributes: 'mysql',
        mysql_name: 'mydb',
        mysql_username: 'myuser',
        mysql_password: 'mypass',
        mysql_host: 'localhost',
        mysql_port: 3306,
        mysql_socket: '/tmp/.mysqld.sock',
        mysql_sudo_user: 'root',
        mysql_skip_tables: ["foo", "bar"],
        mysql_only_tables: ["baz", "bat"],
        mysql_additional_options: ["--quick", "--single-transaction"],
        mysql_prepare_backup: true,
        mysql_backup_engine: 'innobackupex',
        mysql_prepare_options: "--use-memory=4G",
        mysql_verbose: true
      }
    }

    it { should contain_concat__fragment("model-my_model-mysql").with_content(<<-EOF
  database MySQL do |db|
    db.name               = "mydb"
    db.username           = "myuser"
    db.password           = "mypass"
    db.host               = "localhost"
    db.port               = 3306
    db.socket             = "/tmp/.mysqld.sock"
    db.sudo_user          = "root"
    db.skip_tables        = ["foo", "bar"]
    db.only_tables        = ["baz", "bat"]
    db.additional_options = ["--quick", "--single-transaction"]
    db.prepare_backup     = true
    db.backup_engine      = :innobackupex
    db.prepare_options    = ["--use-memory=4G"]
    db.verbose            = true
  end
    EOF
    )}
  end

  context 'with valid openldap attributes' do
    let(:params) {
      {
        attributes: 'openldap',
        openldap_name: 'mydb',
        openldap_slapcat_args: ["--arg1", "--arg2"],
        openldap_use_sudo: true,
        openldap_slapcat_conf: "/path/to/conf",
        openldap_slapcat_utility: "/opt/local/bin/slapcat",
      }
    }

    it { should contain_concat__fragment("model-my_model-openldap").with_content(<<-EOF
  database OpenLDAP do |db|
    db.name            = "mydb"
    db.slapcat_args    = ["--arg1", "--arg2"]
    db.use_sudo        = true
    db.slapcat_conf    = "/path/to/conf"
    db.slapcat_utility = "/opt/local/bin/slapcat"
  end
    EOF
    )}
  end

  context 'with valid postgresql attributes' do
    let(:params) {
      {
        attributes: 'postgresql',
        postgresql_name: 'mydb',
        postgresql_username: 'myuser',
        postgresql_password: 'mypass',
        postgresql_host: 'localhost',
        postgresql_port: 5432,
        postgresql_socket: '/tmp/.postgresql.sock',
        postgresql_skip_tables: ["foo", "bar"],
        postgresql_only_tables: ["baz", "bat"],
        postgresql_additional_options: ["--quick", "--single-transaction"],
        postgresql_sudo_user: "root"
      }
    }

    it { should contain_concat__fragment("model-my_model-postgresql").with_content(<<-EOF
  database PostgreSQL do |db|
    db.name               = "mydb"
    db.username           = "myuser"
    db.password           = "mypass"
    db.host               = "localhost"
    db.port               = 5432
    db.socket             = "/tmp/.postgresql.sock"
    db.skip_tables        = ["foo", "bar"]
    db.only_tables        = ["baz", "bat"]
    db.additional_options = ["--quick", "--single-transaction"]
    db.sudo_user          = "root"
  end
    EOF
    )}
  end

  context 'with valid redis attributes' do
    let(:params) {
      {
        attributes: 'redis',
        redis_mode: 'copy',
        redis_rdb_path: '/path/to/rdb',
        redis_invoke_save: true,
        redis_host: 'localhost',
        redis_port: 6379,
        redis_socket: '/tmp/.redis.sock',
        redis_password: 'mypass',
        redis_additional_options: ["--quick", "--single-transaction"],
      }
    }

    it { should contain_concat__fragment("model-my_model-redis").with_content(<<-EOF
  database Redis do |db|
    db.mode               = :copy
    db.rdb_path           = "/path/to/rdb"
    db.invoke_save        = true
    db.host               = "localhost"
    db.port               = 6379
    db.socket             = "/tmp/.redis.sock"
    db.password           = "mypass"
    db.additional_options = ["--quick", "--single-transaction"]
  end
    EOF
    )}
  end

  context 'with valid riak attributes' do
    let(:params) {
      {
        attributes: 'riak',
        riak_node: 'riak@hostname',
        riak_cookie: 'cookie',
        riak_user: 'riak',
      }
    }

    it { should contain_concat__fragment("model-my_model-riak").with_content(<<-EOF
database Riak do |db|
  db.node   = "riak@hostname"
  db.cookie = "cookie"
  db.user   = "riak"
end
    EOF
    )}
  end

  context 'with valid sqlite attributes' do
    let(:params) {
      {
        attributes: 'sqlite',
        sqlite_path: '/path/to/database.sqlite',
        sqlite_sqlitedump_utility: '/opt/bin/sqlitedump',
      }
    }

    it { should contain_concat__fragment("model-my_model-sqlite").with_content(<<-EOF
database SQLite do |db|
  db.path               = "/path/to/database.sqlite"
  db.sqlitedump_utility = "/opt/bin/sqlitedump"
end
    EOF
    )}
  end

  context 'with bzip2 compression' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/baz',
        use_compression: 'bzip2',
      }
    }

    it { should contain_concat__fragment('model-my_model-compressor').with_content("  compress_with Bzip2") }

    context 'with a bzip2_compression_level = 9' do
      let(:params) {
        {
          attributes: 'archive',
          archive_add: '/var/baz',
          use_compression: 'bzip2',
          bzip2_compression_level: 9,
        }
      }

      it { should contain_concat__fragment('model-my_model-compressor').with_content(<<-EOF
  compress_with Bzip2 do |compression|
    compression.level = 9
  end
      EOF
      )}
    end
  end

  context 'with gzip compression' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/baz',
        use_compression: 'gzip',
      }
    }

    it { should contain_concat__fragment('model-my_model-compressor').with_content("  compress_with Gzip") }

    context 'with a gzip_compression_level = 9 and gzip_rsyncable = true' do
      let(:params) {
        {
          attributes: 'archive',
          archive_add: '/var/baz',
          use_compression: 'gzip',
          gzip_compression_level: 9,
          gzip_rsyncable: true,
        }
      }

      it { should contain_concat__fragment('model-my_model-compressor').with_content(<<-EOF
  compress_with Gzip do |compression|
    compression.level     = 9
    compression.rsyncable = true
  end
      EOF
      )}
    end
  end

  context 'with custom compression' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/baz',
        use_compression: 'custom',
        custom_command: 'pbzip2 -p2',
        custom_extension: '.bz2',
      }
    }

    it { should contain_concat__fragment('model-my_model-compressor').with_content(<<-EOF
  compress_with Custom do |compression|
    compression.command   = 'pbzip2 -p2'
    compression.extension = '.bz2'
  end
    EOF
    )}
  end

  context 'with openssl encryption' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/baz',
        use_encryption: 'openssl',
        openssl_password: 'mypass',
        openssl_base64: true,
        openssl_salt: true,
      }
    }

    it { should contain_concat__fragment('model-my_model-encryptor').with_content(<<-EOF
  encrypt_with OpenSSL do |encryption|
    encryption.password      = 'mypass'
    encryption.base64        = true
    encyrption.salt          = true
  end
    EOF
    )}

    context 'with openssl_password_file = /path/to/password/file' do
      let(:params) {
        {
          attributes: 'archive',
          archive_add: '/var/baz',
          use_encryption: 'openssl',
          openssl_password_file: '/path/to/password/file',
          openssl_base64: true,
          openssl_salt: true,
        }
      }

      it { should contain_concat__fragment('model-my_model-encryptor').with_content(<<-EOF
  encrypt_with OpenSSL do |encryption|
    encryption.password_file = '/path/to/password/file'
    encryption.base64        = true
    encyrption.salt          = true
  end
      EOF
      )}
    end
  end

  context 'with gpg encryption' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/baz',
        use_encryption: 'gpg',
        gpg_keys: {
          'joe@example.com' => <<-KEY
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      Version: GnuPG v1.4.11 (Darwin)

      [ Your GPG Public Key Here ]
      -----END PGP PUBLIC KEY BLOCK-----
          KEY
        },
        gpg_recipients: [ 'joe@example.com' ],
        gpg_passphrase: '1234567890',
        gpg_mode: 'both',
      }
    }

    it { should contain_concat__fragment('model-my_model-encryptor').with_content(<<-EOF
  encrypt_with GPG do |encryption|
    encryption.keys = {}
    encryption.keys['joe@example.com'] = <<-KEY
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      Version: GnuPG v1.4.11 (Darwin)

      [ Your GPG Public Key Here ]
      -----END PGP PUBLIC KEY BLOCK-----
    KEY
    encryption.recipients = ["joe@example.com"]
    encryption.passphrase = '1234567890'
    encryption.mode = :both
  end
    EOF
    )}
  end

  context 'with cloudfiles storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'cloudfiles',
        cloudfiles_api_key: '1234567890',
        cloudfiles_username: 'myuser',
        cloudfiles_container: 'container',
        cloudfiles_segments_container: 'segcontainer',
        cloudfiles_segment_size: 5,
        cloudfiles_path: 'backup/path'
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with CloudFiles do |cf|
    cf.api_key            = '1234567890'
    cf.username           = 'myuser'
    cf.container          = 'container'
    cf.segments_container = 'segcontainer'
    cf.segment_size       = 5
    cf.path               = 'backup/path'
  end
    EOF
    )}
  end

  context 'with dropbox storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'dropbox',
        dropbox_api_key: 'my_api_key',
        dropbox_api_secret: 'my_api_secret',
        dropbox_cache_path: '.cache',
        dropbox_access_type: 'app_folder',
        dropbox_path: '/path/to/my/backups',
        dropbox_keep: 25,
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with Dropbox do |db|
    db.api_key       = 'my_api_key'
    db.api_secret    = 'my_api_secret'
    db.cache_path    = '.cache'
    db.access_type   = :app_folder
    db.path          = '/path/to/my/backups'
    db.keep          = 25
  end
    EOF
    )}
  end

  context 'with ftp storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'ftp',
        ftp_username: 'my_username',
        ftp_password: 'my_password',
        ftp_ip: '123.45.678.90',
        ftp_port: 21,
        ftp_path: '~/backups/',
        ftp_keep: 5,
        ftp_passive_mode: false,
        ftp_timeout: 10,
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with FTP do |server|
    server.username     = 'my_username'
    server.password     = 'my_password'
    server.ip           = '123.45.678.90'
    server.port         = 21
    server.path         = '~/backups/'
    server.keep         = 5
    server.passive_mode = false
    server.timeout      = 10
  end
    EOF
    )}
  end

  context 'with local storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'local',
        local_path: '~/backups/',
        local_keep: 5,
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with Local do |local|
    local.path = '~/backups/'
    local.keep = 5
  end
    EOF
    )}
  end

  context 'with ninefold storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'ninefold',
        ninefold_storage_token: 'my_storage_token',
        ninefold_storage_secret: 'my_storage_secret',
        ninefold_path: '/path/to/my/backups',
        ninefold_keep: 10,
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with Ninefold do |nf|
    nf.storage_token   = 'my_storage_token'
    nf.storage_secret  = 'my_storage_secret'
    nf.path            = '/path/to/my/backups'
    nf.keep            = 10
  end
    EOF
    )}
  end

  context 'with scp storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'scp',
        scp_username: 'my_username',
        scp_password: 'my_password',
        scp_ip: '123.45.678.90',
        scp_port: 22,
        scp_path: '~/backups/',
        scp_keep: 5,
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with SCP do |server|
    server.username = 'my_username'
    server.password = 'my_password'
    server.ip       = '123.45.678.90'
    server.port     = 22
    server.path     = '~/backups/'
    server.keep     = 5
  end
    EOF
    )}
  end

  context 'with sftp storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'sftp',
        scp_username: 'my_username',
        scp_password: 'my_password',
        scp_ip: '123.45.678.90',
        scp_port: 22,
        scp_path: '~/backups/',
        scp_keep: 5,
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with SFTP do |server|
    server.username = 'my_username'
    server.password = 'my_password'
    server.ip       = '123.45.678.90'
    server.port     = 22
    server.path     = '~/backups/'
    server.keep     = 5
  end
    EOF
    )}
  end

  context 'with rsync storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 'rsync',
        rsync_mode: 'ssh',
        rsync_host: '123.45.678.90',
        rsync_port: 22,
        rsync_ssh_user: 'ssh_username',
        rsync_additional_ssh_options: "-i '/path/to/id_rsa'",
        rsync_user: 'rsync_username',
        rsync_password: 'my_password',
        rsync_password_file: '/path/to/password_file',
        rsync_additional_rsync_options: ["--sparse", "--exclude='some_pattern'"],
        rsync_compress: true,
        rsync_path: '~/backups',
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with RSync do |storage|
    storage.mode = :ssh
    storage.host = '123.45.678.90'
    storage.port = 22
    storage.ssh_user = 'ssh_username'
    storage.additional_ssh_options = "-i '/path/to/id_rsa'"
    storage.rsync_user = 'rsync_username'
    storage.rsync_password = 'my_password'
    storage.rsync_password_file = '/path/to/password_file'
    storage.additional_rsync_options = ["--sparse", "--exclude='some_pattern'"]
    storage.compress = true
    storage.path = '~/backups'
  end
    EOF
    )}
  end

  context 'with s3 storage' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_storage: 's3',
        s3_access_key_id: 'my_access_key_id',
        s3_secret_access_key: 'my_secret_access_key',
        s3_use_iam_profile: true,
        s3_region: 'us-east-1',
        s3_bucket: 'bucket-name',
        s3_path: 'path/to/backups'
      }
    }

    it { should contain_concat__fragment('model-my_model-storage').with_content(<<-EOF
  store_with S3 do |s3|
    s3.access_key_id      = 'my_access_key_id'
    s3.secret_access_key  = 'my_secret_access_key'
    s3.use_iam_profile    = true
    s3.region             = 'us-east-1'
    s3.bucket             = 'bucket-name'
    s3.path               = 'path/to/backups'
  end
    EOF
    )}
  end

  context 'with cloudfiles syncing' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_syncer: 'cloudfiles',
        cloudfiles_api_key: '1234567890',
        cloudfiles_username: 'myuser',
        cloudfiles_container: 'container',
        cloudfiles_segments_container: 'segcontainer',
        cloudfiles_segment_size: 5,
        cloudfiles_path: 'backup/path',
        cloudfiles_mirror: true,
        cloudfiles_thread_count: 10,
        cloudfiles_add: [
          "/path/to/directory/to/sync",
          "/path/to/other/directory/to/sync"
        ],
        cloudfiles_exclude: [
          '**/*~'
        ]
      }
    }

    it { should contain_concat__fragment('model-my_model-syncer').with_content(<<-EOF
  store_with Cloud::CloudFiles do |cf|
    cf.api_key            = '1234567890'
    cf.username           = 'myuser'
    cf.container          = 'container'
    cf.segments_container = 'segcontainer'
    cf.segment_size       = 5
    cf.path               = 'backup/path'
    cf.mirror             = true
    cf.thread_count       = 10
    cf.directories do |directory|
      directory.add '/path/to/directory/to/sync'
      directory.add '/path/to/other/directory/to/sync'
      directory.exclude '**/*~'
    end
  end
    EOF
    )}
  end

  context 'with rsync syncing' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_syncer: 'rsync',
        rsync_mode: 'ssh',
        rsync_host: '123.45.678.90',
        rsync_port: 22,
        rsync_ssh_user: 'ssh_username',
        rsync_additional_ssh_options: "-i '/path/to/id_rsa'",
        rsync_user: 'rsync_username',
        rsync_password: 'my_password',
        rsync_password_file: '/path/to/password_file',
        rsync_additional_rsync_options: ["--sparse", "--exclude='some_pattern'"],
        rsync_compress: true,
        rsync_path: '~/backups',
        rsync_mirror: true,
        rsync_archive: true,
        rsync_add: [
          "/path/to/directory/to/sync",
          "/path/to/other/directory/to/sync"
        ],
        rsync_exclude: [
          '**/*~'
        ]
      }
    }

    it { should contain_concat__fragment('model-my_model-syncer').with_content(<<-EOF
  store_with Cloud::RSync do |rsync|
    rsync.mode = :ssh
    rsync.host = '123.45.678.90'
    rsync.port = 22
    rsync.ssh_user = 'ssh_username'
    rsync.additional_ssh_options = "-i '/path/to/id_rsa'"
    rsync.rsync_user = 'rsync_username'
    rsync.rsync_password = 'my_password'
    rsync.rsync_password_file = '/path/to/password_file'
    rsync.additional_rsync_options = ["--sparse", "--exclude='some_pattern'"]
    rsync.compress = true
    rsync.path = '~/backups'
    rsync.mirror = true
    rsync.archive = true
    rsync.directories do |directory|
      directory.add '/path/to/directory/to/sync'
      directory.add '/path/to/other/directory/to/sync'
      directory.exclude '**/*~'
    end
  end
    EOF
    )}
  end

  context 'with s3 syncing' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_syncer: 's3',
        s3_access_key_id: 'my_access_key_id',
        s3_secret_access_key: 'my_secret_access_key',
        s3_use_iam_profile: true,
        s3_region: 'us-east-1',
        s3_bucket: 'bucket-name',
        s3_path: 'path/to/backups',
        s3_mirror: true,
        s3_thread_count: 10,
        s3_add: [
          "/path/to/directory/to/sync",
          "/path/to/other/directory/to/sync"
        ],
        s3_exclude: [
          '**/*~'
        ]
      }
    }

    it { should contain_concat__fragment('model-my_model-syncer').with_content(<<-EOF
  store_with Cloud::S3 do |s3|
    s3.access_key_id      = 'my_access_key_id'
    s3.secret_access_key  = 'my_secret_access_key'
    s3.use_iam_profile    = true
    s3.region             = 'us-east-1'
    s3.bucket             = 'bucket-name'
    s3.path               = 'path/to/backups'
    s3.mirror             = true
    s3.thread_count       = 10
    s3.directories do |directory|
      directory.add '/path/to/directory/to/sync'
      directory.add '/path/to/other/directory/to/sync'
      directory.exclude '**/*~'
    end
  end
    EOF
    )}
  end

  context 'with ses notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'ses',
        ses_access_key_id: '12345',
        ses_secret_access_key: '12345',
        ses_region: 'eu-west-1',
        ses_from: 'test@example.com',
        ses_to: 'receiver@example.com',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-ses').with_content(<<-EOF
  notify_by Ses do |ses|
    ses.on_warning = true
    ses.on_failure = true
    ses.access_key_id = '12345'
    ses.secret_access_key = '12345'
    ses.region = 'eu-west-1'
    ses.from = 'test@example.com'
    ses.to = 'receiver@example.com'
  end
    EOF
    )}
  end

  context 'with command notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'command',
        cmd_on_success: true,
        cmd_on_warning: true,
        cmd_on_failure: true,
        cmd_command: 'notify-send',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-command').with_content(<<-EOF
  notify_by Command do |cmd|
    cmd.on_success = true
    cmd.on_warning = true
    cmd.on_failure = true
    cmd.command = 'notify-send'
  end
    EOF
    )}
  end

  context 'with campfire notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'campfire',
        campfire_on_success: true,
        campfire_on_warning: true,
        campfire_on_failure: true,
        campfire_api_token: 'my_token',
        campfire_subdomain: 'my_subdomain',
        campfire_room_id: 'the_room_id',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-campfire').with_content(<<-EOF
  notify_by Campfire do |campfire|
    campfire.on_success = true
    campfire.on_warning = true
    campfire.on_failure = true
    campfire.api_token = 'my_token'
    campfire.subdomain = 'my_subdomain'
    campfire.room_id   = 'the_room_id'
  end
    EOF
    )}
  end

  context 'with datadog notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'datadog',
        datadog_on_success: true,
        datadog_on_warning: true,
        datadog_on_failure: true,
        datadog_api_key: 'my_api_key',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-datadog').with_content(<<-EOF
  notify_by DataDog do |datadog|
    datadog.on_success           = true
    datadog.on_warning           = true
    datadog.on_failure           = true
    datadog.api_key              = 'my_api_key'
  end
    EOF
    )}
  end

  context 'with flowdock notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'flowdock',
        flowdock_on_success: true,
        flowdock_on_warning: true,
        flowdock_on_failure: true,
        flowdock_token: 'token',
        flowdock_from_name: 'my_name',
        flowdock_from_email: 'email@example.com',
        flowdock_subject: 'My Daily Backup',
        flowdock_source: 'Backup',
        flowdock_tags: ['prod', 'backup'],
        flowdock_link: 'www.example.com',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-flowdock').with_content(<<-EOF
  notify_by FlowDock do |flowdock|
    flowdock.on_success = true
    flowdock.on_warning = true
    flowdock.on_failure = true
    flowdock.token      = 'token'
    flowdock.from_name  = 'my_name'
    flowdock.from_email = 'email@example.com'
    flowdock.subject    = 'My Daily Backup'
    flowdock.source     = 'Backup'
    flowdock.tags       = ["prod", "backup"]
    flowdock.link       = 'www.example.com'
  end
    EOF
    )}
  end

  context 'with hipchat notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'hipchat',
        hipchat_on_success: true,
        hipchat_on_warning: true,
        hipchat_on_failure: true,
        hipchat_success_color: 'green',
        hipchat_warning_color: 'yellow',
        hipchat_failure_color: 'red',
        hipchat_token: 'hipchat api token',
        hipchat_from: 'DB Backup',
        hipchat_rooms_notified: ['activity'],
        hipchat_api_version: 'v1',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-hipchat').with_content(<<-EOF
  notify_by Hipchat do |hipchat|
    hipchat.on_success = true
    hipchat.on_warning = true
    hipchat.on_failure = true
    hipchat.success_color = 'green'
    hipchat.warning_color = 'yellow'
    hipchat.failure_color = 'red'
    hipchat.token = 'hipchat api token'
    hipchat.from = 'DB Backup'
    hipchat.rooms_notified = ["activity"]
    hipchat.api_version = 'v1'
  end
    EOF
    )}
  end

  context 'with HTTP POST notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'http_post',
        http_post_on_success: true,
        http_post_on_warning: true,
        http_post_on_failure: true,
        http_post_uri: 'https://user:pass@your.domain.com:8443/path'
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-http_post').with_content(<<-EOF
  notify_by HttpPost do |post|
    post.on_success = true
    post.on_warning = true
    post.on_failure = true
    post.uri = 'https://user:pass@your.domain.com:8443/path'
  end
    EOF
    )}
  end

  context 'with mail notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'mail',
        mail_on_success: true,
        mail_on_warning: true,
        mail_on_failure: true,
        mail_from: 'sender@email.com',
        mail_to: 'receiver@email.com',
        mail_cc: 'cc@email.com',
        mail_bcc: 'bcc@email.com',
        mail_reply_to: 'reply_to@email.com',
        mail_address: 'smtp.gmail.com',
        mail_port: 587,
        mail_domain: 'your.host.name',
        mail_user_name: 'sender@email.com',
        mail_password: 'my_password',
        mail_authentication: 'plain',
        mail_encryption: 'starttls',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-mail').with_content(<<-EOF
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true
    mail.from                 = 'sender@email.com'
    mail.to                   = 'receiver@email.com'
    mail.cc                   = 'cc@email.com'
    mail.bcc                  = 'bcc@email.com'
    mail.reply_to             = 'reply_to@email.com'
    mail.address              = 'smtp.gmail.com'
    mail.port                 = 587
    mail.domain               = 'your.host.name'
    mail.user_name            = 'sender@email.com'
    mail.password             = 'my_password'
    mail.authentication       = 'plain'
    mail.encryption           = :starttls
  end
    EOF
    )}
  end

  context 'with nagios notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'nagios',
        nagios_on_success: true,
        nagios_on_warning: true,
        nagios_on_failure: true,
        nagios_host: 'nagioshost',
        nagios_port: 5667,
        nagios_service_name: 'My Backup',
        nagios_service_host: 'backuphost',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-nagios').with_content(<<-EOF
  notify_by Nagios do |nagios|
    nagios.on_success = true
    nagios.on_warning = true
    nagios.on_failure = true
    nagios.nagios_host  = 'nagioshost'
    nagios.nagios_port  = 5667
    nagios.service_name = 'My Backup'
    nagios.service_host = 'backuphost'
  end
    EOF
    )}
  end

  context 'with pagerduty notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'pagerduty',
        pagerduty_on_success: true,
        pagerduty_on_warning: true,
        pagerduty_on_failure: true,
        pagerduty_service_key: '0123456789abcdef01234567890abcde',
        pagerduty_resolve_on_warning: true,
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-pagerduty').with_content(<<-EOF
  notify_by PagerDuty do |pagerduty|
    pagerduty.on_success = true
    pagerduty.on_warning = true
    pagerduty.on_failure = true
    pagerduty.service_key = '0123456789abcdef01234567890abcde'
    pagerduty.resolve_on_warning = true
  end
    EOF
    )}
  end

  context 'with prowl notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'prowl',
        prowl_on_success: true,
        prowl_on_warning: true,
        prowl_on_failure: true,
        prowl_application: 'my_application',
        prowl_api_key: 'my_api_key',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-prowl').with_content(<<-EOF
  notify_by Prowl do |prowl|
    prowl.on_success = true
    prowl.on_warning = true
    prowl.on_failure = true
    prowl.application = 'my_application'
    prowl.api_key     = 'my_api_key'
  end
    EOF
    )}
  end

  context 'with pushover notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'pushover',
        pushover_on_success: true,
        pushover_on_warning: true,
        pushover_on_failure: true,
        pushover_user: 'USER_KEY',
        pushover_token: 'API_KEY',
        pushover_title: 'The message title',
        pushover_device: 'The device identifier',
        pushover_priority: '1',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-pushover').with_content(<<-EOF
  notify_by Pushover do |pushover|
    pushover.on_success = true
    pushover.on_warning = true
    pushover.on_failure = true
    pushover.user = 'USER_KEY'
    pushover.token = 'API_KEY'
    pushover.title = 'The message title'
    pushover.device = 'The device identifier'
    pushover.priority = '1'
  end
    EOF
    )}
  end

  context 'with slack notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'slack',
        slack_on_success: true,
        slack_on_warning: true,
        slack_on_failure: true,
        slack_webhook_url: 'my_webhook_url',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-slack').with_content(<<-EOF
  notify_by Slack do |slack|
    slack.on_success = true
    slack.on_warning = true
    slack.on_failure = true
    slack.webhook_url = 'my_webhook_url'
  end
    EOF
    )}
  end

  context 'with twitter notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'twitter',
        twitter_on_success: true,
        twitter_on_warning: true,
        twitter_on_failure: true,
        twitter_consumer_key: 'my_consumer_key',
        twitter_consumer_secret: 'my_consumer_secret',
        twitter_oauth_token: 'my_oauth_token',
        twitter_oauth_token_secret: 'my_oauth_token_secret',
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-twitter').with_content(<<-EOF
  notify_by Twitter do |tweet|
    tweet.on_success = true
    tweet.on_warning = true
    tweet.on_failure = true
    tweet.consumer_key       = 'my_consumer_key'
    tweet.consumer_secret    = 'my_consumer_secret'
    tweet.oauth_token        = 'my_oauth_token'
    tweet.oauth_token_secret = 'my_oauth_token_secret'
  end
    EOF
    )}
  end

  context 'with zabbix notification' do
    let(:params) {
      {
        attributes: 'archive',
        archive_add: '/var/www',
        use_notifier: 'zabbix',
        zabbix_on_success: true,
        zabbix_on_warning: true,
        zabbix_on_failure: true,
        zabbix_host: 'zabbix_server_hostname',
        zabbix_port: 10051,
        zabbix_service_name: 'Backup trigger',
        zabbix_service_host: 'zabbix_host',
        zabbix_item_key: 'backup_status'
      }
    }

    it { should contain_concat__fragment('model-my_model-notifier-zabbix').with_content(<<-EOF
  notify_by Zabbix do |zabbix|
    zabbix.on_success = true
    zabbix.on_warning = true
    zabbix.on_failure = true
    zabbix.zabbix_host  = 'zabbix_server_hostname'
    zabbix.zabbix_port  = 10051
    zabbix.service_name = 'Backup trigger'
    zabbix.service_host = 'zabbix_host'
    zabbix.item_key     = 'backup_status'
  end
    EOF
    )}
  end
end
