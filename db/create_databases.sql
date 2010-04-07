# Test databases
create database if not exists db_charmer_sandbox_test;
create database if not exists db_charmer_logs_test;

# Events shards for testing
create database if not exists db_charmer_events_test_shard01;
create database if not exists db_charmer_events_test_shard02;

# Grant privileges
grant all privieges on db_charmer_sandbox_test.* to db_charmer_ro@'localhost';

