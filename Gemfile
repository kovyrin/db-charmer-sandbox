source 'http://rubygems.org'

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
rails_version_file = File.expand_path("../.rails-version", __FILE__)
case version = ENV['RAILS_VERSION'] || File.exists?(rails_version_file) && File.read(rails_version_file).chomp || '3-2-stable'
when /master/
  gem "rails", :git => "git://github.com/rails/rails.git"
  gem "arel", :git => "git://github.com/rails/arel.git"
  gem "journey", :git => "git://github.com/rails/journey.git"
when /3-0-stable/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => "3-0-stable"
  gem "arel",  :git => "git://github.com/rails/arel.git", :branch => "2-0-stable"
when /3-1-stable/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => "3-1-stable"
when /3-2-stable/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => "3-2-stable"
  gem "journey", :git => "git://github.com/rails/journey.git"
else
  gem "rails", version
end
