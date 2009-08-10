class LogRecord < ActiveRecord::Base
  db_magic :connection => :logs
end
