# AwsSsoRuby

Get AWS access id & secret key via AWS SSO

## Installation

```ruby
gem install specific_install
gem specific_install -l https://github.com/ga-tech/gem_aws_sso.git
```

## Usage

### Configuration
```bash
aws_sso_ruby configure
```

### Information to be filled
|Name|Detail|Example|
|---|---|---|
|Organization|Subdomain of your AWS SSO user portal url|`ga-tech`|
|Profile|Name of the AWS profile which you would like to save your credentials in|`aws_sso`|
|region|Your AWS SSO region|`us-east-1`|
|Client|Name of the client which you login with|`my-computer`|

### Authorization
```bash
aws_sso_ruby auth
```
- You will be authorized via AWS SSO web page.
- If you have more than one AWS accounts, you will be asked to choose one of them.
- Your credentials will be saved in `[profile name]` you configured before under `~/.aws/credentials`, so please make sure you have installed awscli and configured it.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ga-tech/gem_aws_sso. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ga-tech/gem_aws_sso/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AwsSsoRuby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ga-tech/gem_aws_sso/blob/master/CODE_OF_CONDUCT.md).
