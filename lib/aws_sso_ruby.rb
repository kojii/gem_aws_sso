require "aws_sso_ruby/version"
require "aws_sso_ruby/cli"

require 'aws_sso_login'
require 'aws_sso_config'

module AwsSsoRuby
  class Error < StandardError; end
  # Config Handler
  class Configure
    def initialize
      config = Config.new
      config.new_config
    end
  end

  # AWS SSO Handler
  class SSO
    def initialize
      config = Config.new
      conf = config.current_config
      @aws_sso = AwsSSO.new(conf)
    end

    def auth
      @aws_sso.pre_login
      @aws_sso.login
    end
  end
end
