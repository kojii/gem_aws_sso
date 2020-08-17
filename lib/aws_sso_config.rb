require 'tty-prompt'

# config file controller
class Config
  def initialize
    @prompt = TTY::Prompt.new
    @path = "#{ENV['HOME']}/.aws_sso"
    @config_list = {
      organization: {
        display_name: 'Organization Name',
        default_value: 'ga-tech'
      },
      profile: {
        display_name: 'AWS Profile Name',
        default_value: 'aws_sso'
      },
      region: {
        display_name: 'AWS SSO Region',
        default_value: 'us-east-1'
      },
      client: {
        display_name: 'Client Name',
        default_value: 'my-computer'
      }
    }
    read_or_create_config
    read_config
  end

  def read_or_create_config
    if File.exist?(@path)
      File.open(@path) do |f|
        @raw_config = f.read
      end
    else
      @raw_config = ''
    end
  end

  def read_config
    @config = {}
    @raw_config.split("\n").each do |r|
      next unless r.include?('=')

      r = r.split('=')
      @config[r[0].to_sym] = r[1]
    end
  end

  def prompt_ask(question, default_value)
    @prompt.ask(question, default: default_value)
  end

  def input_config
    @config_list.each do |k, v|
      @config[k] = prompt_ask("#{v[:display_name]}:", (@config[k] or v[:default_value]))
    end
  end

  def write_config
    File.open(@path, 'w') do |f|
      @config.each do |k, v|
        f.write("#{k}=#{v}\n")
      end
    end
  end

  def check_config
    passed = true
    @config_list.keys.each do |k|
      next if @config.key?(k)

      passed = false
      break
    end
    passed
  end

  def new_config
    input_config
    write_config
    @config
  end

  def current_config
    if check_config
      @config
    else
      new_config
    end
  end
end
