# Project-specific configuration for CruiseControl.rb

Project.configure do |project|
  project.email_notifier.emails = [ 'alexey@kovyrin.net' ]
  project.email_notifier.from = 'cc.rb@scribd.com'

  project.scheduler.polling_interval = 10.seconds
  project.build_command = 'script/cruise_build master'
  project.bundler_args.delete('--deployment') # Since we use :git for db-charmer
end
