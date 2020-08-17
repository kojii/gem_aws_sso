require_relative 'lib/aws_sso_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_sso_ruby"
  spec.version       = AwsSsoRuby::VERSION
  spec.authors       = ["査炳然"]
  spec.email         = ["h_sa@ga-tech.co.jp"]

  spec.summary       = "Get your AWS CLI credentials via AWS SSO"
  spec.homepage      = "https://github.com/ga-tech/gem_aws_sso"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ga-tech/gem_aws_sso"
  spec.metadata["changelog_uri"] = "https://github.com/ga-tech/gem_aws_sso"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "aws-sdk-sso"
  spec.add_dependency "aws-sdk-ssooidc"
end