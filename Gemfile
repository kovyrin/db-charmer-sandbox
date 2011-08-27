source 'http://rubygems.org'

gem 'rails', '2.3.11'

gem 'rake'
gem 'mysql'

gem 'rspec'
gem 'rspec-rails'

# Load DbCharmer as a gem
if File.exists?("vendor/db-charmer")
  gem 'db-charmer', :path => 'vendor/db-charmer', :require => 'db_charmer'
else
  gem 'db-charmer', :git => 'git://github.com/kovyrin/db-charmer.git', :require => 'db_charmer'
end
