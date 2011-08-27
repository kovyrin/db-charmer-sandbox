source 'http://rubygems.org'

gem 'rails', '2.2.3'

gem 'rake'
gem 'mysql'

gem 'rspec', '1.3.2'
gem 'rspec-rails', '1.3.4'

# Load DbCharmer as a gem
if File.exists?("vendor/db-charmer")
  gem 'db-charmer', :path => 'vendor/db-charmer', :require => 'db_charmer'
else
  gem 'db-charmer', :git => 'git://github.com/kovyrin/db-charmer.git', :require => 'db_charmer'
end
