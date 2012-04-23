source 'http://rubygems.org'

gem 'rake'
gem 'mysql'

# Rspec gems
gem 'rspec', '1.3.2'
gem 'rspec-rails', '1.3.4'

# Load DbCharmer as a gem
if File.exists?("vendor/db-charmer")
  gem 'db-charmer', :path => 'vendor/db-charmer', :require => 'db_charmer'
else
  gem 'db-charmer', :git => 'git://github.com/kovyrin/db-charmer.git', :require => 'db_charmer'
end

# Detect Rails version we need to use
rails_version_file = File.expand_path("../.rails-version", __FILE__)
version = File.exists?(rails_version_file) && File.read(rails_version_file).chomp
version ||= ENV['RAILS_VERSION']
version ||= '2-3-stable'

# Require gems for selected rails version
case version
when /2-2-stable/
  gem "rails", '2.2.3'
when /2-3-stable/
  gem "rails", '2.3.14'
else
  gem "rails", version
end
