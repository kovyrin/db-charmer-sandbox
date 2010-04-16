drop database db_charmer_sandbox_test;
create database if not exists db_charmer_sandbox_test;
drop database db_charmer_logs_test;
create database if not exists db_charmer_logs_test;
drop database db_charmer_events_test_shard01;
create database if not exists db_charmer_events_test_shard01;
drop database db_charmer_events_test_shard02;
create database if not exists db_charmer_events_test_shard02;
#grant all privieges on db_charmer_sandbox_test.* to 'db_charmer_ro'@'localhost';
