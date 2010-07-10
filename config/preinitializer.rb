# Bundler version we depend on. If you planning to change it,
# do not forget to update Gemfile and script/bundler_setup as well
SCRIBD_BUNDLER_VERSION = '0.9.26'
SCRIBD_BUNDLER_SETUP   = 'script/bundler_setup'

require 'rubygems'

#-------------------------------------------------------------------------------
# Load Bundler

begin
  # Ensure correct Bundler version is being loaded
  gem 'bundler', SCRIBD_BUNDLER_VERSION
  require 'bundler'
rescue LoadError
  raise RuntimeError, "Could not load the bundler gem. Install it with `#{SCRIBD_BUNDLER_SETUP}`."
end

#-------------------------------------------------------------------------------
# Setup Bundler

# Temporary swith stderr to the newly created StringIO object.
# This is because bundler sometimes aborts with message, suggesting
# to use `bundle install`, while we use script/bundler_install
old_stderr, new_stderr = $stderr, StringIO.new
begin
  # Set up load paths for all bundled gems
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
  begin
    $stderr = new_stderr
    Bundler.setup
  ensure
    $stderr = old_stderr
  end
rescue Bundler::GemNotFound
  abort "Bundler couldn't find some gems. Did you run `#{SCRIBD_BUNDLER_SETUP}`?"
rescue Exception => e
  abort e.message.gsub(/`bundle install/, "`#{SCRIBD_BUNDLER_SETUP}").gsub(/`bundle lock/, "`#{SCRIBD_BUNDLER_SETUP} --relock")
end
$stderr << new_stderr.string
