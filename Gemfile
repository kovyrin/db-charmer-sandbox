source 'http://rubygems.org'

gem 'rails', '3.0.10'

gem 'rake'
gem 'mysql'

gem 'rspec', '2.6.0'
gem 'rspec-rails', '2.6.1'

# Load DbCharmer as a gem
if File.exists?("vendor/db-charmer")
  gem 'db-charmer', :path => 'vendor/db-charmer', :require => 'db_charmer'
else
  gem 'db-charmer', :git => 'git://github.com/kovyrin/db-charmer.git', :require => 'db_charmer'
end
