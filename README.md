# DbCharmer Sandbox - Tests for DbCharmer Gem

This is a sandbox/testing project for the DbCharmer plugin: http://github.com/kovyrin/db-charmer

## Continuous Integration

CI is running on TravisCI.org: http://travis-ci.org/#!/kovyrin/db-charmer-sandbox/builds

At the moment we have the following build matrix:

* Rails versions:
  - 2.2.3  ![Build Status: rails 2.2](https://secure.travis-ci.org/kovyrin/db-charmer-sandbox.png?branch=rails22)
  - 2.3.14 ![Build Status: rails 2.3](https://secure.travis-ci.org/kovyrin/db-charmer-sandbox.png?branch=rails22)
  - 3.x ![Build Status: rails 3.x](https://secure.travis-ci.org/kovyrin/db-charmer-sandbox.png?branch=master)
* Ruby versions:
  - 1.8.7
  - Ruby Enterprise Edition (1.8.7)
  - 1.9.3 (Rails 3 only since older versions do not support new ruby releases)
* Databases:
  - MySQL

If you have any questions regarding this project, please contact the author or join our mailing list: http://groups.google.com/group/db-charmer
