require 'aws-sdk-sso'
require 'aws-sdk-ssooidc'
require 'tty-prompt'

# AWS SSO cli login helper
class AwsSSO
  def initialize(config)
    @client = config[:client]
    @organization = config[:organization]
    @region = config[:region]
    @profile = config[:profile]

    @prompt = TTY::Prompt.new
    @ssooidc = Aws::SSOOIDC::Client.new(region: @region)
    @sso = Aws::SSO::Client.new(region: @region)
    @path = "#{ENV['HOME']}/.aws"
  end

  def register_client
    @register = @ssooidc.register_client(
      client_name: @client,
      client_type: 'public'
    )
  end

  def device_authorization
    @auth = @ssooidc.start_device_authorization(
      client_id: @register.client_id,
      client_secret: @register.client_secret,
      start_url: "https://#{@organization}.awsapps.com/start"
    )
    Kernel.system("open #{@auth.verification_uri_complete}")
    print 'Waiting for authentication via browser...'
  end

  def sso_token
    @token = @ssooidc.create_token(
      client_id: @register.client_id,
      client_secret: @register.client_secret,
      grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
      device_code: @auth.device_code,
      code: @auth.device_code
    )
    puts 'success!'
  end

  def accounts
    @sso.list_accounts(
      access_token: @token.access_token
    ).account_list
  end

  def account_roles(account_id)
    @sso.list_account_roles(
      account_id: account_id,
      access_token: @token.access_token
    ).role_list
  end

  def role_credentials(account_id, role_name)
    @sso.get_role_credentials(
      role_name: role_name,
      account_id: account_id,
      access_token: @token.access_token
    ).role_credentials
  end

  def pre_login
    @accessable_account_roles = []
    register_client
    device_authorization

    @passed = false
    until @passed
      sleep(5)
      begin
        sso_token
        @passed = true
      rescue Aws::SSOOIDC::Errors::AuthorizationPendingException
        print '.'
      end
    end

    accounts.each do |account|
      role_list = account_roles(account.account_id)
      role_list.each do |role|
        @accessable_account_roles.push(
          {
            display_name: "#{account.account_name} (#{account.account_id}) / #{role.role_name}",
            account_id: account.account_id,
            role_name: role.role_name
          }
        )
      end
    end
  end

  def generate_credentials
    if @accessable_account_roles.length <= 1
      idx = 0
    else
      choices = []
      @accessable_account_roles.each_with_index do |account_role, index|
        choices.push("[#{index}] #{account_role[:display_name]}")
      end
      idx = @prompt.select('Choose a account to login:', choices).scan(/\[(.*)\]/)[0][0].to_i
    end
    if @accessable_account_roles.empty?
      puts 'No available account.'
      profile_text = nil
    else
      credential = role_credentials(
        @accessable_account_roles[idx][:account_id],
        @accessable_account_roles[idx][:role_name]
      )
      profile_text = <<~TEXT
        [#{@profile}]
        aws_access_key_id     = #{credential.access_key_id}
        aws_secret_access_key = #{credential.secret_access_key}
        aws_session_token     = #{credential.session_token}

      TEXT
      puts "Credentials generated for profile #{@profile} (expires_at: #{Time.strptime(credential.expiration.to_s, '%Q')})"
    end
    profile_text
  end

  def update_credentials(profile_text)
    aws_credential_path = "#{@path}/credentials"
    if File.exist?(aws_credential_path)
      File.open(aws_credential_path) do |f|
        @credentials = f.read
      end
    else
      @credentials = ''
    end

    lines = @credentials.split("\n")
    target = nil

    lines.each_with_index do |line, index|
      next unless line == "[#{@profile}]"

      target = [line]
      current_idx = index + 1
      next_line = lines[current_idx]
      break if next_line.nil?

      while next_line.scan(/^\[.*\]$/).empty?
        target.push(lines[current_idx])
        current_idx += 1
        next_line = lines[current_idx]
        break if next_line.nil?
      end
    end

    if target.nil?
      @credentials += "\n#{profile_text}"
    else
      @credentials = @credentials.gsub(target.compact.join("\n"), profile_text)
    end
    @credentials = @credentials.gsub(/\n{3,}/, "\n" * 2).gsub(/\n+$/, "\n")
    File.open(aws_credential_path, 'w') do |f|
      f.write(@credentials)
    end
  end

  def login
    profile_text = generate_credentials
    update_credentials(profile_text)
  end

  def logout
    @sso.logout(
      access_token: @token.access_token
    )
  end
end
