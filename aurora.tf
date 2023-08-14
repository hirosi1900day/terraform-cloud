data "aws_rds_engine_version" "aurora_cluster" {
  engine  = "aurora-mysql"
  version = "8.0.mysql_aurora.3.04.0"

  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql_for_replication_filter" {
  name        = "aurora-mysql"
  family      = data.aws_rds_engine_version.aurora_cluster.parameter_group_family
  description = "aurora-mysql"

  parameter {
    name         = "replicate-ignore-table"
    value        = join(",", ["db.users"])
    apply_method = "immediate"
  }

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
    Name = "aurora-mysql"
  }
}