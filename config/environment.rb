# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

### Start WORKAROUND FOR WARNINGS IN RUBYGEMS
if Gem::VERSION >= "1.3.6"
    module Rails
        class GemDependency
            def requirement
                r = super
                (r == Gem::Requirement.default) ? nil : r
            end
        end
    end
end
### End WORKAROUND FOR WARNINGS IN RUBYGEMS

Rails::Initializer.run do |config|
  config.gem "RedCloth"
  config.gem "rtex"
  config.gem "authlogic"

  config.time_zone = 'UTC'
end