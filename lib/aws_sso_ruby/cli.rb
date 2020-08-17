require "aws_sso_ruby"
require "thor"

module AwsSsoRuby
  class CLI < Thor
    desc "configure", "Configure AWS SSO login information"
    def configure
      AwsSsoRuby::Configure.new
    end

    desc "auth", "Get AWS account credentials via AWS SSO"
    def auth
      AwsSsoRuby::SSO.new.auth
    end
  end
end
