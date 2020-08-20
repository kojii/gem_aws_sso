# AwsSsoRuby

Get AWS access id & secret key via AWS SSO

## Installation

```ruby
gem install specific_install
gem specific_install -l https://github.com/ga-tech/gem_aws_sso.git
```

## Usage

### Configuration
```sh
aws_sso_ruby configure
```

- Information to be filled

|Name|Detail|Example|
|---|---|---|
|Organization|Subdomain of your AWS SSO user portal url|`ga-tech`|
|Profile|Name of the AWS profile which you would like to save your credentials in|`aws_sso`|
|Region|Your AWS SSO region|`us-east-1`|
|Client|Name of the client which you login with|`my-computer`|

- Configuration file will be saved at `~/.aws_sso`

### Authorization
```sh
aws_sso_ruby auth
```
- You will be authorized via AWS SSO web page.
- If you have more than one AWS accounts, you will be asked to choose one of them.
- Your credentials will be saved in `[profile name]` you configured before under `~/.aws/credentials`, so please make sure you have installed [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) it.

### How to use credentials(examples)

- Docker Compose
```dockerfile
version: '3.8'
  ・・・
  app:
    ...
    environment:
      ...
      - AWS_PROFILE=aws_sso # ← Specify AWS profile(default: aws_sso)
    volumes:
      ...
      - aws_credentials:/root/.aws  # Mount volume aws_credential to path `/root/.aws`
volumes:
  ...
  aws_credentials: # Set `${HOME}/.aws` as volume `aws_credentials`
    driver_opts:
      type: none
      device: ${HOME}/.aws
      o: bind
```
- AWSCLI
```sh
aws s3 ls --profile aws_sso
```
- Ruby
```ruby
require 'aws-sdk-s3'

client = Aws::S3::Client.new(profile: 'aws_sso')
client.list_buckets.to_h
```
- Python
```python
import boto3

client = boto3.session.Session(profile_name='aws_sso).client('s3')
client.list_buckets()
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ga-tech/gem_aws_sso. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ga-tech/gem_aws_sso/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AwsSsoRuby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ga-tech/gem_aws_sso/blob/master/CODE_OF_CONDUCT.md).
