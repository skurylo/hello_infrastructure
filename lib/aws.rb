#!/usr/bin/env ruby
require 'aws-sdk'
require 'open-uri'
require 'ipaddr'

config_file = File.join(File.dirname(__FILE__), "../.secrets/config.yml")
AWS.config(YAML.load(File.read(config_file)))

ec2 = AWS::EC2.new(:ec2_endpoint => 'ec2.us-west-1.amazonaws.com')

# Import first ssh key from ssh-agent
private_key = %x{ssh-add -L|head -n1}.chomp
begin
  ec2.key_pairs.import(ENV['USER'],private_key)
rescue AWS::EC2::Errors::InvalidKeyPair::Duplicate
end

# Get our local external IP
ip = open('http://ifconfig.me/ip').readline.chomp + '/32'
begin
  IPAddr.new ip
rescue IPAddr::InvalidAddressError
  STDERR.puts 'Could not find external IP, using 0.0.0.0 for firewall'
  ip = '0.0.0.0/0'
end

# Allow ssh access from our IP
sg = ec2.security_groups.filter('group-name','default').first
begin
  sg.authorize_ingress :tcp, 22, ip
rescue AWS::EC2::Errors::InvalidPermission::Duplicate
end

# Get the latest Ubuntu image
owner = '099720109477' # Canonical ID per https://help.ubuntu.com/community/EC2StartersGuide
name = '*ubuntu/images/ebs/ubuntu-trusty-*'
ami_id = nil
AWS.memoize do
  ami = ec2.images.with_owner(owner).
    filter('root-device-type', 'ebs').
    filter('architecture', 'x86_64').
    filter('name', name).first
  puts 'Did not find an AMI' if ami.nil?
  ami_id = ami.id
end

instance = ec2.instances.create(
  :image_id => ami_id,
  :instance_type => 't1.micro',
  :count => 1,
  :security_groups => sg.name,
  :key_pair => ec2.key_pairs[ENV['USER']])

sleep 10 while instance.status == :pending
puts instance.ip_ipaddress
