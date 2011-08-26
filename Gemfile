source 'http://rubygems.org'

gem 'rails', '3.0.10'

gem 'rake'
gem 'mysql'

gem 'rspec', '2.6.0'
gem 'rspec-rails', '2.6.1'
gem 'test-unit', '2.3.2'

# Test-unit requires this gem.
# We stick to this version because newer ones require ne rubygems which we do not have on our CI server yet.
gem 'hoe', '2.8.0'

# Load DbCharmer as a gem
if File.exists?("vendor/db-charmer")
  gem 'db-charmer', :path => 'vendor/db-charmer', :require => 'db_charmer'
else
  gem 'db-charmer', :git => 'git://github.com/kovyrin/db-charmer.git', :branch => 'rails3', :require => 'db_charmer'
end
