drop database if exists db_charmer_sandbox22_test;
create database db_charmer_sandbox22_test;

drop database if exists db_charmer_logs22_test;
create database db_charmer_logs22_test;

drop database if exists db_charmer_events22_test_shard01;
create database db_charmer_events22_test_shard01;

drop database if exists db_charmer_events22_test_shard02;
create database db_charmer_events22_test_shard02;

grant all privileges on db_charmer_sandbox22_test.* to 'db_charmer_ro'@'localhost';
