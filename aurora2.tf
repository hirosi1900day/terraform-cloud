data "aws_rds_engine_version" "aurora_cluster_for_test" {
  engine  = "aurora-mysql"
  version = "8.0.mysql_aurora.3.06.0"

  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }
}

resource "aws_db_parameter_group" "aurora_mysql_for_test" {
  name   = "test-aurora-mysql-for-test"
  family = data.aws_rds_engine_version.aurora_cluster_for_test.parameter_group_family

  tags = {
    Name = "test-aurora-mysql-for-test"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql_for_test" {
  name        = "test-aurora-mysql-for-test"
  family      = data.aws_rds_engine_version.aurora_cluster_for_test.parameter_group_family
  description = "test-aurora-mysql-for-test"

  parameter {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "connect_timeout"
    value        = "30"
    apply_method = "immediate"
  }

  parameter {
    name         = "group_concat_max_len"
    value        = "10240"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = "3600"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_lru_scan_depth"
    value        = "256"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_open_files"
    value        = "-1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = "16777216"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_connections"
    value        = "{DBInstanceClassMemory/6291440}"
    apply_method = "immediate"
  }

  parameter {
    name         = "max_heap_table_size"
    value        = "268435456"
    apply_method = "immediate"
  }

  parameter {
    name         = "slow_launch_time"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "thread_cache_size"
    value        = "{DBInstanceClassMemory/50331520}"
    apply_method = "immediate"
  }

  parameter {
    name         = "tmp_table_size"
    value        = "268435456"
    apply_method = "immediate"
  }

  # TODO: aurora v3へアップグレード時にtransaction_isolationに変更する必要がある
  #       https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Reference.ParameterGroups.html
  parameter {
    name         = "transaction_isolation"
    value        = "READ-COMMITTED"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "long_query_time"
    value        = "10"
    apply_method = "immediate"
  }

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  tags = {
    Name = "test-aurora-mysql-for-test"
  }
}

resource "aws_rds_cluster" "rds_cluster_for_test" {
  engine             = data.aws_rds_engine_version.aurora_cluster_for_test.engine
  engine_version     = data.aws_rds_engine_version.aurora_cluster_for_test.version
  cluster_identifier = "test-cluster-for-test"
  storage_encrypted  = true
  # kms_key_id                      = aws_kms_key.rds.arn
  backup_retention_period     = 1
  preferred_backup_window     = "17:00-17:30"
  port                        = 3306
  skip_final_snapshot         = true
  deletion_protection         = false
  allow_major_version_upgrade = true
  apply_immediately           = true
  # vpc_security_group_ids          = [aws_security_group.rds.id]
  database_name                   = "mydb"
  master_username                 = "foo"
  master_password                 = "barcdacsd8932csdcd"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql_for_test.name
  enabled_cloudwatch_logs_exports = [
    "error",
    "slowquery"
  ]

  tags = {
    Name = "test-cluster-for-test"
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instance_for_test" {
  count                        = 1
  identifier                   = "test-for-test-${count.index + 1}"
  engine                       = aws_rds_cluster.rds_cluster_for_test.engine
  instance_class               = "db.t4g.medium"
  monitoring_interval          = "0"
  cluster_identifier           = aws_rds_cluster.rds_cluster_for_test.id
  db_parameter_group_name      = aws_db_parameter_group.aurora_mysql_for_test.name
  apply_immediately            = true
  auto_minor_version_upgrade   = false
  performance_insights_enabled = false

  tags = {
    Name = "test-for-test-${count.index + 1}"
  }
}