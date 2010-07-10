namespace :cruise do
  task :init do
    rm "vendor/plugins/db-charmer"
    sh "./script/bundler_setup"
    sh "./script/plugin install git://github.com/kovyrin/db-charmer.git"
    sh "cp config/database.yml.example config/database.yml"
    ENV['RAILS_ENV'] = RAILS_ENV = 'test'
  end

  task :master => %w(cruise:init db:migrate spec)
end
