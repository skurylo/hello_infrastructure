#!/usr/bin/env ruby
require 'aws-sdk'
require 'open-uri'
require 'ipaddr'


class EC2
  def initialize
    config_file = File.join(File.dirname(__FILE__), "../.secrets/config.yml")
    AWS.config(YAML.load(File.read(config_file)))
    @ec2 = AWS::EC2.new(:ec2_endpoint => 'ec2.us-west-1.amazonaws.com')

    # Import first ssh key from ssh-agent
    private_key = %x{ssh-add -L|head -n1}.chomp
    begin
      @ec2.key_pairs.import(ENV['USER'],private_key)
    rescue AWS::EC2::Errors::InvalidKeyPair::Duplicate
    end
  end

  # Get our local external IP
  def allow_ssh(sg)
    if not (defined? @ip2 and @ip2 != '0.0.0.0/0')
      @ip = open('http://ifconfig.me/ip').readline.chomp + '/32'
    end
    begin
      IPAddr.new @ip
    rescue IPAddr::InvalidAddressError
      STDERR.puts 'Could not find external IP, using 0.0.0.0 for firewall'
      @ip = '0.0.0.0/0'
    end
    # Allow ssh access from our IP
    begin
      sg.authorize_ingress :tcp, 22, ip
    rescue AWS::EC2::Errors::InvalidPermission::Duplicate
    end
  end

  def create(count=1)
    sg = @ec2.security_groups.filter('group-name','default').first
    self.allow_ssh(sg)
    # Get the latest Ubuntu image
    owner = '099720109477' # Canonical ID per https://help.ubuntu.com/community/EC2StartersGuide
    name = '*ubuntu/images/ebs/ubuntu-trusty-*'
    ami_id = nil
    AWS.memoize do
      ami = @ec2.images.with_owner(owner).
        filter('root-device-type', 'ebs').
        filter('architecture', 'x86_64').
        filter('name', name).first
      puts 'Did not find an AMI' if ami.nil?
      ami_id = ami.id
    end

    i = 0
    instances = []
    while i < count do
      i += 1
      instance = @ec2.instances.create(
        :image_id => ami_id,
        :instance_type => 't1.micro',
        :count => 1,
        :security_groups => sg.name,
        :key_pair => @ec2.key_pairs[ENV['USER']])
      instances.push instance
    end
    instances.each { |v|
      sleep 10 while v.status == :pending
    }
    return instances
  end

  # Release all ec2 resources
  def clean
     # Delete IPs
     @ec2.elastic_ips.each { |ip| ip.delete }
     # Terminate instances
     @ec2.instances.each { |i| i.delete }
  end
end

if __FILE__ == $0
  ec2 = EC2.new
  ec2.create().each { |instance|
    puts instance.ip_address
  }
end

