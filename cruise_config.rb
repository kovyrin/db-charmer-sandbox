# Project-specific configuration for CruiseControl.rb

Project.configure do |project|
  project.email_notifier.emails = [ 'kovyrin@gmail.com' ]
  project.email_notifier.from = 'cc.rb@scribd.com'

  project.scheduler.polling_interval = 10.seconds
  project.rake_task = 'cruise:master'
end
